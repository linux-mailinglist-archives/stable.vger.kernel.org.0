Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6814B26EAD4
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbgIRCBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgIRCBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:01:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 650DB21973;
        Fri, 18 Sep 2020 02:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394480;
        bh=zjJHSH1xDZxPXGtfKqQZF3rpcEEDzstMjOaW85h9Pro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kpnh7fqKGBxTg+o9Z6bnsgru9Tl8QcXRT0Cg9Lki09+G+JmfBNG+O483d+3eUJBGr
         poF68ZM9gJkF+BPeSEhDUzLKhCQ4Y/FEo1cuWog57olH4BgaPA+6mK8VuspQUmZ3Pp
         ro1G5Kk1Ccj9uV7hef9Po0BQokQXR7hrrbDc91yw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 007/330] drm/amd/display: Do not double-buffer DTO adjustments
Date:   Thu, 17 Sep 2020 21:55:47 -0400
Message-Id: <20200918020110.2063155-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit 6bd0a112ec129615d23aa5d8d3dd0be0243989aa ]

[WHY]
When changing DPP global ref clock, DTO adjustments must take effect
immediately, or else underflow may occur.
It appears the original decision to double-buffer DTO adjustments was made to
prevent underflows that occur when raising DPP ref clock (which is not
double-buffered), but that same decision causes similar issues when
lowering DPP global ref clock. The better solution is to order the
adjustments according to whether clocks are being raised or lowered.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c | 26 -------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c
index 16476ed255363..2064366322755 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c
@@ -119,32 +119,6 @@ void dccg2_get_dccg_ref_freq(struct dccg *dccg,
 
 void dccg2_init(struct dccg *dccg)
 {
-	struct dcn_dccg *dccg_dcn = TO_DCN_DCCG(dccg);
-
-	// Fallthrough intentional to program all available dpp_dto's
-	switch (dccg_dcn->base.ctx->dc->res_pool->pipe_count) {
-	case 6:
-		REG_UPDATE(DPPCLK_DTO_CTRL, DPPCLK_DTO_DB_EN[5], 1);
-		/* Fall through */
-	case 5:
-		REG_UPDATE(DPPCLK_DTO_CTRL, DPPCLK_DTO_DB_EN[4], 1);
-		/* Fall through */
-	case 4:
-		REG_UPDATE(DPPCLK_DTO_CTRL, DPPCLK_DTO_DB_EN[3], 1);
-		/* Fall through */
-	case 3:
-		REG_UPDATE(DPPCLK_DTO_CTRL, DPPCLK_DTO_DB_EN[2], 1);
-		/* Fall through */
-	case 2:
-		REG_UPDATE(DPPCLK_DTO_CTRL, DPPCLK_DTO_DB_EN[1], 1);
-		/* Fall through */
-	case 1:
-		REG_UPDATE(DPPCLK_DTO_CTRL, DPPCLK_DTO_DB_EN[0], 1);
-		break;
-	default:
-		ASSERT(false);
-		break;
-	}
 }
 
 static const struct dccg_funcs dccg2_funcs = {
-- 
2.25.1

