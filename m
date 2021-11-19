Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39874569F4
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 07:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhKSGOg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 01:14:36 -0500
Received: from www.linuxtv.org ([130.149.80.248]:37508 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232714AbhKSGOg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 01:14:36 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1mnx7U-0020D1-Nb; Fri, 19 Nov 2021 06:11:32 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Fri, 19 Nov 2021 06:05:12 +0000
Subject: [git:media_stage/master] media: cpia2: fix control-message timeouts
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1mnx7U-0020D1-Nb@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: cpia2: fix control-message timeouts
Author:  Johan Hovold <johan@kernel.org>
Date:    Mon Oct 25 13:16:37 2021 +0100

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Fixes: ab33d5071de7 ("V4L/DVB (3376): Add cpia2 camera support")
Cc: stable@vger.kernel.org      # 2.6.17
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/cpia2/cpia2_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

---

diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
index 76aac06f9fb8..cba03b286473 100644
--- a/drivers/media/usb/cpia2/cpia2_usb.c
+++ b/drivers/media/usb/cpia2/cpia2_usb.c
@@ -550,7 +550,7 @@ static int write_packet(struct usb_device *udev,
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	kfree(buf);
 	return ret;
@@ -582,7 +582,7 @@ static int read_packet(struct usb_device *udev,
 			       0,	/* index */
 			       buf,	/* buffer */
 			       size,
-			       HZ);
+			       1000);
 
 	if (ret >= 0)
 		memcpy(registers, buf, size);
