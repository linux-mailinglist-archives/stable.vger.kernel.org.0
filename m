Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB249A395
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365549AbiAXXvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448972AbiAXVyz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:54:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1E5C08B4FA;
        Mon, 24 Jan 2022 12:34:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B6FC61530;
        Mon, 24 Jan 2022 20:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84502C340E5;
        Mon, 24 Jan 2022 20:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056483;
        bh=UH/NsbM9mt79CzA1kPcHg2YVaT+xnxkxbBGOOFUagss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NdbV5FwiRMwrHGZVZnr8blp31FVaBSjL+brfKJtoT34mv3jiUGg6+TuW8Zh5XSWyu
         t4ikbYzBDfIT7YAnCcK6Z++CoyARdp4Goq1whCRTXW7SyZYepVGYY/8/v0dAuTR5Xh
         DAcv2cd9jSEbRNGCRNPw8ONi2iTuJP2RJBlthGf8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <Aric.Cyr@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 498/846] drm/amd/display: add else to avoid double destroy clk_mgr
Date:   Mon, 24 Jan 2022 19:40:15 +0100
Message-Id: <20220124184118.201266166@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Leung <Martin.Leung@amd.com>

[ Upstream commit 11dff0e871037a6ad978e52f826a2eb7f5fb274a ]

[Why & How]
when changing some code we accidentally
changed else if-> if. reverting that.

Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
index bb31541f80723..6420527fe476c 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
@@ -306,8 +306,7 @@ void dc_destroy_clk_mgr(struct clk_mgr *clk_mgr_base)
 	case FAMILY_NV:
 		if (ASICREV_IS_SIENNA_CICHLID_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
 			dcn3_clk_mgr_destroy(clk_mgr);
-		}
-		if (ASICREV_IS_DIMGREY_CAVEFISH_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
+		} else if (ASICREV_IS_DIMGREY_CAVEFISH_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
 			dcn3_clk_mgr_destroy(clk_mgr);
 		}
 		if (ASICREV_IS_BEIGE_GOBY_P(clk_mgr_base->ctx->asic_id.hw_internal_rev)) {
-- 
2.34.1



