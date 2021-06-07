Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C0839E2A2
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbhFGQSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:18:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232140AbhFGQQa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 611B261431;
        Mon,  7 Jun 2021 16:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082438;
        bh=1mLTm7tlUu/3NIRkN8US/DaZWW9nsvkCz4Gduns3kio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IlcVW6R5qZj36sfxHU40jPV/NrVdaVlgG5j7Orv80xi3P8VE/t3L9WAaKeOjH20JN
         Xud5cnke7QZFQLNS8PIXyBmJkUHyHg1XD7BL2tto7R59RLMOBz6SPkgtUxOeZ2HE7y
         havuBvg7htgL1eWyvNZMJL5+/n/uKahtYiQJcOrfR7nw4rVPEXULtitJtAZLyDS/FB
         BjOB6M9SwhcPjIeF0tCG1Da0qF6LLU2ybs99sM6W54d3u7OhJ2lQLc05yzKAQwyU+Z
         L5181Qw1Vk9QcKq3OmYnZDGvwBjV69PYMJi1haAPHqUmyvMpE4Q+wSzORo/FUQdvvR
         ouLICt4qNNdzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bindu Ramamurthy <bindu.r@amd.com>, Roman Li <Roman.Li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 31/39] drm/amd/display: Allow bandwidth validation for 0 streams.
Date:   Mon,  7 Jun 2021 12:13:10 -0400
Message-Id: <20210607161318.3583636-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index 33488b3c5c3c..1812ec7ee11b 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -3232,7 +3232,7 @@ static noinline bool dcn20_validate_bandwidth_fp(struct dc *dc,
 	voltage_supported = dcn20_validate_bandwidth_internal(dc, context, false);
 	dummy_pstate_supported = context->bw_ctx.bw.dcn.clk.p_state_change_support;
 
-	if (voltage_supported && dummy_pstate_supported) {
+	if (voltage_supported && (dummy_pstate_supported || !(context->stream_count))) {
 		context->bw_ctx.bw.dcn.clk.p_state_change_support = false;
 		goto restore_dml_state;
 	}
-- 
2.30.2

