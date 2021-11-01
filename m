Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1EF441846
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbhKAJp3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234074AbhKAJoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8043613A0;
        Mon,  1 Nov 2021 09:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758959;
        bh=OHa/Enrm9r8tXMOOH05HAbdva9L3ZCVR0alYtEzSPcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2JhK22BuAGLTvz5GyDJEHtTezITbrfXgbRSXrzyyIpsLyUWuI16jT/sZSz4ryJ4A
         ZEUk6Aif7Q7/xgw2Csa1Ilxnz/FjiplqdhWCjH5reHV15KTGD5desMPQIOdRhaZmVq
         AEGyibvHo9x+VLbp6nCEP7HMuZX9vaSnlkWlt8x8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aric Cyr <Aric.Cyr@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>,
        Jake Wang <haonan.wang2@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 054/125] drm/amd/display: Moved dccg init to after bios golden init
Date:   Mon,  1 Nov 2021 10:17:07 +0100
Message-Id: <20211101082543.430391486@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jake Wang <haonan.wang2@amd.com>

commit 2ef8ea23942f4c2569930c34e7689a0cb1b232cc upstream.

[Why]
bios_golden_init will override dccg_init during init_hw.

[How]
Move dccg_init to after bios_golden_init.

Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>
Signed-off-by: Jake Wang <haonan.wang2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c
@@ -76,10 +76,6 @@ void dcn31_init_hw(struct dc *dc)
 	if (dc->clk_mgr && dc->clk_mgr->funcs->init_clocks)
 		dc->clk_mgr->funcs->init_clocks(dc->clk_mgr);
 
-	// Initialize the dccg
-	if (res_pool->dccg->funcs->dccg_init)
-		res_pool->dccg->funcs->dccg_init(res_pool->dccg);
-
 	if (IS_FPGA_MAXIMUS_DC(dc->ctx->dce_environment)) {
 
 		REG_WRITE(REFCLK_CNTL, 0);
@@ -106,6 +102,9 @@ void dcn31_init_hw(struct dc *dc)
 		hws->funcs.bios_golden_init(dc);
 		hws->funcs.disable_vga(dc->hwseq);
 	}
+	// Initialize the dccg
+	if (res_pool->dccg->funcs->dccg_init)
+		res_pool->dccg->funcs->dccg_init(res_pool->dccg);
 
 	if (dc->debug.enable_mem_low_power.bits.dmcu) {
 		// Force ERAM to shutdown if DMCU is not enabled


