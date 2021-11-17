Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C6E45489B
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbhKQO0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:26:30 -0500
Received: from marcansoft.com ([212.63.210.85]:48524 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238401AbhKQOZP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:25:15 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id E295B419B4;
        Wed, 17 Nov 2021 14:22:11 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Hector Martin <marcan@marcan.st>, stable@vger.kernel.org
Subject: [PATCH] drm/format-helper: Fix dst computation in drm_fb_xrgb8888_to_rgb888_dstclip()
Date:   Wed, 17 Nov 2021 23:22:06 +0900
Message-Id: <20211117142206.197575-1-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The dst pointer was being advanced by the clip width, not the full line
stride, resulting in corruption. The clip offset was also calculated
incorrectly.

Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/gpu/drm/drm_format_helper.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_format_helper.c b/drivers/gpu/drm/drm_format_helper.c
index e676921422b8..12bc6b45e95b 100644
--- a/drivers/gpu/drm/drm_format_helper.c
+++ b/drivers/gpu/drm/drm_format_helper.c
@@ -366,12 +366,12 @@ void drm_fb_xrgb8888_to_rgb888_dstclip(void __iomem *dst, unsigned int dst_pitch
 		return;
 
 	vaddr += clip_offset(clip, fb->pitches[0], sizeof(u32));
-	dst += clip_offset(clip, dst_pitch, sizeof(u16));
+	dst += clip_offset(clip, dst_pitch, 3);
 	for (y = 0; y < lines; y++) {
 		drm_fb_xrgb8888_to_rgb888_line(dbuf, vaddr, linepixels);
 		memcpy_toio(dst, dbuf, dst_len);
 		vaddr += fb->pitches[0];
-		dst += dst_len;
+		dst += dst_pitch;
 	}
 
 	kfree(dbuf);
-- 
2.33.0

