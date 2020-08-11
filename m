Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1078B242142
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 22:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgHKU1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 16:27:00 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:36366 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbgHKU07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 16:26:59 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: alyssa)
        with ESMTPSA id 85BD329916D
From:   Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
To:     dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, stable@vger.kernel.org,
        hjc@rock-chips.com, heiko@sntech.de, airlied@linux.ie,
        daniel@ffwll.ch, andrzej.p@collabora.com, daniels@collabora.com
Cc:     Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Subject: [PATCH] drm/rockchip: Require the YTR modifier for AFBC
Date:   Tue, 11 Aug 2020 16:26:31 -0400
Message-Id: <20200811202631.3603-1-alyssa.rosenzweig@collabora.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The AFBC decoder used in the Rockchip VOP assumes the use of the
YUV-like colourspace transform (YTR). YTR is lossless for RGB(A)
buffers, which covers the RGBA8 and RGB565 formats supported in
vop_convert_afbc_format. Use of YTR is signaled with the
AFBC_FORMAT_MOD_YTR modifier, which prior to this commit was missing. As
such, a producer would have to generate buffers that do not use YTR,
which the VOP would erroneously decode as YTR, leading to severe visual
corruption.

The upstream AFBC support was developed against a captured frame, which
failed to exercise modifier support. Prior to bring-up of AFBC in Mesa
(in the Panfrost driver), no open userspace respected modifier
reporting. As such, this change is not expected to affect broken
userspaces.

Tested on RK3399 with Panfrost and Weston.

Signed-off-by: Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
index 4a2099cb5..857d97cdc 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.h
@@ -17,9 +17,20 @@
 
 #define NUM_YUV2YUV_COEFFICIENTS 12
 
+/* AFBC supports a number of configurable modes. Relevant to us is block size
+ * (16x16 or 32x8), storage modifiers (SPARSE, SPLIT), and the YUV-like
+ * colourspace transform (YTR). 16x16 SPARSE mode is always used. SPLIT mode
+ * could be enabled via the hreg_block_split register, but is not currently
+ * handled. The colourspace transform is implicitly always assumed by the
+ * decoder, so consumers must use this transform as well.
+ *
+ * Failure to match modifiers will cause errors displaying AFBC buffers
+ * produced by conformant AFBC producers, including Mesa.
+ */
 #define ROCKCHIP_AFBC_MOD \
 	DRM_FORMAT_MOD_ARM_AFBC( \
 		AFBC_FORMAT_MOD_BLOCK_SIZE_16x16 | AFBC_FORMAT_MOD_SPARSE \
+			| AFBC_FORMAT_MOD_YTR \
 	)
 
 enum vop_data_format {
-- 
2.28.0

