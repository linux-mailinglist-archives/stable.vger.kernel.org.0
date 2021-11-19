Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC974569F3
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 07:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhKSGOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 01:14:37 -0500
Received: from www.linuxtv.org ([130.149.80.248]:37506 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232854AbhKSGOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 01:14:36 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mnx7U-0020B7-9S; Fri, 19 Nov 2021 06:11:32 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 19 Nov 2021 06:08:52 +0000
Subject: [git:media_stage/master] media: stk1160: fix control-message timeouts
To:     linuxtv-commits@linuxtv.org
Cc:     Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mnx7U-0020B7-9S@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: stk1160: fix control-message timeouts
Author:  Johan Hovold <johan@kernel.org>
Date:    Mon Oct 25 13:16:41 2021 +0100

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: 9cb2173e6ea8 ("[media] media: Add stk1160 new driver (easycap replacement)")
Cc: stable@vger.kernel.org      # 3.7
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/stk1160/stk1160-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index b4f8bc5db138..4e1698f78818 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -65,7 +65,7 @@ int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
 		return -ENOMEM;
 	ret = usb_control_msg(dev->udev, pipe, 0x00,
 			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			0x00, reg, buf, sizeof(u8), HZ);
+			0x00, reg, buf, sizeof(u8), 1000);
 	if (ret < 0) {
 		stk1160_err("read failed on reg 0x%x (%d)\n",
 			reg, ret);
@@ -85,7 +85,7 @@ int stk1160_write_reg(struct stk1160 *dev, u16 reg, u16 value)
 
 	ret =  usb_control_msg(dev->udev, pipe, 0x01,
 			USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
-			value, reg, NULL, 0, HZ);
+			value, reg, NULL, 0, 1000);
 	if (ret < 0) {
 		stk1160_err("write failed on reg 0x%x (%d)\n",
 			reg, ret);
