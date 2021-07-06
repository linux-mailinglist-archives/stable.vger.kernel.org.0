Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1258F3BD530
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhGFMTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:19:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237164AbhGFLf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93EA861ECD;
        Tue,  6 Jul 2021 11:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570749;
        bh=iEXuc2D8om0atvMRk10gMHiPfJTXx2mXNvzdvpuYWCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NfmKmCd85BMIZb9mjaduw0sRBOSGgi0Xb2J8bb1tMLBQUoE9HhKAURNCBXYadXb3L
         Ys1eAiVTBfAy/iY5q61u2oBX5iN9hEsymFtmJjlbFcKrEpuKQFBQ/4PI3RKSpqO5Dm
         vEtFnqVD5qGbTBQG2B0U9di+FIYCn2JgWxL4KyjOD3B5DrotQ8YGRKDB+cy/cdmF9E
         LQK4IKWdQlMHawe6bHvjDc7brTjWfUJeA+dTgrS/VZNIR3/DngcdFjaX7DeKQwq2Nb
         SiLciUgI5nxIftVb7lb8cLVxBagYf+N3UrhJEPmTfE3vevw7mdNNHqycG2jdV8n2Lj
         u/c85pRRn8F3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 37/74] drm/amd/display: Set DISPCLK_MAX_ERRDET_CYCLES to 7
Date:   Tue,  6 Jul 2021 07:24:25 -0400
Message-Id: <20210706112502.2064236-37-sashal@kernel.org>
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

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

[ Upstream commit 3577e1678772ce3ede92af3a75b44a4b76f9b4ad ]

[WHY]
DISPCLK_MAX_ERRDET_CYCLES must be 7 to prevent connection loss when
changing DENTIST_DISPCLK_WDIVIDER from 126 to 127 and back.

Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 083c42e521f5..03a2e1d7f067 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -126,7 +126,7 @@ void dcn20_dccg_init(struct dce_hwseq *hws)
 	REG_WRITE(MILLISECOND_TIME_BASE_DIV, 0x1186a0);
 
 	/* This value is dependent on the hardware pipeline delay so set once per SOC */
-	REG_WRITE(DISPCLK_FREQ_CHANGE_CNTL, 0x801003c);
+	REG_WRITE(DISPCLK_FREQ_CHANGE_CNTL, 0xe01003c);
 }
 void dcn20_display_init(struct dc *dc)
 {
-- 
2.30.2

