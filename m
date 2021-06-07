Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62F139E31F
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhFGQVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232558AbhFGQTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C9B76161F;
        Mon,  7 Jun 2021 16:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082480;
        bh=f80SMjVXuFIG2vJ6MBNISobFfAFhDGaZoem9OetOAbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W69zjaYceNwq//dRUVFIePtkjk6zsPxK1JUUauaOb4ajtbMJGFpvrOrhJL9rtYZHU
         h6RpP2FuPBVA5NAmSBYAvyCDYrDKHxBqVY0FyIDmzOfI8lXMSjdDgIL2zkbMMjKuSe
         gcpSk25cr+IcCKC0JeQKqLSkxipuyxa1QFzjrszZNuY8hhe/trMcYpqnxvfhJ3NbO4
         fDe5I6s3pXy0Bz4VCWu+hMe/3Rebn5heiO+HTTYcTSDj41JP6ABMYO1gq/GeD2izcW
         KQQbt/9BFZ8z3BfU5nHlsiYxnvfV1MCDFaa+arTkIFGAIWJXZMnoLB9rmLuRivSMwf
         TJum/DdLLbxMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bindu Ramamurthy <bindu.r@amd.com>, Roman Li <Roman.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 24/29] drm/amd/display: Allow bandwidth validation for 0 streams.
Date:   Mon,  7 Jun 2021 12:14:05 -0400
Message-Id: <20210607161410.3584036-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bindu Ramamurthy <bindu.r@amd.com>

[ Upstream commit ba8e59773ae59818695d1e20b8939282da80ec8c ]

[Why]
Bandwidth calculations are triggered for non zero streams, and
in case of 0 streams, these calculations were skipped with
pstate status not being updated.

[How]
As the pstate status is applicable for non zero streams, check
added for allowing 0 streams inline with dcn internal bandwidth
validations.

Signed-off-by: Bindu Ramamurthy <bindu.r@amd.com>
Reviewed-by: Roman Li <Roman.Li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
index 08062de3fbeb..2b1175bb2dae 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2917,7 +2917,7 @@ bool dcn20_validate_bandwidth(struct dc *dc, struct dc_state *context,
 	voltage_supported = dcn20_validate_bandwidth_internal(dc, context, false);
 	dummy_pstate_supported = context->bw_ctx.bw.dcn.clk.p_state_change_support;
 
-	if (voltage_supported && dummy_pstate_supported) {
+	if (voltage_supported && (dummy_pstate_supported || !(context->stream_count))) {
 		context->bw_ctx.bw.dcn.clk.p_state_change_support = false;
 		goto restore_dml_state;
 	}
-- 
2.30.2

