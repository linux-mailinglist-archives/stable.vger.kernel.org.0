Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED98462FEE
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 10:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbhK3Jp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 04:45:57 -0500
Received: from www.linuxtv.org ([130.149.80.248]:48934 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234800AbhK3Jp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 04:45:57 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mrzen-0004e1-02; Tue, 30 Nov 2021 09:42:37 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 19 Nov 2021 06:08:32 +0000
Subject: [git:media_tree/master] media: s2255: fix control-message timeouts
To:     linuxtv-commits@linuxtv.org
Cc:     stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mrzen-0004e1-02@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: s2255: fix control-message timeouts
Author:  Johan Hovold <johan@kernel.org>
Date:    Mon Oct 25 13:16:40 2021 +0100

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout define for the five-second
timeouts.

Fixes: 38f993ad8b1f ("V4L/DVB (8125): This driver adds support for the Sensoray 2255 devices.")
Cc: stable@vger.kernel.org      # 2.6.27
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/s2255/s2255drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

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
