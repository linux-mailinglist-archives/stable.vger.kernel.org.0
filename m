Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6062E17B1
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgLWDNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:13:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbgLWCSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBD1823333;
        Wed, 23 Dec 2020 02:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689823;
        bh=LzfZCtv9f0T68Y0kzTc6SDeo8zWnuF2OlmwvB5h+inQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDz0f1VS2x9iEOee5G/OCqlgzMCCLGdiWZY8r8ITRMZa0V5g0afT81zCT8iQb2CPJ
         ijH2P4fNbwD4ciGRzBWma378UjVagg4SRN1kIhvfvAQfhwni1xPffclSchJs9Z+cEJ
         03uvmMmhKLJl7d8ho2Vh+ooo2CsrnmfDe2et/K/UPNZI3wdyOBCjDReTN0RQVtDemP
         J8auvBYf8IQ5HbuvR+E5aTp2HVQWeUMRp7TLsT9XZPBRrJk0tEK9wUBNm9OaYTbv4r
         7lZoYIue3GkHIyHNm9RXLFYXOrDMJkJkqr7U7EW0XlOR8FqGIP+FGCJNNpEHBT5FAy
         peezz2J72yvLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Ol=C5=A1=C3=A1k?= <marek.olsak@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 028/217] drm/amdgpu: set LDS_CONFIG=0x20 on Navy Flounder to fix a GPU hang (v2)
Date:   Tue, 22 Dec 2020 21:13:17 -0500
Message-Id: <20201223021626.2790791-28-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Olšák <marek.olsak@amd.com>

[ Upstream commit 4b60bb0dde1baf347540253f856c54bc908e525c ]

v2: squash in build fix

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Marek Olšák <marek.olsak@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 55f4b8c3b9338..66bdfbdcdf2b8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -3183,7 +3183,10 @@ static const struct soc15_reg_golden golden_settings_gc_10_3_2[] =
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmSQ_PERFCOUNTER9_SELECT, 0xf0f001ff, 0x00000000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmTA_CNTL_AUX, 0xfff7ffff, 0x01030000),
 	SOC15_REG_GOLDEN_VALUE(GC, 0, mmUTCL1_CTRL, 0xffbfffff, 0x00a00000),
-	SOC15_REG_GOLDEN_VALUE(GC, 0, mmVGT_GS_MAX_WAVE_ID, 0x00000fff, 0x000003ff)
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmVGT_GS_MAX_WAVE_ID, 0x00000fff, 0x000003ff),
+
+	/* This is not in GDB yet. Don't remove it. It fixes a GPU hang on Navy Flounder. */
+	SOC15_REG_GOLDEN_VALUE(GC, 0, mmLDS_CONFIG,  0x00000020, 0x00000020),
 };
 
 #define DEFAULT_SH_MEM_CONFIG \
-- 
2.27.0

