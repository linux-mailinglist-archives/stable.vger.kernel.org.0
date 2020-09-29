Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCD027C59B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgI2LhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730026AbgI2Lg7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F5B123E54;
        Tue, 29 Sep 2020 11:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379124;
        bh=zjJHSH1xDZxPXGtfKqQZF3rpcEEDzstMjOaW85h9Pro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Orx+yHzl+eg8Mn8dBQjTIDJxpGEKFxEYG9r9JW228cMD8VtpY7U8pLTvB3HESvnLp
         fkTkJMhvnzHHl1gapKdz1UuA/kiBTH52k+CyieXAWH0wJCFj94CAfgK4lTB3eA9/Ux
         vIyt8f+HHgZoz+8LYvjtk16vy4oGx4Vu+LLsWFK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Anthony Koo <Anthony.Koo@amd.com>, Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/388] drm/amd/display: Do not double-buffer DTO adjustments
Date:   Tue, 29 Sep 2020 12:55:37 +0200
Message-Id: <20200929110010.787641663@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



