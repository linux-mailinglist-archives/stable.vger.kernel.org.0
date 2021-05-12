Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85DBF37C799
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235448AbhELQBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:01:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:36238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237942AbhELP4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B096C61928;
        Wed, 12 May 2021 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833336;
        bh=gwS0c3Vb7uj7NGu3ju9bETQclPXFifb69g+XAZjW9gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OKJ7YtWeZzYEvK8H89SQ1K70XkPegnOmT7LN2rI1Wcu2mR71/7D279FOafc2axLcF
         /jY7Vz6eKx1LbwqbtzE204LMvOeQ3iN8lbybCk8mlrki/flk4K1Im9Ali6QDuDmbEp
         2STWy1+m3nE/C3OJs0xZiEVL6O9B5MXCit0NPw5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.11 074/601] drm/amdgpu: Init GFX10_ADDR_CONFIG for VCN v3 in DPG mode.
Date:   Wed, 12 May 2021 16:42:31 +0200
Message-Id: <20210512144830.263420306@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 8bf073ca9235fe38d7b74a0b4e779cfa7cc70fc9 upstream.

Otherwise tiling modes that require the values form this field
(In particular _*_X) would be corrupted upon video decode.

Copied from the VCN v2 code.

Fixes: 99541f392b4d ("drm/amdgpu: add mc resume DPG mode for VCN3.0")
Reviewed-and-Tested by: Leo Liu <leo.liu@amd.com>
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -584,6 +584,10 @@ static void vcn_v3_0_mc_resume_dpg_mode(
 	WREG32_SOC15_DPG_MODE(inst_idx, SOC15_DPG_MODE_OFFSET(
 			VCN, inst_idx, mmUVD_VCPU_NONCACHE_SIZE0),
 			AMDGPU_GPU_PAGE_ALIGN(sizeof(struct amdgpu_fw_shared)), 0, indirect);
+
+	/* VCN global tiling registers */
+	WREG32_SOC15_DPG_MODE(0, SOC15_DPG_MODE_OFFSET(
+		UVD, 0, mmUVD_GFX10_ADDR_CONFIG), adev->gfx.config.gb_addr_config, 0, indirect);
 }
 
 static void vcn_v3_0_disable_static_power_gating(struct amdgpu_device *adev, int inst)


