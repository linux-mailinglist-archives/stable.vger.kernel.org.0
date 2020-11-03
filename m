Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83522A57FE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731380AbgKCVrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:47:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731962AbgKCUvb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:51:31 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C24B22053B;
        Tue,  3 Nov 2020 20:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436690;
        bh=Tpe9V9+Ce0Apl347M+XtbWasUJ1aIj3qNAf92SdisEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0CM61Hhu8uhJCofbzub9LW3nS1NN0LB3c6snZbSnOKhGPC0oRCEhIUfqTF5yKU0+
         ZbdFl4gqr7YCeHEXPOLIUFqlXQ3SpF/FbZqLux3d6jmExxAVr8fhRvtGP2GBogFNQQ
         qwpYZ3SQAokdrUGSGfiCGJWLJpUWJMry82+EfvI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.9 361/391] drm/amdgpu: correct the cu and rb info for sienna cichlid
Date:   Tue,  3 Nov 2020 21:36:52 +0100
Message-Id: <20201103203411.499157211@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

commit 687e79c0feb4243b141b1e9a20adba3c0ec66f7f upstream.

Skip disabled sa to correct the cu_info and active_rbs for sienna cichlid.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4537,12 +4537,17 @@ static void gfx_v10_0_setup_rb(struct am
 	int i, j;
 	u32 data;
 	u32 active_rbs = 0;
+	u32 bitmap;
 	u32 rb_bitmap_width_per_sh = adev->gfx.config.max_backends_per_se /
 					adev->gfx.config.max_sh_per_se;
 
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
 		for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
+			bitmap = i * adev->gfx.config.max_sh_per_se + j;
+			if ((adev->asic_type == CHIP_SIENNA_CICHLID) &&
+			    ((gfx_v10_3_get_disabled_sa(adev) >> bitmap) & 1))
+				continue;
 			gfx_v10_0_select_se_sh(adev, i, j, 0xffffffff);
 			data = gfx_v10_0_get_rb_active_bitmap(adev);
 			active_rbs |= data << ((i * adev->gfx.config.max_sh_per_se + j) *
@@ -8761,6 +8766,10 @@ static int gfx_v10_0_get_cu_info(struct
 	mutex_lock(&adev->grbm_idx_mutex);
 	for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
 		for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
+			bitmap = i * adev->gfx.config.max_sh_per_se + j;
+			if ((adev->asic_type == CHIP_SIENNA_CICHLID) &&
+			    ((gfx_v10_3_get_disabled_sa(adev) >> bitmap) & 1))
+				continue;
 			mask = 1;
 			ao_bitmap = 0;
 			counter = 0;


