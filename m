Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCCAD2A4B7B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 17:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgKCQ3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 11:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgKCQ3U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 11:29:20 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5BAC0613D1
        for <stable@vger.kernel.org>; Tue,  3 Nov 2020 08:29:20 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id m14so11974691qtc.12
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 08:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bIoFzonjoY401Cg0ra5WwfsOvOK6cmHDTIRVCXL5XTY=;
        b=Bp5n4n0jCM+q2mtNMALF6lhGpIa39HHAyBfdopJZjg+PpHjQ1gKe8RC/ro92dK6wlU
         vWvoBYDBfLH+ehiVG02ZbFtKOmS1XEil3goxEk62Ux0hBmDT08C+1XiZP6Ix10NFlcJx
         LX/KAKbh4rZHgU84Ygi6ud7lI3ogkPuGpWAtYvmTlZ9sP/ZLC0EkxuXEuNM+wRscgqMw
         cSJgnGQODT9UYhVGeuTSh9va07rpjZQM8WBCI6AA3lah8soi78dCzipQMAhG7NBzlO6A
         Ep45+uLLSrqd+1p/c1Nu+CSBAwlDftLBelqoFxrq1UqTwSVVd/6gO8f/ElDrYVWUEdva
         w4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bIoFzonjoY401Cg0ra5WwfsOvOK6cmHDTIRVCXL5XTY=;
        b=pUFO+lS3GM5tpMdC5dnRbNWIvYkQySFLkZPbPjyF9L+uESKhoPYACquAxU72E2e67+
         BRuHn9OaKeHBLOIwQBVgg0Pr/noK4jCjEelDvVP1JdpvYWpHTKKA1j2HMkPVxFnws8r6
         yRqwwunbp/PzUx51AqV/QlotTM3P42r+m7SvL8M+mQ6/wWH9O8419+0IPJYftfTz0Uxj
         Y1gRbGWKiFJfhfuEcZqkj0yUNA1y3cj2iEatCsRzCUYprh7drLaHu7TCCNSSKOLcG5qQ
         sskO7Vt1uN/ikm7MSNUFAIirSN3Da41f3t+KqNdbZfFIlVjeHwOgN6Ut7CAJG0Dyk+TL
         j3dQ==
X-Gm-Message-State: AOAM5318ONjmg2UX60g7LkxdLjV0TuJ9AmRkS0+FQ5nc5VjctEBfY756
        UoLhoTArRLZ6TEIv0xQqaYaMVmLqW74=
X-Google-Smtp-Source: ABdhPJyYXMqHL/5UDowFsL2Wxnb6m1Ih4yZhLI2ja4s8Ppk+0GPCWaHoUgYKKLH6oZOPdZl/lpQTzQ==
X-Received: by 2002:ac8:4419:: with SMTP id j25mr20543826qtn.359.1604420959318;
        Tue, 03 Nov 2020 08:29:19 -0800 (PST)
Received: from localhost.localdomain ([71.219.66.138])
        by smtp.gmail.com with ESMTPSA id d48sm10171434qta.26.2020.11.03.08.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 08:29:18 -0800 (PST)
From:   Alex Deucher <alexdeucher@gmail.com>
X-Google-Original-From: Alex Deucher <alexander.deucher@amd.com>
To:     stable@vger.kernel.org
Cc:     Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6/7] drm/amdgpu: correct the cu and rb info for sienna cichlid
Date:   Tue,  3 Nov 2020 11:29:02 -0500
Message-Id: <20201103162903.687752-8-alexander.deucher@amd.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201103162903.687752-1-alexander.deucher@amd.com>
References: <20201103162903.687752-1-alexander.deucher@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Likun Gao <Likun.Gao@amd.com>

Skip disabled sa to correct the cu_info and active_rbs for sienna cichlid.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.9.x
(cherry picked from commit 687e79c0feb4243b141b1e9a20adba3c0ec66f7f)
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index b1cb7bf5dd10..190161d1a466 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4536,12 +4536,17 @@ static void gfx_v10_0_setup_rb(struct amdgpu_device *adev)
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
@@ -8760,6 +8765,10 @@ static int gfx_v10_0_get_cu_info(struct amdgpu_device *adev,
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
-- 
2.25.4

