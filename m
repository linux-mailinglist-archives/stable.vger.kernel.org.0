Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA124378400
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhEJKsa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:48:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231527AbhEJKqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:46:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02B1C619B5;
        Mon, 10 May 2021 10:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643025;
        bh=bDM2BXsWVu4ZVNspegVRKj6qbKmdCaTTVNDThDY1VSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbj9hhoPn+KRbH5SaCOcxIr80BDo9pq827P1fDzPypfmt7XAHd9q4+UnWI867420P
         xgGTN1xrMkxQeMPoofjToXZEchJbxiGxOcOO2PHf4xa1mvAp8UpMUWtHwnrS1xmmnY
         eLO+HSMe1szqh13SuziIomP0r5X+ezrsiNlzOAo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Eric Bernstein <Eric.Bernstein@amd.com>,
        Solomon Chiu <solomon.chiu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 147/299] drm/amd/display: fix dml prefetch validation
Date:   Mon, 10 May 2021 12:19:04 +0200
Message-Id: <20210510102009.818572493@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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
index 45f028986a8d..b3f0476899d3 100644
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
index 80170f9721ce..1bcda7eba4a6 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
@@ -3510,6 +3510,7 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
 			mode_lib->vba.DCCEnabledInAnyPlane = true;
 		}
 	}
+	mode_lib->vba.UrgentLatency = mode_lib->vba.UrgentLatencyPixelDataOnly;
 	for (i = 0; i <= mode_lib->vba.soc.num_states; i++) {
 		locals->FabricAndDRAMBandwidthPerState[i] = dml_min(
 				mode_lib->vba.DRAMSpeedPerState[i] * mode_lib->vba.NumberOfChannels
-- 
2.30.2



