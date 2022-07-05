Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C2C566A8B
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232919AbiGEMA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232803AbiGEMAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:00:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7CA17E1A;
        Tue,  5 Jul 2022 05:00:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0134617B0;
        Tue,  5 Jul 2022 12:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F33C341C7;
        Tue,  5 Jul 2022 12:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022406;
        bh=ZN8+uRs5APM5boRIUc32C4EweShCfPrlV3ERh7NNzEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLztnbHSAvktNbR9PaXzq5Kqkt2G6pz2BhoXwdrJ2zmIi7ZceQPsK1dSobjEZgoju
         hyIeWfe3b98je69XAAgl3ZEVnH1M3swZOmuff7jtDNxQWAR3J1y4FK0nzxtWSbzrfD
         teehVweEM9GN5VXTGoQL88OL+m9GXybi1y5zFnPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.9 05/29] usbnet: make sure no NULL pointer is passed through
Date:   Tue,  5 Jul 2022 13:57:46 +0200
Message-Id: <20220705115605.903898317@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115605.742248854@linuxfoundation.org>
References: <20220705115605.742248854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 6c22fce07c97f765af1808ec3be007847e0b47d1 upstream.

Coverity reports:

** CID 751368:  Null pointer dereferences  (FORWARD_NULL)
/drivers/net/usb/usbnet.c: 1925 in __usbnet_read_cmd()

________________________________________________________________________________________________________
---
 drivers/net/usb/usbnet.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1951,7 +1951,7 @@ static int __usbnet_read_cmd(struct usbn
 		   " value=0x%04x index=0x%04x size=%d\n",
 		   cmd, reqtype, value, index, size);
 
-	if (data) {
+	if (size) {
 		buf = kmalloc(size, GFP_KERNEL);
 		if (!buf)
 			goto out;
@@ -1960,8 +1960,13 @@ static int __usbnet_read_cmd(struct usbn
 	err = usb_control_msg(dev->udev, usb_rcvctrlpipe(dev->udev, 0),
 			      cmd, reqtype, value, index, buf, size,
 			      USB_CTRL_GET_TIMEOUT);
-	if (err > 0 && err <= size)
-		memcpy(data, buf, err);
+	if (err > 0 && err <= size) {
+        if (data)
+            memcpy(data, buf, err);
+        else
+            netdev_dbg(dev->net,
+                "Huh? Data requested but thrown away.\n");
+    }
 	kfree(buf);
 out:
 	return err;
@@ -1982,7 +1987,13 @@ static int __usbnet_write_cmd(struct usb
 		buf = kmemdup(data, size, GFP_KERNEL);
 		if (!buf)
 			goto out;
-	}
+	} else {
+        if (size) {
+            WARN_ON_ONCE(1);
+            err = -EINVAL;
+            goto out;
+        }
+    }
 
 	err = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 			      cmd, reqtype, value, index, buf, size,


