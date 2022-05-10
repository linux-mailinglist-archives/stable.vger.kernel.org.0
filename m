Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5718521A48
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244332AbiEJNys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244015AbiEJNwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:52:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7AF6B7CF;
        Tue, 10 May 2022 06:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FAC3B81DB1;
        Tue, 10 May 2022 13:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BAFC385C6;
        Tue, 10 May 2022 13:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189851;
        bh=r/8WhCII/QSwBbGHS0M4iDqpyet3/YT26qUmf2G5itc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUbW0eiEStVIR82gHucTw8KMJnJlUr4dFDqlIVx1/+DNwvz/c2K0jBDU5zPBxtSTK
         6vgl15xPp+xgap0Jd4rZXN4Iplb/anvx+vTINItnFBEwaige+bjtubosC8UPW0xbez
         yNyLznP39gRr1CyPFMD2t3WS7JYeMTI9GUZtBNrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.17 050/140] nfc: replace improper check device_is_registered() in netlink related functions
Date:   Tue, 10 May 2022 15:07:20 +0200
Message-Id: <20220510130743.050488097@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
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


