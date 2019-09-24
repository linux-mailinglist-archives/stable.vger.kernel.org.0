Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6359CBCCD0
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 18:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404044AbfIXQmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:42:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:58522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404017AbfIXQmR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:42:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 378AC20872;
        Tue, 24 Sep 2019 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343337;
        bh=R/jTEcosIgI42IvSWc1LupVsH5P7htvyBIlQkVgNgvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLtpCjGF5v9cywe/HRjOMkArW5+pP/23Ub5e/eRMjxhrQqiot3d/+UPKwbDRwmpD5
         WRXY7tPlLw+UPytnpfSvXt0QQ6azSEiBI47GqucMREDNSo7WSJ2t7A95Kh6lMJvS4a
         tVe3DoIjHVIH6ItF1LUHiaFElYdEzEIcEOZru3Ck=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Su Sung Chung <Su.Chung@amd.com>, Eric Yang <eric.yang2@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 10/87] drm/amd/display: fix not calling ppsmu to trigger PME
Date:   Tue, 24 Sep 2019 12:40:26 -0400
Message-Id: <20190924164144.25591-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Sung Chung <Su.Chung@amd.com>

[ Upstream commit 18b401874aee10c80b5745c9b93280dae5a59809 ]

[why]
dcn20_clk_mgr_construct was not initializing pp_smu, and PME call gets
filtered out by the null check

[how]
initialize pp_smu dcn20_clk_mgr_construct

Signed-off-by: Su Sung Chung <Su.Chung@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
index 50bfb5921de07..2ab0f97719b5a 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c
@@ -348,6 +348,8 @@ void dcn20_clk_mgr_construct(
 
 	clk_mgr->base.dprefclk_khz = 700000; // 700 MHz planned if VCO is 3.85 GHz, will be retrieved
 
+	clk_mgr->pp_smu = pp_smu;
+
 	if (IS_FPGA_MAXIMUS_DC(ctx->dce_environment)) {
 		dcn2_funcs.update_clocks = dcn2_update_clocks_fpga;
 		clk_mgr->dentist_vco_freq_khz = 3850000;
-- 
2.20.1

