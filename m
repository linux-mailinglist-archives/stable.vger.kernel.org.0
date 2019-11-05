Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDADF67CF
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 07:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfKJGmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Nov 2019 01:42:53 -0500
Received: from www.linuxtv.org ([130.149.80.248]:56101 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfKJGmx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Nov 2019 01:42:53 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1iTgvx-0005G0-1p; Sun, 10 Nov 2019 06:42:49 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Tue, 05 Nov 2019 11:50:34 +0000
Subject: [git:media_tree/master] media: radio: wl1273: fix interrupt masking on release
To:     linuxtv-commits@linuxtv.org
Cc:     Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        stable <stable@vger.kernel.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1iTgvx-0005G0-1p@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: radio: wl1273: fix interrupt masking on release
Author:  Johan Hovold <johan@kernel.org>
Date:    Thu Oct 10 10:13:32 2019 -0300

If a process is interrupted while accessing the radio device and the
core lock is contended, release() could return early and fail to update
the interrupt mask.

Note that the return value of the v4l2 release file operation is
ignored.

Fixes: 87d1a50ce451 ("[media] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.38
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/radio/radio-wl1273.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

---

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 104ac41c6f96..112376873167 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1148,8 +1148,7 @@ static int wl1273_fm_fops_release(struct file *file)
 	if (radio->rds_users > 0) {
 		radio->rds_users--;
 		if (radio->rds_users == 0) {
-			if (mutex_lock_interruptible(&core->lock))
-				return -EINTR;
+			mutex_lock(&core->lock);
 
 			radio->irq_flags &= ~WL1273_RDS_EVENT;
 
