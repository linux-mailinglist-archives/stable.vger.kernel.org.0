Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCBB469F00
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391194AbhLFPpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386619AbhLFP0s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:26:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B08C08E750;
        Mon,  6 Dec 2021 07:16:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5BC59B8111F;
        Mon,  6 Dec 2021 15:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA35C341C2;
        Mon,  6 Dec 2021 15:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803802;
        bh=6an3fPGhD9yba8PBXFRdcH7I6TORl7ue89Jpo4AOfyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mc380kP1aBpSb9+N8YjhxAEhE2IIU0kC3kyglCzHNNt4SxVeYeVBSnZpF/YSpD6aw
         vf8yOWZCC8lMenghkvHnjab8ZDRWEyt6F2D9mbqwAh/JKRinHkYXLFRd4/fRfi6B6N
         ggsrmmXkjU8BvXAqv0h8u+YwjOfES5j0yy1Hnzik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifan Zhang <yifan1.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 051/130] drm/amdgpu: init iommu after amdkfd device init
Date:   Mon,  6 Dec 2021 15:56:08 +0100
Message-Id: <20211206145601.449546485@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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


