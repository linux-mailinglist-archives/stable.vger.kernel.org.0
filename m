Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9AA3BCC9B
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhGFLTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:19:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhGFLSx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 585F061C58;
        Tue,  6 Jul 2021 11:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570174;
        bh=V5xozR4nuZSnCU9y6noaDhHo7F8Fk/JOZVL7sZpw1Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnnSY9l41T5LfCBomUXFBpMmdonm+2kv+FPUbdsWA0DnH88sjGmSPgbL3l8tFCxOg
         1k2zIPuCWRrut9RLnVxwB44o19j4aBKdXyaJxtQ20yqzWuhEwOe/AYsR3iYjpnO0g9
         Q15Gzh4I3vQWlmRTiTJc/Orb6b+rW9lPD1cfNhKxvxNPbvDQwqRG3pUj38z0ALfRPR
         L1NJIMjk/zVEJ6Jlqr08RnqHsZwgNIjr4h/ZJHhKFFt/1bYUg0l7DOyGPSKphT47AJ
         3oPU7BN7qHssSc2XdzgAGUCHzKICDHbHZcvAUy62GvXGcECMhmDDCEYBGHNc1d0khc
         eMANmRLf9SaKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.13 092/189] drm/amd/display: Set DISPCLK_MAX_ERRDET_CYCLES to 7
Date:   Tue,  6 Jul 2021 07:12:32 -0400
Message-Id: <20210706111409.2058071-92-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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
index 6a10daec15cc..793554e61c52 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -243,7 +243,7 @@ void dcn20_dccg_init(struct dce_hwseq *hws)
 	REG_WRITE(MILLISECOND_TIME_BASE_DIV, 0x1186a0);
 
 	/* This value is dependent on the hardware pipeline delay so set once per SOC */
-	REG_WRITE(DISPCLK_FREQ_CHANGE_CNTL, 0x801003c);
+	REG_WRITE(DISPCLK_FREQ_CHANGE_CNTL, 0xe01003c);
 }
 
 void dcn20_disable_vga(
-- 
2.30.2

