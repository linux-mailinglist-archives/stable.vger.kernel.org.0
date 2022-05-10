Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3325219D4
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244922AbiEJNvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244908AbiEJNrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB571E8E23;
        Tue, 10 May 2022 06:32:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26E7C615C8;
        Tue, 10 May 2022 13:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25ACBC385C2;
        Tue, 10 May 2022 13:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189554;
        bh=r/8WhCII/QSwBbGHS0M4iDqpyet3/YT26qUmf2G5itc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrMy6dI/LE//5W+6fRJNBXlXOOa4KzqYuEzfxxHoV+hbL46LydOdYmm9vWIAkhznj
         v4zhlZafVYytOIDSUbk9i2y7zijoc7+hA7dLVzo0T9GmcU1Jgzs+5KKS9wqqGlH6eC
         3yP5IOeda9DYopmR5FLAvcfWI5fGEtjS4im9PRUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 037/135] nfc: replace improper check device_is_registered() in netlink related functions
Date:   Tue, 10 May 2022 15:06:59 +0200
Message-Id: <20220510130741.467352394@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit da5c0f119203ad9728920456a0f52a6d850c01cd upstream.

The device_is_registered() in nfc core is used to check whether
nfc device is registered in netlink related functions such as
nfc_fw_download(), nfc_dev_up() and so on. Although device_is_registered()
is protected by device_lock, there is still a race condition between
device_del() and device_is_registered(). The root cause is that
kobject_del() in device_del() is not protected by device_lock.

   (cleanup task)         |     (netlink task)
                          |
nfc_unregister_device     | nfc_fw_download
 device_del               |  device_lock
  ...                     |   if (!device_is_registered)//(1)
  kobject_del//(2)        |   ...
 ...                      |  device_unlock

The device_is_registered() returns the value of state_in_sysfs and
the state_in_sysfs is set to zero in kobject_del(). If we pass check in
position (1), then set zero in position (2). As a result, the check
in position (1) is useless.

This patch uses bool variable instead of device_is_registered() to judge
whether the nfc device is registered, which is well synchronized.

Fixes: 3e256b8f8dfa ("NFC: add nfc subsystem core")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/core.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -38,7 +38,7 @@ int nfc_fw_download(struct nfc_dev *dev,
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -94,7 +94,7 @@ int nfc_dev_up(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -142,7 +142,7 @@ int nfc_dev_down(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -207,7 +207,7 @@ int nfc_start_poll(struct nfc_dev *dev,
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -246,7 +246,7 @@ int nfc_stop_poll(struct nfc_dev *dev)
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -291,7 +291,7 @@ int nfc_dep_link_up(struct nfc_dev *dev,
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -335,7 +335,7 @@ int nfc_dep_link_down(struct nfc_dev *de
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -401,7 +401,7 @@ int nfc_activate_target(struct nfc_dev *
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -448,7 +448,7 @@ int nfc_deactivate_target(struct nfc_dev
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -495,7 +495,7 @@ int nfc_data_exchange(struct nfc_dev *de
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		kfree_skb(skb);
 		goto error;
@@ -552,7 +552,7 @@ int nfc_enable_se(struct nfc_dev *dev, u
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -601,7 +601,7 @@ int nfc_disable_se(struct nfc_dev *dev,
 
 	device_lock(&dev->dev);
 
-	if (!device_is_registered(&dev->dev)) {
+	if (dev->shutting_down) {
 		rc = -ENODEV;
 		goto error;
 	}
@@ -1134,6 +1134,7 @@ int nfc_register_device(struct nfc_dev *
 			dev->rfkill = NULL;
 		}
 	}
+	dev->shutting_down = false;
 	device_unlock(&dev->dev);
 
 	rc = nfc_genl_device_added(dev);
@@ -1166,12 +1167,10 @@ void nfc_unregister_device(struct nfc_de
 		rfkill_unregister(dev->rfkill);
 		rfkill_destroy(dev->rfkill);
 	}
+	dev->shutting_down = true;
 	device_unlock(&dev->dev);
 
 	if (dev->ops->check_presence) {
-		device_lock(&dev->dev);
-		dev->shutting_down = true;
-		device_unlock(&dev->dev);
 		del_timer_sync(&dev->check_pres_timer);
 		cancel_work_sync(&dev->check_pres_work);
 	}


