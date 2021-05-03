Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0B2371C1D
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbhECQvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233768AbhECQt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18E5E613F0;
        Mon,  3 May 2021 16:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060018;
        bh=L61/bZfk/FS2BkIv6Kyc1k2J94TpXSL7UnCZS7U1WUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iw4ZOj1sO24Jl5I/xxWgu+7mvkdQaWuP3wYQzRwfUnnwDdIj558omseWEkcKvcERG
         sXwGwMO9NXT01jsf77vP3O7cmRMNAYY2Sm0dptyTrcFvKzVtx1xRoSIeF1yDKT55ru
         dX3YHriUg1hSfZBB9pKNxgER/YHW8juEAPJt5z8vNZ+6vhSmokvKAzckWBj3pYL0zV
         SSwnN0uWwb2EhEXQMA5KIBItFe6atrPQEHwMW4SqjxknABeEqnHbjxZXILbyqbYZEQ
         iskwrp/9wOaBZrk/CRH+UGHZEiLKXGrfGudKnTpDLNbfa2xnfQGoXO7Wm3XNUGiUQG
         0LPWT+uOss7gQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Eric Bernstein <Eric.Bernstein@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 24/57] drm/amd/display: fix dml prefetch validation
Date:   Mon,  3 May 2021 12:39:08 -0400
Message-Id: <20210503163941.2853291-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>

[ Upstream commit 8ee0fea4baf90e43efe2275de208a7809f9985bc ]

Incorrect variable used, missing initialization during validation.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Reviewed-by: Eric Bernstein <Eric.Bernstein@amd.com>
Acked-by: Solomon Chiu <solomon.chiu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c   | 1 +
 drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
index 6c6c486b774a..945d23ca3677 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
@@ -3435,6 +3435,7 @@ void dml20_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 			mode_lib->vba.DCCEnabledInAnyPlane = true;
 		}
 	}
+	mode_lib->vba.UrgentLatency = mode_lib->vba.UrgentLatencyPixelDataOnly;
 	for (i = 0; i <= mode_lib->vba.soc.num_states; i++) {
 		locals->FabricAndDRAMBandwidthPerState[i] = dml_min(
 				mode_lib->vba.DRAMSpeedPerState[i] * mode_lib->vba.NumberOfChannels
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
index 0fafd693ffb4..5b5ed1be19ba 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
@@ -3467,6 +3467,7 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
 			mode_lib->vba.DCCEnabledInAnyPlane = true;
 		}
 	}
+	mode_lib->vba.UrgentLatency = mode_lib->vba.UrgentLatencyPixelDataOnly;
 	for (i = 0; i <= mode_lib->vba.soc.num_states; i++) {
 		locals->FabricAndDRAMBandwidthPerState[i] = dml_min(
 				mode_lib->vba.DRAMSpeedPerState[i] * mode_lib->vba.NumberOfChannels
-- 
2.30.2

