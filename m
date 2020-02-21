Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 456EF167130
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 08:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729448AbgBUHv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729841AbgBUHv5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:51:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8677324653;
        Fri, 21 Feb 2020 07:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271517;
        bh=zERLyX57mTufDyJ7gVj+1+koC2enHgrS/6UrUIXrfNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sE81feYrsaxT2IzD1GkdEwttcmO7aN9FSUZCHTQo++mulM6ftMSmEjMW861l4yvej
         0SMoBD3sGbPF09lXGu0bJBP7iQWjs4ZYO9V7LNlZU16OEyZz7kK+1QhINRAOPxFrc3
         egOvcuTuoF+NnPGj80jttwtww2VaCWWJHbuUw/vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sung Lee <sung.lee@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 159/399] drm/amd/display: Fix update_bw_bounding_box Calcs
Date:   Fri, 21 Feb 2020 08:38:04 +0100
Message-Id: <20200221072418.007909534@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

[ Upstream commit 615b9b585eb57c1d49382d16a62de768f2c6a340 ]

[Why]
Previously update_bw_bounding_box for RN was commented out
due to incorrect values causing BSOD on Hybrid Graphics.
However, commenting out this function also may cause issues
such as underflow in certain cases such as 2x4K displays.

[How]
Fix dram_speed_mts calculations.
Update from proper index of clock_limits[]

Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index fe0ed4c09ad0a..83cda43a1b6b3 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1352,12 +1352,6 @@ struct display_stream_compressor *dcn21_dsc_create(
 
 static void update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_params)
 {
-	/*
-	TODO: Fix this function to calcualte correct values.
-	There are known issues with this function currently
-	that will need to be investigated. Use hardcoded known good values for now.
-
-
 	struct dcn21_resource_pool *pool = TO_DCN21_RES_POOL(dc->res_pool);
 	struct clk_limit_table *clk_table = &bw_params->clk_table;
 	int i;
@@ -1372,11 +1366,10 @@ static void update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_param
 		dcn2_1_soc.clock_limits[i].dcfclk_mhz = clk_table->entries[i].dcfclk_mhz;
 		dcn2_1_soc.clock_limits[i].fabricclk_mhz = clk_table->entries[i].fclk_mhz;
 		dcn2_1_soc.clock_limits[i].socclk_mhz = clk_table->entries[i].socclk_mhz;
-		dcn2_1_soc.clock_limits[i].dram_speed_mts = clk_table->entries[i].memclk_mhz * 16 / 1000;
+		dcn2_1_soc.clock_limits[i].dram_speed_mts = clk_table->entries[i].memclk_mhz * 2;
 	}
-	dcn2_1_soc.clock_limits[i] = dcn2_1_soc.clock_limits[i - i];
+	dcn2_1_soc.clock_limits[i] = dcn2_1_soc.clock_limits[i - 1];
 	dcn2_1_soc.num_states = i;
-	*/
 }
 
 /* Temporary Place holder until we can get them from fuse */
-- 
2.20.1



