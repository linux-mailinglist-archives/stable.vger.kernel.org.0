Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06D92E422F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437058AbgL1ODB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:03:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408113AbgL1OBE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:01:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8249320731;
        Mon, 28 Dec 2020 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164024;
        bh=SNTOy0mjLmWHH41mZ8P0m4Xdp3Z04OtVMhmCLIbNqyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lVmVsWYXpFtKkRxx3yygKKKVMPstLegz3eLnFVUXFXOByIqu9mx5L2G2LUJlo9rt8
         viE/lpEHYocrZIKERYR1iuOzMaSWeSUXHKzd8zxx9VFeVZ3UtH4StZ8Gyp7ozP4UYb
         yeHCUE2YU3YkoLFTa8HpriDYdT/c7RmJIgS3og7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/717] drm/amdgpu: fix incorrect enum type
Date:   Mon, 28 Dec 2020 13:40:31 +0100
Message-Id: <20201228125022.577457558@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a110f3750bf8b93764f13bd1402c7cba03d15d61 ]

core_link_write_dpcd() returns enum dc_status, not ddc_result:

display/dc/core/dc_link_dp.c: In function 'dp_set_panel_mode':
display/dc/core/dc_link_dp.c:4237:11: warning: implicit conversion from 'enum dc_status' to 'enum ddc_result'
[-Wenum-conversion]

Avoid the warning by using the correct enum in the caller.

Fixes: 0b226322434c ("drm/amd/display: Synchronous DisplayPort Link Training")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index ff1e9963ec7a2..98464886341f6 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4230,7 +4230,7 @@ void dp_set_panel_mode(struct dc_link *link, enum dp_panel_mode panel_mode)
 
 		if (edp_config_set.bits.PANEL_MODE_EDP
 			!= panel_mode_edp) {
-			enum ddc_result result = DDC_RESULT_UNKNOWN;
+			enum dc_status result = DC_ERROR_UNEXPECTED;
 
 			edp_config_set.bits.PANEL_MODE_EDP =
 			panel_mode_edp;
@@ -4240,7 +4240,7 @@ void dp_set_panel_mode(struct dc_link *link, enum dp_panel_mode panel_mode)
 				&edp_config_set.raw,
 				sizeof(edp_config_set.raw));
 
-			ASSERT(result == DDC_RESULT_SUCESSFULL);
+			ASSERT(result == DC_OK);
 		}
 	}
 	DC_LOG_DETECTION_DP_CAPS("Link: %d eDP panel mode supported: %d "
-- 
2.27.0



