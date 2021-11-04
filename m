Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEED4454A7
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhKDOQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhKDOQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:16:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78522611C1;
        Thu,  4 Nov 2021 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035240;
        bh=Fou5bH2CuCc3nmXvDioczqwhNzvEIvSddWsbb2g8yS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwlxT5DsDM5CY5PaA33vlJP1TLzq2QOjNr1aitWC06RocOppLF0Y6BZ/ZLFw7njNX
         JdyoKI9wFNfJS2jgCj2FpiiCtcTmxUlnuxZS+ZdxVYHNvN21TJeIfNy+AdqclEa4nn
         lcbkfyTS1t3s6pyAUHPF97NjJeHmPkRbTm6FTYzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, youling <youling257@gmail.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 05/12] drm/amdkfd: fix boot failure when iommu is disabled in Picasso.
Date:   Thu,  4 Nov 2021 15:12:31 +0100
Message-Id: <20211104141159.729493351@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
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
@@ -2432,10 +2432,6 @@ static int amdgpu_device_ip_init(struct
 	if (!adev->gmc.xgmi.pending_reset)
 		amdgpu_amdkfd_device_init(adev);
 
-	r = amdgpu_amdkfd_resume_iommu(adev);
-	if (r)
-		goto init_failed;
-
 	amdgpu_fru_get_product_info(adev);
 
 init_failed:
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -924,6 +924,9 @@ bool kgd2kfd_device_init(struct kfd_dev
 
 	svm_migrate_init((struct amdgpu_device *)kfd->kgd);
 
+	if(kgd2kfd_resume_iommu(kfd))
+		goto device_iommu_error;
+
 	if (kfd_resume(kfd))
 		goto kfd_resume_error;
 


