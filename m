Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D43E497204
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiAWOVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiAWOVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:21:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF6DC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:21:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AD5BB80CF5
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7116DC340E4;
        Sun, 23 Jan 2022 14:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642947688;
        bh=7vf9Ly9X/C4xjp+agM/aDQrucf23VT+JA/Iig5na4n8=;
        h=Subject:To:Cc:From:Date:From;
        b=AmzBHyIEq2edU/N0+VXm5l2qseO0b+0C/qwZW7qc6yPXhbgSpOkPIqSdgYQBDAHYW
         403RW7b9vZn+RKDulNDNjSzRkjrRazHPjJYLIqSLO2XqCwcIu0bWfIuwP334l2mla8
         fRc2ADFnov2ABTY+8nqYLcSOm+QTWvt1t6Fw1DyY=
Subject: FAILED: patch "[PATCH] media: s2255: fix control-message timeouts" failed to apply to 4.4-stable tree
To:     johan@kernel.org, hverkuil-cisco@xs4all.nl,
        mchehab+huawei@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:21:26 +0100
Message-ID: <164294768617537@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f71d272ad4e354097020a4e6b1dc6e4b59feb50f Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 25 Oct 2021 13:16:40 +0100
Subject: [PATCH] media: s2255: fix control-message timeouts

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout define for the five-second
timeouts.

Fixes: 38f993ad8b1f ("V4L/DVB (8125): This driver adds support for the Sensoray 2255 devices.")
Cc: stable@vger.kernel.org      # 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 3b0e4ed75d99..acf18e2251a5 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -1882,7 +1882,7 @@ static long s2255_vendor_req(struct s2255_dev *dev, unsigned char Request,
 				    USB_TYPE_VENDOR | USB_RECIP_DEVICE |
 				    USB_DIR_IN,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 
 		if (r >= 0)
 			memcpy(TransferBuffer, buf, TransferBufferLength);
@@ -1891,7 +1891,7 @@ static long s2255_vendor_req(struct s2255_dev *dev, unsigned char Request,
 		r = usb_control_msg(dev->udev, usb_sndctrlpipe(dev->udev, 0),
 				    Request, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				    Value, Index, buf,
-				    TransferBufferLength, HZ * 5);
+				    TransferBufferLength, USB_CTRL_SET_TIMEOUT);
 	}
 	kfree(buf);
 	return r;

