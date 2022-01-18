Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB498491591
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245627AbiARC2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:53 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44064 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343686AbiARC0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37E2160C96;
        Tue, 18 Jan 2022 02:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27B1C36AE3;
        Tue, 18 Jan 2022 02:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472810;
        bh=P6eFo3h9qX3r6YCHPSkuPE/RNoXMNV1Mnn7M6uecedU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p18bWi9lvr4Y4qkXUHrNvIweF2GIA0HCkm774BGPf2KzeGlW0rY/gh6llDBF2c6Qj
         jo0hEiWm5EsHA9oi7LweRyyZQ1s05VY2shzGqqZoUM+BGGnHZLRwLkBwMQQrmeTdo6
         mlOJDlxramiO3U5MS9HoTRI7mkvzHmeUJD+BFkltlRLPrM0EBoQm+ukwGebX6kKICf
         Kdu5Fa6gtQOSEJUfK6Uk2hck6bQrkSO9uppZow5QavhPtQnUwr9L0wtgvYwoo8RtXr
         zR/xbBV/V7aAkTfGp1T4JZTNHdPZ421fu+ydpiyrbcc0nb9rHNhVVF1/1d63wMitu7
         BdayefkOQ7LKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, john.clements@amd.com, candice.li@amd.com,
        lijo.lazar@amd.com, lang.yu@amd.com, Oak.Zeng@amd.com,
        jonathan.kim@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 140/217] drm/amd/amdgpu: fix psp tmr bo pin count leak in SRIOV
Date:   Mon, 17 Jan 2022 21:18:23 -0500
Message-Id: <20220118021940.1942199-140-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingwen Chen <Jingwen.Chen2@amd.com>

[ Upstream commit 85dfc1d692c9434c37842e610be37cd4ae4e0081 ]

[Why]
psp tmr bo will be pinned during loading amdgpu and reset in SRIOV while
only unpinned in unload amdgpu

[How]
add amdgpu_in_reset and sriov judgement to skip pin bo

v2: fix wrong judgement

Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Reviewed-by: Horace Chen <horace.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index c641f84649d6b..d011ae7e50a54 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -2017,12 +2017,16 @@ static int psp_hw_start(struct psp_context *psp)
 		return ret;
 	}
 
+	if (amdgpu_sriov_vf(adev) && amdgpu_in_reset(adev))
+		goto skip_pin_bo;
+
 	ret = psp_tmr_init(psp);
 	if (ret) {
 		DRM_ERROR("PSP tmr init failed!\n");
 		return ret;
 	}
 
+skip_pin_bo:
 	/*
 	 * For ASICs with DF Cstate management centralized
 	 * to PMFW, TMR setup should be performed after PMFW
-- 
2.34.1

