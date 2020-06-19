Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F9F201274
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392820AbgFSPVM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:52470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392816AbgFSPVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E98820706;
        Fri, 19 Jun 2020 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580069;
        bh=TT+8tMvqgygFxoAAc7BZuKJHREEz6edhkE6V6E4qA9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsB71NIVvx+wj1pPqoH7LL79corNFDEtzkBP/1ZZnnew6OMidOHECrheD0Fr7stpH
         Fo1OigMBVi15ZCErYzcLMKSPwHYyDyX8f/n44qegoV8pHBg5TE9cHAdXS1v4zYf3lm
         35sRg+Kog1IEBBjz9YbcOny2h9jwAEaehfThi0lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Hsieh <paul.hsieh@amd.com>,
        Eric Yang <eric.yang2@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 109/376] drm/amd/display: dmcu wait loop calculation is incorrect in RV
Date:   Fri, 19 Jun 2020 16:30:27 +0200
Message-Id: <20200619141715.506669577@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Hsieh <paul.hsieh@amd.com>

[ Upstream commit 7fc5c319efceaed1a23b7ef35c333553ce39fecf ]

[Why]
Driver already get display clock from SMU base on MHz, but driver read
again and mutiple 1000 cause wait loop value is overflow.

[How]
remove coding error

Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Reviewed-by: Eric Yang <eric.yang2@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c   | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c
index 97b7f32294fd..c320b7af7d34 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn10/rv1_clk_mgr_vbios_smu.c
@@ -97,9 +97,6 @@ int rv1_vbios_smu_set_dispclk(struct clk_mgr_internal *clk_mgr, int requested_di
 			VBIOSSMC_MSG_SetDispclkFreq,
 			requested_dispclk_khz / 1000);
 
-	/* Actual dispclk set is returned in the parameter register */
-	actual_dispclk_set_mhz = REG_READ(MP1_SMN_C2PMSG_83) * 1000;
-
 	if (!IS_FPGA_MAXIMUS_DC(dc->ctx->dce_environment)) {
 		if (dmcu && dmcu->funcs->is_dmcu_initialized(dmcu)) {
 			if (clk_mgr->dfs_bypass_disp_clk != actual_dispclk_set_mhz)
-- 
2.25.1



