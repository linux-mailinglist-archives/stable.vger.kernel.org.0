Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B09201283
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393087AbgFSPWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393080AbgFSPWx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:22:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0A6B21582;
        Fri, 19 Jun 2020 15:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580172;
        bh=56mqz//yRO8dwLkzCXAUJh+8sRp/R6L45fiWOsiVU5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbXxg+07iGEUP+1aA0fTQK221ko6RKYC5E3GzITulcavkBxazNgUIfAxRbBOcvsSo
         al7t6i653kzLO//iH650nRhYOHMDSeLO0bKQ1b+nLkXyJ7d8MSs6lM+4HUzPnkwb4R
         9w8mzvDG+HeYiVda29DKThBAW7u/Xd6gU2qbT4Y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sung Lee <sung.lee@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 119/376] drm/amd/display: Do not disable pipe split if mode is not supported
Date:   Fri, 19 Jun 2020 16:30:37 +0200
Message-Id: <20200619141715.978900903@linuxfoundation.org>
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

From: Sung Lee <sung.lee@amd.com>

[ Upstream commit 1dfedb39d38f813357885e19badd1971c17f79a7 ]

[WHY]
If mode is not supported, pipe split should not be disabled.
This may cause more modes to fail.

[HOW]
Check for mode support before disabling pipe split.

This commit was previously reverted as it was thought to
have problems, but those issues have been resolved.

Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index e4348e3b6389..2719cdecc1cb 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2597,19 +2597,24 @@ int dcn20_validate_apply_pipe_split_flags(
 
 	/* Avoid split loop looks for lowest voltage level that allows most unsplit pipes possible */
 	if (avoid_split) {
+		int max_mpc_comb = context->bw_ctx.dml.vba.maxMpcComb;
+
 		for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
 			if (!context->res_ctx.pipe_ctx[i].stream)
 				continue;
 
 			for (vlevel_split = vlevel; vlevel <= context->bw_ctx.dml.soc.num_states; vlevel++)
-				if (context->bw_ctx.dml.vba.NoOfDPP[vlevel][0][pipe_idx] == 1)
+				if (context->bw_ctx.dml.vba.NoOfDPP[vlevel][0][pipe_idx] == 1 &&
+						context->bw_ctx.dml.vba.ModeSupport[vlevel][0])
 					break;
 			/* Impossible to not split this pipe */
 			if (vlevel > context->bw_ctx.dml.soc.num_states)
 				vlevel = vlevel_split;
+			else
+				max_mpc_comb = 0;
 			pipe_idx++;
 		}
-		context->bw_ctx.dml.vba.maxMpcComb = 0;
+		context->bw_ctx.dml.vba.maxMpcComb = max_mpc_comb;
 	}
 
 	/* Split loop sets which pipe should be split based on dml outputs and dc flags */
-- 
2.25.1



