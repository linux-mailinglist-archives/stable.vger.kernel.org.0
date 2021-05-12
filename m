Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADF037CB27
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242420AbhELQes (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241481AbhELQ1X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CD2B61964;
        Wed, 12 May 2021 15:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834788;
        bh=gwS0c3Vb7uj7NGu3ju9bETQclPXFifb69g+XAZjW9gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zTPFMJO8YhQJg8V0y59QnKOg+AnshkJuNDAwsUBqve4iRqA8+9B0qIc3RLgh+UQuk
         JAkIiTZtMo3gdygvNX4s4j99yxbB+Ddt6PRE7btFUue08qtHzPWN9kiNmIbragPP2s
         NaO2fx6eIznMak8Oy/3bFs2N0potB9P7y/V3FcmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.12 084/677] drm/amdgpu: Init GFX10_ADDR_CONFIG for VCN v3 in DPG mode.
Date:   Wed, 12 May 2021 16:42:10 +0200
Message-Id: <20210512144840.015542437@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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


