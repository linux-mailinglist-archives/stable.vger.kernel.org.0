Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA09926EB2C
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIRCDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgIRCDl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:03:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 454D923600;
        Fri, 18 Sep 2020 02:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394617;
        bh=tWNmLNTC4xNwsIwyQ68ebsA5j2KIZRLstIrhjapgaXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sOQeA6mkfIT7pP4E34egmCAoMbS/OchyGJLUwmQGvAPUCtaCAVPBWWP52oZ8eHXRN
         49LmYBxd6GmFpis5UN0ZtkKr6PLoW8yCqCkn5R85gp4f4XcYBBxbK7I5pGaGr3nC/C
         nBKBJtp9YcV5ffp3Q5OugZqs1CD2zZKevjT2rz18=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Cheng <tony.cheng@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 119/330] drm/amd/display: fix workaround for incorrect double buffer register for DLG ADL and TTU
Date:   Thu, 17 Sep 2020 21:57:39 -0400
Message-Id: <20200918020110.2063155-119-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Cheng <tony.cheng@amd.com>

[ Upstream commit 85e148fb963d27152a14e6d399a47aed9bc99c15 ]

[Why]
these registers should have been double buffered. SW workaround we will have SW program the more aggressive (lower) values
whenever we are upating this register, so we will not have underflow at expense of less optimzal request pattern.

[How]
there is a driver bug where we don't check for 0, which is uninitialzed HW default.  since 0 is smaller than any value we need to program,
driver end up with not programming these registers

Signed-off-by: Tony Cheng <tony.cheng@amd.com>
Reviewed-by: Yongqiang Sun <yongqiang.sun@amd.com>
Acked-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c | 35 +++++++++++++------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
index a00af513aa2b0..c8f77bd0ce8a6 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_hubp.c
@@ -73,32 +73,47 @@ void apply_DEDCN21_142_wa_for_hostvm_deadline(
 		struct _vcs_dpi_display_dlg_regs_st *dlg_attr)
 {
 	struct dcn21_hubp *hubp21 = TO_DCN21_HUBP(hubp);
-	uint32_t cur_value;
+	uint32_t refcyc_per_vm_group_vblank;
+	uint32_t refcyc_per_vm_req_vblank;
+	uint32_t refcyc_per_vm_group_flip;
+	uint32_t refcyc_per_vm_req_flip;
+	const uint32_t uninitialized_hw_default = 0;
 
-	REG_GET(VBLANK_PARAMETERS_5, REFCYC_PER_VM_GROUP_VBLANK, &cur_value);
-	if (cur_value > dlg_attr->refcyc_per_vm_group_vblank)
+	REG_GET(VBLANK_PARAMETERS_5,
+			REFCYC_PER_VM_GROUP_VBLANK, &refcyc_per_vm_group_vblank);
+
+	if (refcyc_per_vm_group_vblank == uninitialized_hw_default ||
+			refcyc_per_vm_group_vblank > dlg_attr->refcyc_per_vm_group_vblank)
 		REG_SET(VBLANK_PARAMETERS_5, 0,
 				REFCYC_PER_VM_GROUP_VBLANK, dlg_attr->refcyc_per_vm_group_vblank);
 
 	REG_GET(VBLANK_PARAMETERS_6,
-			REFCYC_PER_VM_REQ_VBLANK,
-			&cur_value);
-	if (cur_value > dlg_attr->refcyc_per_vm_req_vblank)
+			REFCYC_PER_VM_REQ_VBLANK, &refcyc_per_vm_req_vblank);
+
+	if (refcyc_per_vm_req_vblank == uninitialized_hw_default ||
+			refcyc_per_vm_req_vblank > dlg_attr->refcyc_per_vm_req_vblank)
 		REG_SET(VBLANK_PARAMETERS_6, 0,
 				REFCYC_PER_VM_REQ_VBLANK, dlg_attr->refcyc_per_vm_req_vblank);
 
-	REG_GET(FLIP_PARAMETERS_3, REFCYC_PER_VM_GROUP_FLIP, &cur_value);
-	if (cur_value > dlg_attr->refcyc_per_vm_group_flip)
+	REG_GET(FLIP_PARAMETERS_3,
+			REFCYC_PER_VM_GROUP_FLIP, &refcyc_per_vm_group_flip);
+
+	if (refcyc_per_vm_group_flip == uninitialized_hw_default ||
+			refcyc_per_vm_group_flip > dlg_attr->refcyc_per_vm_group_flip)
 		REG_SET(FLIP_PARAMETERS_3, 0,
 				REFCYC_PER_VM_GROUP_FLIP, dlg_attr->refcyc_per_vm_group_flip);
 
-	REG_GET(FLIP_PARAMETERS_4, REFCYC_PER_VM_REQ_FLIP, &cur_value);
-	if (cur_value > dlg_attr->refcyc_per_vm_req_flip)
+	REG_GET(FLIP_PARAMETERS_4,
+			REFCYC_PER_VM_REQ_FLIP, &refcyc_per_vm_req_flip);
+
+	if (refcyc_per_vm_req_flip == uninitialized_hw_default ||
+			refcyc_per_vm_req_flip > dlg_attr->refcyc_per_vm_req_flip)
 		REG_SET(FLIP_PARAMETERS_4, 0,
 					REFCYC_PER_VM_REQ_FLIP, dlg_attr->refcyc_per_vm_req_flip);
 
 	REG_SET(FLIP_PARAMETERS_5, 0,
 			REFCYC_PER_PTE_GROUP_FLIP_C, dlg_attr->refcyc_per_pte_group_flip_c);
+
 	REG_SET(FLIP_PARAMETERS_6, 0,
 			REFCYC_PER_META_CHUNK_FLIP_C, dlg_attr->refcyc_per_meta_chunk_flip_c);
 }
-- 
2.25.1

