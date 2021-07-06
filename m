Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40BD3BD514
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234693AbhGFMS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237031AbhGFLfv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8671461CA3;
        Tue,  6 Jul 2021 11:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570712;
        bh=N0yqi/fE7VKWJ21/uelkUPX4mEQZlqAA9NU03kqqLWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oyY/254Wr5ro0jWp1HxtIxCbAROu9P8pjTFXzD5jUrBcHj41HoAl/UKWoO6mjbj5W
         4f/v9ZhuyWrDTJ0zUWR1Aey0fojB8a31vIgh8WiTXxHPMoW30/IwD92HYjuQs6EMAu
         IFL2R1pFWcZdQUW83lyTlYOlFHG8pTcanoJvVFY1sYUZhMk6+7uKaw9v+KHz41lg4b
         JHOKQOoa7bnn4jNROl7kXrtwNA3KeNFmGCKtx/mIqnLmRwjCpiLtzi6ufB0eQBrngo
         6Me3EslIcOVSy7480tEhgCTUSNYr1g99E1dl79euy41MI2/jw9O7zZbuoPDQUOJrbZ
         yIPHmtZ0uzCUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Aric Cyr <Aric.Cyr@amd.com>, Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 07/74] drm/amd/display: fix use_max_lb flag for 420 pixel formats
Date:   Tue,  6 Jul 2021 07:23:55 -0400
Message-Id: <20210706112502.2064236-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112502.2064236-1-sashal@kernel.org>
References: <20210706112502.2064236-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit 8809a7a4afe90ad9ffb42f72154d27e7c47551ae ]

Right now the flag simply selects memory config 0 when flag is true
however 420 modes benefit more from memory config 3.

Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c
index d67e0abeee93..11a89d873384 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_dpp_dscl.c
@@ -484,10 +484,13 @@ static enum lb_memory_config dpp1_dscl_find_lb_memory_config(struct dcn10_dpp *d
 	int vtaps_c = scl_data->taps.v_taps_c;
 	int ceil_vratio = dc_fixpt_ceil(scl_data->ratios.vert);
 	int ceil_vratio_c = dc_fixpt_ceil(scl_data->ratios.vert_c);
-	enum lb_memory_config mem_cfg = LB_MEMORY_CONFIG_0;
 
-	if (dpp->base.ctx->dc->debug.use_max_lb)
-		return mem_cfg;
+	if (dpp->base.ctx->dc->debug.use_max_lb) {
+		if (scl_data->format == PIXEL_FORMAT_420BPP8
+				|| scl_data->format == PIXEL_FORMAT_420BPP10)
+			return LB_MEMORY_CONFIG_3;
+		return LB_MEMORY_CONFIG_0;
+	}
 
 	dpp->base.caps->dscl_calc_lb_num_partitions(
 			scl_data, LB_MEMORY_CONFIG_1, &num_part_y, &num_part_c);
-- 
2.30.2

