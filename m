Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1582F183624
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 17:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgCLQ2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 12:28:25 -0400
Received: from www.linuxtv.org ([130.149.80.248]:45840 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbgCLQ2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 12:28:25 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1jCQf7-00CCjG-4F; Thu, 12 Mar 2020 16:26:21 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Thu, 12 Mar 2020 16:25:51 +0000
Subject: [git:media_tree/master] media: ov519: add missing endpoint sanity checks
To:     linuxtv-commits@linuxtv.org
Cc:     stable <stable@vger.kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Johan Hovold <johan@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1jCQf7-00CCjG-4F@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: ov519: add missing endpoint sanity checks
Author:  Johan Hovold <johan@kernel.org>
Date:    Fri Jan 3 17:35:09 2020 +0100

Make sure to check that we have at least one endpoint before accessing
the endpoint array to avoid dereferencing a NULL-pointer on stream
start.

Note that these sanity checks are not redundant as the driver is mixing
looking up altsettings by index and by number, which need not coincide.

Fixes: 1876bb923c98 ("V4L/DVB (12079): gspca_ov519: add support for the ov511 bridge")
Fixes: b282d87332f5 ("V4L/DVB (12080): gspca_ov519: Fix ov518+ with OV7620AE (Trust spacecam 320)")
Cc: stable <stable@vger.kernel.org>     # 2.6.31
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/gspca/ov519.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

---

diff --git a/drivers/media/usb/gspca/ov519.c b/drivers/media/usb/gspca/ov519.c
index f417dfc0b872..0afe70a3f9a2 100644
--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -3477,6 +3477,11 @@ static void ov511_mode_init_regs(struct sd *sd)
 		return;
 	}
 
+	if (alt->desc.bNumEndpoints < 1) {
+		sd->gspca_dev.usb_err = -ENODEV;
+		return;
+	}
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	reg_w(sd, R51x_FIFO_PSIZE, packet_size >> 5);
 
@@ -3603,6 +3608,11 @@ static void ov518_mode_init_regs(struct sd *sd)
 		return;
 	}
 
+	if (alt->desc.bNumEndpoints < 1) {
+		sd->gspca_dev.usb_err = -ENODEV;
+		return;
+	}
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	ov518_reg_w32(sd, R51x_FIFO_PSIZE, packet_size & ~7, 2);
 
