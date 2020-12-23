Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D292E1794
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgLWDLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:11:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbgLWCSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A554225AB;
        Wed, 23 Dec 2020 02:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689810;
        bh=/7XnkCswcGrDkxD0ylLEam1G7JqZX7l36sqXLiQzRuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qgceC9ARD+1lRvrohFCo7cWcohNLxjMXnAX7HdwYtWME0hvzTuClVbd/0uKOZWO8w
         AKLOfG9jDGUibTjCAb61qZ+r2lc+O0qhV/tkQ6iI3VeRgq+3Mf2ECi/rvUlg2s/dbG
         jiCMT15MC97aH/vMKq5sR+RpI4WYe49KNQa6gBh2PI+VwTX1asAjL7+oLd3WiMPAWS
         bIpbSy3I8crCsLint7C0aJmJlSDPPQxyOHFacHCpjPvKu1m2+585fYINu2JFRNR7ff
         XGgp8D43b7eys0jVSmGAF6gPY9hIX7JreSj9SgDH/0Fpduav6YBmB73dO0jJGOaU3A
         0HQXYHGRbMtAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Tao.Huang" <Tao.Huang@amd.com>,
        Florin Iucha <florin.iucha@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 018/217] drm/amd/display: Fix compilation error
Date:   Tue, 22 Dec 2020 21:13:07 -0500
Message-Id: <20201223021626.2790791-18-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Tao.Huang" <Tao.Huang@amd.com>

[ Upstream commit 585e7cedf304ce76410c922e632bef04fd316ead ]

[Why]
The C standard does not specify whether an enum is signed or unsigned.
In the function prototype, one of the argument is defined as an enum
but its declaration was unit32_t. Fix this by changing the function
argument to enum in the declaration.

Signed-off-by: Tao.Huang <Tao.Huang@amd.com>
Signed-off-by: Florin Iucha <florin.iucha@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.h | 2 +-
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c     | 6 +++---
 drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h     | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.h b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.h
index 7f6bedbc1ff10..81bf2ecc28314 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.h
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.h
@@ -585,7 +585,7 @@ void dpp3_cm_set_gamut_remap(
 		const struct dpp_grph_csc_adjustment *adjust);
 
 void dpp3_set_pre_degam(struct dpp *dpp_base,
-		uint32_t degamma_lut_selection);
+		enum dc_transfer_func_predefined tr);
 
 void dpp3_set_cursor_attributes(
 		struct dpp *dpp_base,
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
index 4da21966ddcec..c6a1cd80aeae4 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
+++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.c
@@ -51,7 +51,7 @@ static void get_qp_set(qp_set qps, enum colour_mode cm, enum bits_per_comp bpc,
 	const struct qp_entry *table = 0L;
 
 	// alias enum
-	enum { min = MM_MIN, max = MM_MAX };
+	enum { min = DAL_MM_MIN, max = DAL_MM_MAX };
 	switch (sel) {
 		TABLE_CASE(444,  8, max);
 		TABLE_CASE(444,  8, min);
@@ -233,8 +233,8 @@ static void _do_calc_rc_params(struct rc_params *rc, enum colour_mode cm,
 	rc->flatness_max_qp     = ((bpc == BPC_8) ? (12) : ((bpc == BPC_10) ? (16) : (20))) - ((minor_version == 1 && cm == CM_444) ? 1 : 0);
 	rc->flatness_det_thresh = 2 << (bpc - 8);
 
-	get_qp_set(rc->qp_min, cm, bpc, MM_MIN, bpp);
-	get_qp_set(rc->qp_max, cm, bpc, MM_MAX, bpp);
+	get_qp_set(rc->qp_min, cm, bpc, DAL_MM_MIN, bpp);
+	get_qp_set(rc->qp_max, cm, bpc, DAL_MM_MAX, bpp);
 	if (cm == CM_444 && minor_version == 1) {
 		for (i = 0; i < QP_SET_SIZE; ++i) {
 			rc->qp_min[i] = rc->qp_min[i] > 0 ? rc->qp_min[i] - 1 : 0;
diff --git a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
index 21723fa6561eb..8123827840c58 100644
--- a/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
+++ b/drivers/gpu/drm/amd/display/dc/dsc/rc_calc.h
@@ -66,8 +66,8 @@ enum bits_per_comp {
 };
 
 enum max_min {
-	MM_MIN = 0,
-	MM_MAX = 1
+	DAL_MM_MIN = 0,
+	DAL_MM_MAX = 1
 };
 
 struct qp_entry {
-- 
2.27.0

