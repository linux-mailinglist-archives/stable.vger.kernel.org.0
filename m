Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC95D371A55
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhECQj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:39:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:38656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhECQiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:38:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF8C1613EC;
        Mon,  3 May 2021 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059801;
        bh=KprGEgi2SnO1s/mKEo8xVV/ncCKSK03eyLB1dOpN8Ro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNNLzxf8CJzwG2Yg3LaSYfR859s3OX3LHNZZYwnrNOu7rPWUqjxgQ+uA+ZHTLgvzL
         oVHZL90Njn6nwtYM2YYlRXQ6CgnN5LO0CA5rk9VaMs7sRryWr5TK17eOS4uCLAZRKr
         +eyPzZm0Hfi+WQZuP54JFgOZHH0qGjwQi2T7wSNia12JmRwiIgwLnSBD/d3WDBb3Zz
         BUMU2+2dIKedVJ8a2EsERIqX7BV9nBIv7NjHSzLC+6NVhsV68o48D9j6SLttrpMa6H
         xHNGQHghDDd0acM0h1SGqyc8TTPoDZe85NDAnbwyP1shexr12Lk1uA+rQ7H7ZJ5zK+
         yhBr1hG9PaQ9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Eric Bernstein <Eric.Bernstein@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.12 056/134] drm/amd/display: fix dml prefetch validation
Date:   Mon,  3 May 2021 12:33:55 -0400
Message-Id: <20210503163513.2851510-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163513.2851510-1-sashal@kernel.org>
References: <20210503163513.2851510-1-sashal@kernel.org>
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
index 0f3f510fd83b..9729cf292e84 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
@@ -3437,6 +3437,7 @@ void dml20_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 			mode_lib->vba.DCCEnabledInAnyPlane = true;
 		}
 	}
+	mode_lib->vba.UrgentLatency = mode_lib->vba.UrgentLatencyPixelDataOnly;
 	for (i = 0; i <= mode_lib->vba.soc.num_states; i++) {
 		locals->FabricAndDRAMBandwidthPerState[i] = dml_min(
 				mode_lib->vba.DRAMSpeedPerState[i] * mode_lib->vba.NumberOfChannels
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
index 210c96cd5b03..51098c2c9854 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
@@ -3544,6 +3544,7 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
 			mode_lib->vba.DCCEnabledInAnyPlane = true;
 		}
 	}
+	mode_lib->vba.UrgentLatency = mode_lib->vba.UrgentLatencyPixelDataOnly;
 	for (i = 0; i <= mode_lib->vba.soc.num_states; i++) {
 		locals->FabricAndDRAMBandwidthPerState[i] = dml_min(
 				mode_lib->vba.DRAMSpeedPerState[i] * mode_lib->vba.NumberOfChannels
-- 
2.30.2

