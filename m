Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9726B472618
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234133AbhLMJtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:04 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39450 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236603AbhLMJrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0C209CE0B59;
        Mon, 13 Dec 2021 09:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC424C00446;
        Mon, 13 Dec 2021 09:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388836;
        bh=sWiTJK3c64+gXHiQzoUryTdm1kf1T2CwMmd+hcjSwIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YbUzAGrFyOrOoqAmtq1CIb/NUJb+h4HlEcnE08XwEQk0xUWQDAVL+EjKLomTJsgjo
         ca5vbfmXljvZEavDMd0HHouwuWbhco3esjsdPUNV9ra6YnPPYmaV/1D3kraO3a/Xtl
         ZY7pyCht9dKxothF6f83oqui71TmpCNt1keqPJTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, youling <youling257@gmail.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 026/132] drm/amdkfd: fix boot failure when iommu is disabled in Picasso.
Date:   Mon, 13 Dec 2021 10:29:27 +0100
Message-Id: <20211213092940.006167973@linuxfoundation.org>
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

commit afd18180c07026f94a80ff024acef5f4159084a4 upstream.

When IOMMU disabled in sbios and kfd in iommuv2 path, iommuv2
init will fail. But this failure should not block amdgpu driver init.

Reported-by: youling <youling257@gmail.com>
Tested-by: youling <youling257@gmail.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    4 ----
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    |    3 +++
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2255,10 +2255,6 @@ static int amdgpu_device_ip_init(struct
 		amdgpu_xgmi_add_device(adev);
 	amdgpu_amdkfd_device_init(adev);
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -751,6 +751,9 @@ bool kgd2kfd_device_init(struct kfd_dev
 
 	kfd_cwsr_init(kfd);
 
+	if(kgd2kfd_resume_iommu(kfd))
+		goto device_iommu_error;
+
 	if (kfd_resume(kfd))
 		goto kfd_resume_error;
 


