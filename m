Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EEF452221
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350426AbhKPBKJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:10:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244916AbhKOTSO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5D126342D;
        Mon, 15 Nov 2021 18:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000731;
        bh=bp8XQciujjx2tduNWt7kp6MnhtEOcBX9budyB4cej3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1/XOUFgM/1k5rhAimDFXIPjoqqRF1cDFeDOpfst1T/w9jVBBipO3U3RdGnnGVTRo
         KsS3zRtclh2ZcMjOTppY32SQCFZm/oz2ZNtuDzh8ZkW7zpMljGyd3f/sBiPuNIeMUO
         uw1pTvdLLu4MCak7TIp43syFOWr6oUY02PGCC8r8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 770/849] drm/i915/fb: Fix rounding error in subsampled plane size calculation
Date:   Mon, 15 Nov 2021 18:04:13 +0100
Message-Id: <20211115165446.309483174@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 90ab96f3872eae816f4e07deaa77322a91237960 ]

For NV12 FBs with odd main surface tile-row height the CCS surface
height was incorrectly calculated 1 less than the actual value. Fix this
by rounding up the result of divison. For consistency do the same for
the CCS surface width calculation.

Fixes: b3e57bccd68a ("drm/i915/tgl: Gen-12 render decompression")
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211026225105.2783797-2-imre.deak@intel.com
(cherry picked from commit 2ee5ef9c934ad26376c9282171e731e6c0339815)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_fb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_fb.c b/drivers/gpu/drm/i915/display/intel_fb.c
index c60a81a81c09c..c6413c5409420 100644
--- a/drivers/gpu/drm/i915/display/intel_fb.c
+++ b/drivers/gpu/drm/i915/display/intel_fb.c
@@ -172,8 +172,9 @@ static void intel_fb_plane_dims(const struct intel_framebuffer *fb, int color_pl
 
 	intel_fb_plane_get_subsampling(&main_hsub, &main_vsub, &fb->base, main_plane);
 	intel_fb_plane_get_subsampling(&hsub, &vsub, &fb->base, color_plane);
-	*w = fb->base.width / main_hsub / hsub;
-	*h = fb->base.height / main_vsub / vsub;
+
+	*w = DIV_ROUND_UP(fb->base.width, main_hsub * hsub);
+	*h = DIV_ROUND_UP(fb->base.height, main_vsub * vsub);
 }
 
 static u32 intel_adjust_tile_offset(int *x, int *y,
-- 
2.33.0



