Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6E06246990
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729539AbgHQPX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:23:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729434AbgHQPXX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:23:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC14422E03;
        Mon, 17 Aug 2020 15:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677803;
        bh=HM15DRQruEOLK3MMp93V+owjUYiahA5zhe7I8I3MwYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KV+eUaWQETMI4jUWgGRALiu4A4VLVebojnMKBpoSNkRMHU8RTcABb2AWsiLstnbjo
         PkAMGnr45/s71LIqwhrvwERNh5yYmyF/KxU2TeLYx7qyijnnh6bonMppeVV7mf9J97
         FPyu7k5dNdhNI5AlKYP1m0Vn+Hl8A0WkOUKq6z30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 113/464] drm/amdgpu/display: properly guard the calls to swSMU functions
Date:   Mon, 17 Aug 2020 17:11:06 +0200
Message-Id: <20200817143839.220765202@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 4072327a2622af8688b88f5cd0a472136d3bf33d ]

It's only applicable on newer asics.  We could end up here when
using DC on older asics like SI or KV.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1170
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
index 7cee8070cb113..5c6a6ae48d396 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
@@ -106,7 +106,7 @@ bool dm_pp_apply_display_requirements(
 			adev->powerplay.pp_funcs->display_configuration_change(
 				adev->powerplay.pp_handle,
 				&adev->pm.pm_display_cfg);
-		else
+		else if (adev->smu.ppt_funcs)
 			smu_display_configuration_change(smu,
 							 &adev->pm.pm_display_cfg);
 
@@ -592,7 +592,7 @@ void pp_rv_set_wm_ranges(struct pp_smu *pp,
 	if (pp_funcs && pp_funcs->set_watermarks_for_clocks_ranges)
 		pp_funcs->set_watermarks_for_clocks_ranges(pp_handle,
 							   &wm_with_clock_ranges);
-	else
+	else if (adev->smu.ppt_funcs)
 		smu_set_watermarks_for_clock_ranges(&adev->smu,
 				&wm_with_clock_ranges);
 }
-- 
2.25.1



