Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15F52E163A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbgLWCUN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:20:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728884AbgLWCUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0111C23340;
        Wed, 23 Dec 2020 02:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689997;
        bh=ZpYSRalqTmbJnRBT6HPNBUeDdjuZ9gQ3rSZueqPSgGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RobiIqJ1MyN3v4j843Nq6GNmnGsxxaHWR0qo6/IdHY6FAKitlKQqG8VMJIEqWL9+V
         UC3wvdtquHorH8ZHXfykKsstIxL8Qs2RPhNw1NRrFwh/GKa/NniJb3rPLAoz5p/o1N
         QwMTFSEXEV3ePAXwkV9YXXf35h8ZQL6ZswpzzfjZ9ii/tA1EKTrLAfnTxHUIhg9tni
         YIdjjFlgvmtklc6xP8TD7qoYflgm36eclt850OjFMKAzd4kSld2q+OIhYWlRyWzwWo
         R5nun78ADJEtBLWAezieiiKaNj7umucOsg//RfI1nMxnBhMgLXUZ+dMCrgjTJ9AoEa
         nL7b3NvSK3jHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sung Lee <sung.lee@amd.com>, Tony Cheng <Tony.Cheng@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 080/130] drm/amd/display: Update dram_clock_change_latency for DCN2.1
Date:   Tue, 22 Dec 2020 21:17:23 -0500
Message-Id: <20201223021813.2791612-80-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sung Lee <sung.lee@amd.com>

[ Upstream commit 901c1ec05ef277ce9d43cb806a225b28b3efe89a ]

[WHY]
dram clock change latencies get updated using ddr4 latency table, but
does that update does not happen before validation. This value
should not be the default and should be number received from
df for better mode support.
This may cause a PState hang on high refresh panels with short vblanks
such as on 1080p 360hz or 300hz panels.

[HOW]
Update latency from 23.84 to 11.72.

Signed-off-by: Sung Lee <sung.lee@amd.com>
Reviewed-by: Tony Cheng <Tony.Cheng@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index bb7add5ea2273..a6d5beada6634 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -257,7 +257,7 @@ struct _vcs_dpi_soc_bounding_box_st dcn2_1_soc = {
 	.num_banks = 8,
 	.num_chans = 4,
 	.vmm_page_size_bytes = 4096,
-	.dram_clock_change_latency_us = 23.84,
+	.dram_clock_change_latency_us = 11.72,
 	.return_bus_width_bytes = 64,
 	.dispclk_dppclk_vco_speed_mhz = 3600,
 	.xfc_bus_transport_time_us = 4,
-- 
2.27.0

