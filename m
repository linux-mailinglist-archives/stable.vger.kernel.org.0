Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4376472616
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237319AbhLMJtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33306 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbhLMJrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 870D8B80E1B;
        Mon, 13 Dec 2021 09:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2523C341C5;
        Mon, 13 Dec 2021 09:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388833;
        bh=6an3fPGhD9yba8PBXFRdcH7I6TORl7ue89Jpo4AOfyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PN4MbT/96sD7191GBC/xsYglvm1J0iUNGv5TnZ3M4QAkhpeOqCcPtv4WulBJ4icaY
         uDknwp573GyZhVhROwxTNy6uHdGNqRGMKHmi6TfnkajlBjhEUwhdc1wT8c2WtSUf/K
         myuff2sKCJdOIcOhUTaM9lilN2IsyhAeZJTlR+Z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifan Zhang <yifan1.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 025/132] drm/amdgpu: init iommu after amdkfd device init
Date:   Mon, 13 Dec 2021 10:29:26 +0100
Message-Id: <20211213092939.968217354@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 714d9e4574d54596973ee3b0624ee4a16264d700 upstream.

This patch is to fix clinfo failure in Raven/Picasso:

Number of platforms: 1
  Platform Profile: FULL_PROFILE
  Platform Version: OpenCL 2.2 AMD-APP (3364.0)
  Platform Name: AMD Accelerated Parallel Processing
  Platform Vendor: Advanced Micro Devices, Inc.
  Platform Extensions: cl_khr_icd cl_amd_event_callback

  Platform Name: AMD Accelerated Parallel Processing Number of devices: 0

Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Tested-by: James Zhu <James.Zhu@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2220,10 +2220,6 @@ static int amdgpu_device_ip_init(struct
 	if (r)
 		goto init_failed;
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
@@ -2259,6 +2255,10 @@ static int amdgpu_device_ip_init(struct
 		amdgpu_xgmi_add_device(adev);
 	amdgpu_amdkfd_device_init(adev);
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:


