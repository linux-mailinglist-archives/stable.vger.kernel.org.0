Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22A57167540
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388705AbgBUIYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:24:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:37514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733083AbgBUIYx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:24:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EB49246A0;
        Fri, 21 Feb 2020 08:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273492;
        bh=BNCWoPz9N9JT1a4CxnyW2istYkmuYz1zj4L7Qm7jjnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIwVKpIgZKY90T7URTH0AfJo8jxjbsMYi2TbDYbWvjfqLZBBvUkC1RCm47580RguL
         LOTdeZ2h4QFRzd76qfZp+d1N2RMHnCxvkmPziXyUZ7xtyZd2+eI7qYRiiYKekVBCL7
         RUZq4Hvz2jqbtLjoEfaSsRnY3bBB1Nn23Jb2Zj7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 191/191] drm/amdgpu/display: handle multiple numbers of fclks in dcn_calcs.c (v2)
Date:   Fri, 21 Feb 2020 08:42:44 +0100
Message-Id: <20200221072313.769324535@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c37243579d6c881c575dcfb54cf31c9ded88f946 ]

We might get different numbers of clocks from powerplay depending
on what the OEM has populated.

v2: add assert for at least one level

Bug: https://gitlab.freedesktop.org/drm/amd/issues/963
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/calcs/dcn_calcs.c  | 34 +++++++++++++------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c b/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c
index 6342f64993512..b0956c360393e 100644
--- a/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/calcs/dcn_calcs.c
@@ -1346,6 +1346,7 @@ void dcn_bw_update_from_pplib(struct dc *dc)
 	struct dc_context *ctx = dc->ctx;
 	struct dm_pp_clock_levels_with_voltage fclks = {0}, dcfclks = {0};
 	bool res;
+	unsigned vmin0p65_idx, vmid0p72_idx, vnom0p8_idx, vmax0p9_idx;
 
 	/* TODO: This is not the proper way to obtain fabric_and_dram_bandwidth, should be min(fclk, memclk) */
 	res = dm_pp_get_clock_levels_by_type_with_voltage(
@@ -1357,17 +1358,28 @@ void dcn_bw_update_from_pplib(struct dc *dc)
 		res = verify_clock_values(&fclks);
 
 	if (res) {
-		ASSERT(fclks.num_levels >= 3);
-		dc->dcn_soc->fabric_and_dram_bandwidth_vmin0p65 = 32 * (fclks.data[0].clocks_in_khz / 1000.0) / 1000.0;
-		dc->dcn_soc->fabric_and_dram_bandwidth_vmid0p72 = dc->dcn_soc->number_of_channels *
-				(fclks.data[fclks.num_levels - (fclks.num_levels > 2 ? 3 : 2)].clocks_in_khz / 1000.0)
-				* ddr4_dram_factor_single_Channel / 1000.0;
-		dc->dcn_soc->fabric_and_dram_bandwidth_vnom0p8 = dc->dcn_soc->number_of_channels *
-				(fclks.data[fclks.num_levels - 2].clocks_in_khz / 1000.0)
-				* ddr4_dram_factor_single_Channel / 1000.0;
-		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 = dc->dcn_soc->number_of_channels *
-				(fclks.data[fclks.num_levels - 1].clocks_in_khz / 1000.0)
-				* ddr4_dram_factor_single_Channel / 1000.0;
+		ASSERT(fclks.num_levels);
+
+		vmin0p65_idx = 0;
+		vmid0p72_idx = fclks.num_levels -
+			(fclks.num_levels > 2 ? 3 : (fclks.num_levels > 1 ? 2 : 1));
+		vnom0p8_idx = fclks.num_levels - (fclks.num_levels > 1 ? 2 : 1);
+		vmax0p9_idx = fclks.num_levels - 1;
+
+		dc->dcn_soc->fabric_and_dram_bandwidth_vmin0p65 =
+			32 * (fclks.data[vmin0p65_idx].clocks_in_khz / 1000.0) / 1000.0;
+		dc->dcn_soc->fabric_and_dram_bandwidth_vmid0p72 =
+			dc->dcn_soc->number_of_channels *
+			(fclks.data[vmid0p72_idx].clocks_in_khz / 1000.0)
+			* ddr4_dram_factor_single_Channel / 1000.0;
+		dc->dcn_soc->fabric_and_dram_bandwidth_vnom0p8 =
+			dc->dcn_soc->number_of_channels *
+			(fclks.data[vnom0p8_idx].clocks_in_khz / 1000.0)
+			* ddr4_dram_factor_single_Channel / 1000.0;
+		dc->dcn_soc->fabric_and_dram_bandwidth_vmax0p9 =
+			dc->dcn_soc->number_of_channels *
+			(fclks.data[vmax0p9_idx].clocks_in_khz / 1000.0)
+			* ddr4_dram_factor_single_Channel / 1000.0;
 	} else
 		BREAK_TO_DEBUGGER();
 
-- 
2.20.1



