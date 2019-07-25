Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5879F74BA9
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 12:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfGYKeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 06:34:18 -0400
Received: from www.linuxtv.org ([130.149.80.248]:57531 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfGYKeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 06:34:18 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.84_2)
        (envelope-from <mchehab@linuxtv.org>)
        id 1hqb4i-0000Oo-5Y; Thu, 25 Jul 2019 10:34:16 +0000
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Date:   Thu, 25 Jul 2019 10:31:30 +0000
Subject: [git:media_tree/master] media: vivid: fix device init when no_error_inj=1 and fb disabled
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1hqb4i-0000Oo-5Y@www.linuxtv.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: vivid: fix device init when no_error_inj=1 and fb disabled
Author:  Guillaume Tucker <guillaume.tucker@collabora.com>
Date:    Wed Jul 24 11:19:22 2019 -0400

Add an extra condition to add the video output control class when the
device has some hdmi outputs defined.  This is required to then always
be able to add the display present control, which is enabled when
there are some hdmi outputs.

This fixes the corner case where no_error_inj is enabled and the
device has no frame buffer but some hdmi outputs, as otherwise the
video output control class would be added anyway.  Without this fix,
the sanity checks fail in v4l2_ctrl_new() as name is NULL.

Fixes: c533435ffb91 ("media: vivid: add display present control")
Cc: stable@vger.kernel.org # for 5.3
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

 drivers/media/platform/vivid/vivid-ctrls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index fb9220e4e640..cb19a9a73092 100644
--- a/drivers/media/platform/vivid/vivid-ctrls.c
+++ b/drivers/media/platform/vivid/vivid-ctrls.c
@@ -1473,7 +1473,7 @@ int vivid_create_controls(struct vivid_dev *dev, bool show_ccs_cap,
 	v4l2_ctrl_handler_init(hdl_vid_cap, 55);
 	v4l2_ctrl_new_custom(hdl_vid_cap, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vid_out, 26);
-	if (!no_error_inj || dev->has_fb)
+	if (!no_error_inj || dev->has_fb || dev->num_hdmi_outputs)
 		v4l2_ctrl_new_custom(hdl_vid_out, &vivid_ctrl_class, NULL);
 	v4l2_ctrl_handler_init(hdl_vbi_cap, 21);
 	v4l2_ctrl_new_custom(hdl_vbi_cap, &vivid_ctrl_class, NULL);
