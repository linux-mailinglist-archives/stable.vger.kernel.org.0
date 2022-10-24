Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB8F60A3C5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiJXMA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbiJXL7V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:59:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4624B76566;
        Mon, 24 Oct 2022 04:48:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D9B16125D;
        Mon, 24 Oct 2022 11:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6102BC433C1;
        Mon, 24 Oct 2022 11:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612088;
        bh=AigwrwtcfRO68yBZHTNgX6TxImqDnWA9jhU6WuQ3pdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wxu7A8C+aARCPx6R6pHGrNnJSAXGaJoBL7z6u4GXzzRenPbVO8QxR1Wur53dCnC5P
         IBH7GVqLuWxS3j0eQI+ns6FVobtS+aTCvv1FK3yFiDQcP6wrtR/+Chw1EMS3hwi3v4
         2vMx4Kj7FV10KrJyyz94gXog7l+Zhtqgw6RWKnr8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunwoo Kim <imv4bel@gmail.com>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 064/210] fbdev: smscufx: Fix use-after-free in ufx_ops_open()
Date:   Mon, 24 Oct 2022 13:29:41 +0200
Message-Id: <20221024112959.111451423@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
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
@@ -140,6 +140,8 @@ static int ufx_submit_urb(struct ufx_dat
 static int ufx_alloc_urb_list(struct ufx_data *dev, int count, size_t size);
 static void ufx_free_urb_list(struct ufx_data *dev);
 
+static DEFINE_MUTEX(disconnect_mutex);
+
 /* reads a control register */
 static int ufx_reg_read(struct ufx_data *dev, u32 index, u32 *data)
 {
@@ -1073,9 +1075,13 @@ static int ufx_ops_open(struct fb_info *
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
 
@@ -1100,6 +1106,8 @@ static int ufx_ops_open(struct fb_info *
 	pr_debug("open /dev/fb%d user=%d fb_info=%p count=%d",
 		info->node, user, info, dev->fb_count);
 
+	mutex_unlock(&disconnect_mutex);
+
 	return 0;
 }
 
@@ -1762,6 +1770,8 @@ static void ufx_usb_disconnect(struct us
 {
 	struct ufx_data *dev;
 
+	mutex_lock(&disconnect_mutex);
+
 	dev = usb_get_intfdata(interface);
 
 	pr_debug("USB disconnect starting\n");
@@ -1782,6 +1792,8 @@ static void ufx_usb_disconnect(struct us
 	kref_put(&dev->kref, ufx_free);
 
 	/* consider ufx_data freed */
+
+	mutex_unlock(&disconnect_mutex);
 }
 
 static struct usb_driver ufx_driver = {


