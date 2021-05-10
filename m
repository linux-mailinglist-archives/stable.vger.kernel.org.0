Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C6378458
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbhEJKvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233492AbhEJKuI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A296162D;
        Mon, 10 May 2021 10:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643136;
        bh=1s7zG+opQmdVGNdmgz7kGgq4vv8ggW+wB6M1alua5zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9hi1WogJG9UNR1qCWUf4XnLTADBbiqESe0w3yBzsDh2BdSnL2MTsgvsSOZvzmHuk
         pstnER7+XzWXHHtjfLr07Ejvzh42JsextvrqANPox4VDMcJDOXY5smAmWOrC2Yokyf
         U7kFHgyCL/UbfSe5q7mH4XQeVgal67nQPXs9P3UQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Anson Jacob <Anson.Jacob@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Jun Lei <Jun.Lei@amd.com>, Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/299] drm/amd/display: Fix UBSAN: shift-out-of-bounds warning
Date:   Mon, 10 May 2021 12:19:48 +0200
Message-Id: <20210510102011.260112477@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Jacob <Anson.Jacob@amd.com>

[ Upstream commit 54718747a6e1037317a8b3610c3be40621b2b75e ]

[Why]
On NAVI14 CONFIG_UBSAN reported shift-out-of-bounds at
display_rq_dlg_calc_20v2.c:304:38

rq_param->misc.rq_c.blk256_height is 0 when chroma(*_c) is invalid.
dml_log2 returns -1023 for log2(0), although log2(0) is undefined.

Which ended up as:
rq_param->dlg.rq_c.swath_height = 1 << -1023

[How]
Fix applied on all dml versions.
1. Ensure dml_log2 is only called if the argument is greater than 0.
2. Subtract req128_l/req128_c from log2_swath_height_l/log2_swath_height_c
   only when it is greater than 0.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Anson Jacob <Anson.Jacob@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dc/dml/dcn20/display_rq_dlg_calc_20.c     | 28 +++++++++++++++----
 .../dc/dml/dcn20/display_rq_dlg_calc_20v2.c   | 28 +++++++++++++++----
 .../dc/dml/dcn21/display_rq_dlg_calc_21.c     | 28 +++++++++++++++----
 .../dc/dml/dcn30/display_rq_dlg_calc_30.c     | 28 +++++++++++++++----
 .../display/dc/dml/dml1_display_rq_dlg_calc.c | 28 +++++++++++++++----
 5 files changed, 115 insertions(+), 25 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
index 72423dc425dc..799bae229e67 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20.c
@@ -293,13 +293,31 @@ static void handle_det_buf_split(struct display_mode_lib *mode_lib,
 	if (surf_linear) {
 		log2_swath_height_l = 0;
 		log2_swath_height_c = 0;
-	} else if (!surf_vert) {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_height) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_height) - req128_c;
 	} else {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_width) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_width) - req128_c;
+		unsigned int swath_height_l;
+		unsigned int swath_height_c;
+
+		if (!surf_vert) {
+			swath_height_l = rq_param->misc.rq_l.blk256_height;
+			swath_height_c = rq_param->misc.rq_c.blk256_height;
+		} else {
+			swath_height_l = rq_param->misc.rq_l.blk256_width;
+			swath_height_c = rq_param->misc.rq_c.blk256_width;
+		}
+
+		if (swath_height_l > 0)
+			log2_swath_height_l = dml_log2(swath_height_l);
+
+		if (req128_l && log2_swath_height_l > 0)
+			log2_swath_height_l -= 1;
+
+		if (swath_height_c > 0)
+			log2_swath_height_c = dml_log2(swath_height_c);
+
+		if (req128_c && log2_swath_height_c > 0)
+			log2_swath_height_c -= 1;
 	}
+
 	rq_param->dlg.rq_l.swath_height = 1 << log2_swath_height_l;
 	rq_param->dlg.rq_c.swath_height = 1 << log2_swath_height_c;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
index 9c78446c3a9d..6a6d5970d1d5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_rq_dlg_calc_20v2.c
@@ -293,13 +293,31 @@ static void handle_det_buf_split(struct display_mode_lib *mode_lib,
 	if (surf_linear) {
 		log2_swath_height_l = 0;
 		log2_swath_height_c = 0;
-	} else if (!surf_vert) {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_height) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_height) - req128_c;
 	} else {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_width) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_width) - req128_c;
+		unsigned int swath_height_l;
+		unsigned int swath_height_c;
+
+		if (!surf_vert) {
+			swath_height_l = rq_param->misc.rq_l.blk256_height;
+			swath_height_c = rq_param->misc.rq_c.blk256_height;
+		} else {
+			swath_height_l = rq_param->misc.rq_l.blk256_width;
+			swath_height_c = rq_param->misc.rq_c.blk256_width;
+		}
+
+		if (swath_height_l > 0)
+			log2_swath_height_l = dml_log2(swath_height_l);
+
+		if (req128_l && log2_swath_height_l > 0)
+			log2_swath_height_l -= 1;
+
+		if (swath_height_c > 0)
+			log2_swath_height_c = dml_log2(swath_height_c);
+
+		if (req128_c && log2_swath_height_c > 0)
+			log2_swath_height_c -= 1;
 	}
+
 	rq_param->dlg.rq_l.swath_height = 1 << log2_swath_height_l;
 	rq_param->dlg.rq_c.swath_height = 1 << log2_swath_height_c;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
index edd41d358291..dc1c81a6e377 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_rq_dlg_calc_21.c
@@ -277,13 +277,31 @@ static void handle_det_buf_split(
 	if (surf_linear) {
 		log2_swath_height_l = 0;
 		log2_swath_height_c = 0;
-	} else if (!surf_vert) {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_height) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_height) - req128_c;
 	} else {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_width) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_width) - req128_c;
+		unsigned int swath_height_l;
+		unsigned int swath_height_c;
+
+		if (!surf_vert) {
+			swath_height_l = rq_param->misc.rq_l.blk256_height;
+			swath_height_c = rq_param->misc.rq_c.blk256_height;
+		} else {
+			swath_height_l = rq_param->misc.rq_l.blk256_width;
+			swath_height_c = rq_param->misc.rq_c.blk256_width;
+		}
+
+		if (swath_height_l > 0)
+			log2_swath_height_l = dml_log2(swath_height_l);
+
+		if (req128_l && log2_swath_height_l > 0)
+			log2_swath_height_l -= 1;
+
+		if (swath_height_c > 0)
+			log2_swath_height_c = dml_log2(swath_height_c);
+
+		if (req128_c && log2_swath_height_c > 0)
+			log2_swath_height_c -= 1;
 	}
+
 	rq_param->dlg.rq_l.swath_height = 1 << log2_swath_height_l;
 	rq_param->dlg.rq_c.swath_height = 1 << log2_swath_height_c;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c
index 416bf6fb67bd..58c312f80a07 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_rq_dlg_calc_30.c
@@ -237,13 +237,31 @@ static void handle_det_buf_split(struct display_mode_lib *mode_lib,
 	if (surf_linear) {
 		log2_swath_height_l = 0;
 		log2_swath_height_c = 0;
-	} else if (!surf_vert) {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_height) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_height) - req128_c;
 	} else {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_width) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_width) - req128_c;
+		unsigned int swath_height_l;
+		unsigned int swath_height_c;
+
+		if (!surf_vert) {
+			swath_height_l = rq_param->misc.rq_l.blk256_height;
+			swath_height_c = rq_param->misc.rq_c.blk256_height;
+		} else {
+			swath_height_l = rq_param->misc.rq_l.blk256_width;
+			swath_height_c = rq_param->misc.rq_c.blk256_width;
+		}
+
+		if (swath_height_l > 0)
+			log2_swath_height_l = dml_log2(swath_height_l);
+
+		if (req128_l && log2_swath_height_l > 0)
+			log2_swath_height_l -= 1;
+
+		if (swath_height_c > 0)
+			log2_swath_height_c = dml_log2(swath_height_c);
+
+		if (req128_c && log2_swath_height_c > 0)
+			log2_swath_height_c -= 1;
 	}
+
 	rq_param->dlg.rq_l.swath_height = 1 << log2_swath_height_l;
 	rq_param->dlg.rq_c.swath_height = 1 << log2_swath_height_c;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c b/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
index 4c3e9cc30167..414da64f5734 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dml1_display_rq_dlg_calc.c
@@ -344,13 +344,31 @@ static void handle_det_buf_split(
 	if (surf_linear) {
 		log2_swath_height_l = 0;
 		log2_swath_height_c = 0;
-	} else if (!surf_vert) {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_height) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_height) - req128_c;
 	} else {
-		log2_swath_height_l = dml_log2(rq_param->misc.rq_l.blk256_width) - req128_l;
-		log2_swath_height_c = dml_log2(rq_param->misc.rq_c.blk256_width) - req128_c;
+		unsigned int swath_height_l;
+		unsigned int swath_height_c;
+
+		if (!surf_vert) {
+			swath_height_l = rq_param->misc.rq_l.blk256_height;
+			swath_height_c = rq_param->misc.rq_c.blk256_height;
+		} else {
+			swath_height_l = rq_param->misc.rq_l.blk256_width;
+			swath_height_c = rq_param->misc.rq_c.blk256_width;
+		}
+
+		if (swath_height_l > 0)
+			log2_swath_height_l = dml_log2(swath_height_l);
+
+		if (req128_l && log2_swath_height_l > 0)
+			log2_swath_height_l -= 1;
+
+		if (swath_height_c > 0)
+			log2_swath_height_c = dml_log2(swath_height_c);
+
+		if (req128_c && log2_swath_height_c > 0)
+			log2_swath_height_c -= 1;
 	}
+
 	rq_param->dlg.rq_l.swath_height = 1 << log2_swath_height_l;
 	rq_param->dlg.rq_c.swath_height = 1 << log2_swath_height_c;
 
-- 
2.30.2



