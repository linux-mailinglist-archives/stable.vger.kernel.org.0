Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48D0CCD711
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbfJFRvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:51:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730808AbfJFRjh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:39:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD7CE2080F;
        Sun,  6 Oct 2019 17:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383576;
        bh=YhMxZFoY6IL1aOj/xsge9Nvb1sMx8PA81BVaG9x7qes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQzKCYd1olU0G1E9Ou0ny/kZMQrSTc434R0LyHDKI2RyqvgsS1Mz/bmbMTXALiTqo
         BX4U+uGMbhZtjWZFX6FBArSKJ8HEG1U90Ygq6+N0vFUueOplr07rxRQzCT+GcN4MHu
         1friRPSt6myGvFrWyNx5ponvmfnmNoe8pP35XzKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 018/166] drm/amd/display: Use proper enum conversion functions
Date:   Sun,  6 Oct 2019 19:19:44 +0200
Message-Id: <20191006171214.801281106@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171212.850660298@linuxfoundation.org>
References: <20191006171212.850660298@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit d196bbbc28fab82624f7686f8b0da8e8644b6e6a ]

clang warns:

drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_pp_smu.c:336:8:
warning: implicit conversion from enumeration type 'enum smu_clk_type'
to different enumeration type 'enum amd_pp_clock_type'
[-Wenum-conversion]
                                        dc_to_smu_clock_type(clk_type),
                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_pp_smu.c:421:14:
warning: implicit conversion from enumeration type 'enum
amd_pp_clock_type' to different enumeration type 'enum smu_clk_type'
[-Wenum-conversion]
                                        dc_to_pp_clock_type(clk_type),
                                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are functions to properly convert between all of these types, use
them so there are no longer any warnings.

Fixes: a43913ea50a5 ("drm/amd/powerplay: add function get_clock_by_type_with_latency for navi10")
Fixes: e5e4e22391c2 ("drm/amd/powerplay: add interface to get clock by type with latency for display (v2)")
Link: https://github.com/ClangBuiltLinux/linux/issues/586
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
index 592fa499c9f86..9594c154664fc 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_pp_smu.c
@@ -334,7 +334,7 @@ bool dm_pp_get_clock_levels_by_type(
 		}
 	} else if (adev->smu.funcs && adev->smu.funcs->get_clock_by_type) {
 		if (smu_get_clock_by_type(&adev->smu,
-					  dc_to_smu_clock_type(clk_type),
+					  dc_to_pp_clock_type(clk_type),
 					  &pp_clks)) {
 			get_default_clock_levels(clk_type, dc_clks);
 			return true;
@@ -419,7 +419,7 @@ bool dm_pp_get_clock_levels_by_type_with_latency(
 			return false;
 	} else if (adev->smu.ppt_funcs && adev->smu.ppt_funcs->get_clock_by_type_with_latency) {
 		if (smu_get_clock_by_type_with_latency(&adev->smu,
-						       dc_to_pp_clock_type(clk_type),
+						       dc_to_smu_clock_type(clk_type),
 						       &pp_clks))
 			return false;
 	}
-- 
2.20.1



