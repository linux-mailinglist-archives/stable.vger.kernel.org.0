Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A168E49A403
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369253AbiAYABS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847533AbiAXXT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:19:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAB45C06F8FD;
        Mon, 24 Jan 2022 13:27:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58A1661490;
        Mon, 24 Jan 2022 21:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F10C340E4;
        Mon, 24 Jan 2022 21:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059662;
        bh=P6eFo3h9qX3r6YCHPSkuPE/RNoXMNV1Mnn7M6uecedU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3lw26p6aQ1Hj4Z3y9cV57qYeVMJDllBK7VX0EoFPkiKtSKJZa1XN4XFha0CU6Y3Z
         C3AvWagQL10P9eidMGSNoS6odpK8QNHNc7kK6q0E+wrF+N4EfEIy+CXIOICROof+ST
         jivP42Ae9JZDq/K89YlD030tJFO07mzhyF1mSEXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingwen Chen <Jingwen.Chen2@amd.com>,
        Horace Chen <horace.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0658/1039] drm/amd/amdgpu: fix psp tmr bo pin count leak in SRIOV
Date:   Mon, 24 Jan 2022 19:40:47 +0100
Message-Id: <20220124184147.486025851@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



