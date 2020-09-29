Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAA327C989
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732059AbgI2ML1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730168AbgI2Lhd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:33 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B39A23BCD;
        Tue, 29 Sep 2020 11:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379327;
        bh=tWNmLNTC4xNwsIwyQ68ebsA5j2KIZRLstIrhjapgaXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AssWMtYW3Bv+GjtBCTDWXlgklLMEw0ebenhvomML1c6mxOY6llMKnpbgiUt135SSP
         Zv+pjnEyLNyRLqYWbaQTIAWU41VDSC30ZDpEe/+3TFt3vTh8BVy/TtvhWxOmqiR+Ww
         NS0Lky1OwCIcxr8hjDOmRSJJpRtJIjYLCFgwaVHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Cheng <tony.cheng@amd.com>,
        Yongqiang Sun <yongqiang.sun@amd.com>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 113/388] drm/amd/display: fix workaround for incorrect double buffer register for DLG ADL and TTU
Date:   Tue, 29 Sep 2020 12:57:24 +0200
Message-Id: <20200929110015.946049878@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



