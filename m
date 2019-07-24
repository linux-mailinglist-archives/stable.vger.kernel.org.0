Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864877329D
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 17:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387503AbfGXPUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 11:20:06 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33574 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfGXPUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 11:20:06 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gtucker)
        with ESMTPSA id AF18728B4E7
From:   Guillaume Tucker <guillaume.tucker@collabora.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        stable@vger.kernel.org
Subject: [PATCH] media: vivid: fix device init when no_error_inj=1 and fb disabled
Date:   Wed, 24 Jul 2019 16:19:22 +0100
Message-Id: <20190724151922.11124-1-guillaume.tucker@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add an extra condition to add the video output control class when the
device has some hdmi outputs defined.  This is required to then always
be able to add the display present control, which is enabled when
there are some hdmi outputs.

This fixes the corner case where no_error_inj is enabled and the
device has no frame buffer but some hdmi outputs, as otherwise the
video output control class would be added anyway.  Without this fix,
the sanity checks fail in v4l2_ctrl_new() as name is NULL.

Fixes: c533435ffb91 ("media: vivid: add display present control")
Cc: stable@vger.kernel.org
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
---
 drivers/media/platform/vivid/vivid-ctrls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vivid/vivid-ctrls.c b/drivers/media/platform/vivid/vivid-ctrls.c
index 3e916c8befb7..7a52f585cab7 100644
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
-- 
2.20.1

