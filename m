Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B0F3782BA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhEJKhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232884AbhEJKfV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:35:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03BA461923;
        Mon, 10 May 2021 10:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642516;
        bh=L61/bZfk/FS2BkIv6Kyc1k2J94TpXSL7UnCZS7U1WUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qa1cSNIY8LEWQiSVLz3t6f2yf3gSzCzUZT6FDoqZFryn810OCj+HWksdZSwFva8PK
         tfYTfHqX34fIxoNE2vobcMT7cMTy0RxIUrmO2cIkqPGF2RKiTNVA6DO4YGNSkwaErN
         jzUqAbREAQohEs4XIKaoxUaAK9Va2QoeKc12Lbx0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Eric Bernstein <Eric.Bernstein@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/184] drm/amd/display: fix dml prefetch validation
Date:   Mon, 10 May 2021 12:19:45 +0200
Message-Id: <20210510101953.157026605@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
References: <20210510101950.200777181@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



