Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7748460A6E9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiJXMly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbiJXMkS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8027E821;
        Mon, 24 Oct 2022 05:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D804612D7;
        Mon, 24 Oct 2022 12:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA09C433C1;
        Mon, 24 Oct 2022 12:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613166;
        bh=NC/Z+V26eeA1Z3iEnYZiVxYZPA1qrFYiKABdDWYzFEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPJ24wAoPhO50LMRrwk4lW5a2v2FyAzOL1lL1Df0dnzEzWVi80yi+cIyjqH4nLF13
         E0oNId2qYmCiVzzmQ2D7ZKbtETtBen2hjCqrR3mey92Z/hcbfbL1Px7bpkZZ9ecXPg
         /3EARK5/mCqPvGHWaerB5UTRJARzlSXp1sOmSkVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunwoo Kim <imv4bel@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 034/255] fbdev: smscufx: Fix use-after-free in ufx_ops_open()
Date:   Mon, 24 Oct 2022 13:29:04 +0200
Message-Id: <20221024113003.578841361@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 5610bcfe8693c02e2e4c8b31427f1bdbdecc839c upstream.

A race condition may occur if the user physically removes the
USB device while calling open() for this device node.

This is a race condition between the ufx_ops_open() function and
the ufx_usb_disconnect() function, which may eventually result in UAF.

So, add a mutex to the ufx_ops_open() and ufx_usb_disconnect() functions
to avoid race contidion of krefs.

Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/smscufx.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -137,6 +137,8 @@ static int ufx_submit_urb(struct ufx_dat
 static int ufx_alloc_urb_list(struct ufx_data *dev, int count, size_t size);
 static void ufx_free_urb_list(struct ufx_data *dev);
 
+static DEFINE_MUTEX(disconnect_mutex);
+
 /* reads a control register */
 static int ufx_reg_read(struct ufx_data *dev, u32 index, u32 *data)
 {
@@ -1070,9 +1072,13 @@ static int ufx_ops_open(struct fb_info *
 	if (user == 0 && !console)
 		return -EBUSY;
 
+	mutex_lock(&disconnect_mutex);
+
 	/* If the USB device is gone, we don't accept new opens */
-	if (dev->virtualized)
+	if (dev->virtualized) {
+		mutex_unlock(&disconnect_mutex);
 		return -ENODEV;
+	}
 
 	dev->fb_count++;
 
@@ -1096,6 +1102,8 @@ static int ufx_ops_open(struct fb_info *
 	pr_debug("open /dev/fb%d user=%d fb_info=%p count=%d",
 		info->node, user, info, dev->fb_count);
 
+	mutex_unlock(&disconnect_mutex);
+
 	return 0;
 }
 
@@ -1741,6 +1749,8 @@ static void ufx_usb_disconnect(struct us
 {
 	struct ufx_data *dev;
 
+	mutex_lock(&disconnect_mutex);
+
 	dev = usb_get_intfdata(interface);
 
 	pr_debug("USB disconnect starting\n");
@@ -1761,6 +1771,8 @@ static void ufx_usb_disconnect(struct us
 	kref_put(&dev->kref, ufx_free);
 
 	/* consider ufx_data freed */
+
+	mutex_unlock(&disconnect_mutex);
 }
 
 static struct usb_driver ufx_driver = {


