Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4180A47AFB8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237169AbhLTPRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237242AbhLTPQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:16:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D08C00FC56;
        Mon, 20 Dec 2021 06:58:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F518611A7;
        Mon, 20 Dec 2021 14:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F402BC36AE7;
        Mon, 20 Dec 2021 14:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012290;
        bh=OBND8aE4YnBj+yCSPMGOY9rPW9YYLpGxBw325GxiY4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G6nrM+rKByqZ1GPh4s8dwJH0chWO/8NxWUvkJG07KNmsjHFlaH2+dxJ0FzDHncyzo
         LrLOBTbqCixgvco035nStOcdUACLe8l3L6yIrtmAJrzcm3ZW+uYZcxY3lzaoLUTUaF
         tssOhWIWhVAPPBHnTTj85zVvWg2IYFTOE7R42Qwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 149/177] drm/amdgpu: dont override default ECO_BITs setting
Date:   Mon, 20 Dec 2021 15:34:59 +0100
Message-Id: <20211220143045.092637265@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hawking Zhang <Hawking.Zhang@amd.com>

commit 841933d5b8aa853abe68e63827f68f50fab37226 upstream.

Leave this bit as hardware default setting

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c |    1 -
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c |    1 -
 drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c |    1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c  |    1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c  |    1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c  |    1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c  |    1 -
 drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c  |    2 --
 8 files changed, 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfxhub_v1_0.c
@@ -162,7 +162,6 @@ static void gfxhub_v1_0_init_tlb_regs(st
 			    ENABLE_ADVANCED_DRIVER_MODEL, 1);
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
 			    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
-	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ECO_BITS, 0);
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
 			    MTYPE, MTYPE_UC);/* XXX for emulation. */
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ATC_EN, 1);
--- a/drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfxhub_v2_0.c
@@ -196,7 +196,6 @@ static void gfxhub_v2_0_init_tlb_regs(st
 			    ENABLE_ADVANCED_DRIVER_MODEL, 1);
 	tmp = REG_SET_FIELD(tmp, GCMC_VM_MX_L1_TLB_CNTL,
 			    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
-	tmp = REG_SET_FIELD(tmp, GCMC_VM_MX_L1_TLB_CNTL, ECO_BITS, 0);
 	tmp = REG_SET_FIELD(tmp, GCMC_VM_MX_L1_TLB_CNTL,
 			    MTYPE, MTYPE_UC); /* UC, uncached */
 
--- a/drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfxhub_v2_1.c
@@ -197,7 +197,6 @@ static void gfxhub_v2_1_init_tlb_regs(st
 			    ENABLE_ADVANCED_DRIVER_MODEL, 1);
 	tmp = REG_SET_FIELD(tmp, GCMC_VM_MX_L1_TLB_CNTL,
 			    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
-	tmp = REG_SET_FIELD(tmp, GCMC_VM_MX_L1_TLB_CNTL, ECO_BITS, 0);
 	tmp = REG_SET_FIELD(tmp, GCMC_VM_MX_L1_TLB_CNTL,
 			    MTYPE, MTYPE_UC); /* UC, uncached */
 
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_0.c
@@ -145,7 +145,6 @@ static void mmhub_v1_0_init_tlb_regs(str
 			    ENABLE_ADVANCED_DRIVER_MODEL, 1);
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
 			    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
-	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ECO_BITS, 0);
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
 			    MTYPE, MTYPE_UC);/* XXX for emulation. */
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ATC_EN, 1);
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v1_7.c
@@ -165,7 +165,6 @@ static void mmhub_v1_7_init_tlb_regs(str
 			    ENABLE_ADVANCED_DRIVER_MODEL, 1);
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
 			    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
-	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ECO_BITS, 0);
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL,
 			    MTYPE, MTYPE_UC);/* XXX for emulation. */
 	tmp = REG_SET_FIELD(tmp, MC_VM_MX_L1_TLB_CNTL, ATC_EN, 1);
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -269,7 +269,6 @@ static void mmhub_v2_0_init_tlb_regs(str
 			    ENABLE_ADVANCED_DRIVER_MODEL, 1);
 	tmp = REG_SET_FIELD(tmp, MMMC_VM_MX_L1_TLB_CNTL,
 			    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
-	tmp = REG_SET_FIELD(tmp, MMMC_VM_MX_L1_TLB_CNTL, ECO_BITS, 0);
 	tmp = REG_SET_FIELD(tmp, MMMC_VM_MX_L1_TLB_CNTL,
 			    MTYPE, MTYPE_UC); /* UC, uncached */
 
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
@@ -194,7 +194,6 @@ static void mmhub_v2_3_init_tlb_regs(str
 			    ENABLE_ADVANCED_DRIVER_MODEL, 1);
 	tmp = REG_SET_FIELD(tmp, MMMC_VM_MX_L1_TLB_CNTL,
 			    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
-	tmp = REG_SET_FIELD(tmp, MMMC_VM_MX_L1_TLB_CNTL, ECO_BITS, 0);
 	tmp = REG_SET_FIELD(tmp, MMMC_VM_MX_L1_TLB_CNTL,
 			    MTYPE, MTYPE_UC); /* UC, uncached */
 
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v9_4.c
@@ -190,8 +190,6 @@ static void mmhub_v9_4_init_tlb_regs(str
 	tmp = REG_SET_FIELD(tmp, VMSHAREDVC0_MC_VM_MX_L1_TLB_CNTL,
 			    SYSTEM_APERTURE_UNMAPPED_ACCESS, 0);
 	tmp = REG_SET_FIELD(tmp, VMSHAREDVC0_MC_VM_MX_L1_TLB_CNTL,
-			    ECO_BITS, 0);
-	tmp = REG_SET_FIELD(tmp, VMSHAREDVC0_MC_VM_MX_L1_TLB_CNTL,
 			    MTYPE, MTYPE_UC);/* XXX for emulation. */
 	tmp = REG_SET_FIELD(tmp, VMSHAREDVC0_MC_VM_MX_L1_TLB_CNTL,
 			    ATC_EN, 1);


