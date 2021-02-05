Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0153112AF
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 21:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhBES7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 13:59:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:46108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhBEPCu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 10:02:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41CDE65065;
        Fri,  5 Feb 2021 14:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534371;
        bh=3eSuLmnkEQxyn1kIi6VU+yURhO7h3WPw6ZW8154zkAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ha5yvuZPvf48/Duq+o7A1gJbuTvzVtAO8N94NIr7lIvJsQghJTDWXGybE34uNMASr
         ZmWV/zsUP1VyzByPK5EQOwwSPWuJ/4e01XHNFtsWazHc3JAlfGGoHm5ThJOGGOtwN0
         d22Ov10A+po3VJyMxAK8yRWFjsPxGkAUFoaHhrLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sung Lee <sung.lee@amd.com>,
        Tony Cheng <Tony.Cheng@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/32] drm/amd/display: Update dram_clock_change_latency for DCN2.1
Date:   Fri,  5 Feb 2021 15:07:43 +0100
Message-Id: <20210205140653.533882006@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140652.348864025@linuxfoundation.org>
References: <20210205140652.348864025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jake Wang <haonan.wang2@amd.com>

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



