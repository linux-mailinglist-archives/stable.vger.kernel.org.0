Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B619F7961D
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390448AbfG2Tsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390175AbfG2Tsw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:48:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3216205F4;
        Mon, 29 Jul 2019 19:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429731;
        bh=WGMYS6q83Thcael11V87cslMUvmVDRsxbyMeEMFWzbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Je3UnRYdJnaD5suk3+k1xGfqnn1yCqqlwv6mQ8C8HTmg8VVRBg6PEUGt4TMOE4Pz4
         98A0AYUGoK1yha+i6evhEUkxTgIs+zlYH3OPMGztPPG0sWx88hm84Lbdm4L1MIRISR
         Q85iFya4tZNucMp2dKVlv69ToD+I6HsnUbSMBFyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krunoslav Kovac <Krunoslav.Kovac@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 038/215] drm/amd/display: CS_TFM_1D only applied post EOTF
Date:   Mon, 29 Jul 2019 21:20:34 +0200
Message-Id: <20190729190747.058926921@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6ad34adeaec5b56a5ba90e90099cabf1c1fe9dd2 ]

[Why]
There's some unnecessary mem allocation for CS_TFM_ID. What's worse, it
depends on LUT size and since it's 4K for CS_TFM_1D, it is 16x bigger
than in regular case when it's actually needed. This leads to some
crashes in stress conditions.

[How]
Skip ramp combining designed for RGB256 and DXGI gamma with CS_TFM_1D.

Signed-off-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/color/color_gamma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
index a1055413bade..31f867bb5afe 100644
--- a/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
+++ b/drivers/gpu/drm/amd/display/modules/color/color_gamma.c
@@ -1564,7 +1564,8 @@ bool mod_color_calculate_regamma_params(struct dc_transfer_func *output_tf,
 
 	output_tf->type = TF_TYPE_DISTRIBUTED_POINTS;
 
-	if (ramp && (mapUserRamp || ramp->type != GAMMA_RGB_256)) {
+	if (ramp && ramp->type != GAMMA_CS_TFM_1D &&
+			(mapUserRamp || ramp->type != GAMMA_RGB_256)) {
 		rgb_user = kvcalloc(ramp->num_entries + _EXTRA_POINTS,
 			    sizeof(*rgb_user),
 			    GFP_KERNEL);
-- 
2.20.1



