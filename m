Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B7A4124E4
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381141AbhITSjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1381243AbhITShB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:37:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E3E86331B;
        Mon, 20 Sep 2021 17:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158978;
        bh=cYEKh37Lq1p2vtrQzdIjB5/nb8e7rTNugfEzW0uy68Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L37LiFOchChmb8GKQwhdhe+Kqe+pYAbZPRVlwakm20O2Ihf9rf8VP0aX34Dgpareg
         5IhkMFQ4RlzMQFcab+PqWiT+FkYh/QscyvkZRfzdieL8YAK457JVXg1PON5Lfxjrzs
         EIck5aoiEinUbq3uj5O/htPf+CPMFEsfH/ulRb04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 020/168] drm/amdkfd: separate kfd_iommu_resume from kfd_resume
Date:   Mon, 20 Sep 2021 18:42:38 +0200
Message-Id: <20210920163922.313113287@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Zhu <James.Zhu@amd.com>

commit fefc01f042f44ede373ee66773b8238dd8fdcb55 upstream.

Separate kfd_iommu_resume from kfd_resume for fine-tuning
of amdgpu device init/resume/reset/recovery sequence.

v2: squash in fix for !CONFIG_HSA_AMD

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211277
Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |    6 ++++++
 drivers/gpu/drm/amd/amdkfd/kfd_device.c    |   12 ++++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -326,6 +326,7 @@ bool kgd2kfd_device_init(struct kfd_dev
 			 const struct kgd2kfd_shared_resources *gpu_resources);
 void kgd2kfd_device_exit(struct kfd_dev *kfd);
 void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm);
+int kgd2kfd_resume_iommu(struct kfd_dev *kfd);
 int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm);
 int kgd2kfd_pre_reset(struct kfd_dev *kfd);
 int kgd2kfd_post_reset(struct kfd_dev *kfd);
@@ -364,6 +365,11 @@ static inline void kgd2kfd_suspend(struc
 {
 }
 
+static int __maybe_unused kgd2kfd_resume_iommu(struct kfd_dev *kfd)
+{
+	return 0;
+}
+
 static inline int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
 {
 	return 0;
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -1008,17 +1008,21 @@ int kgd2kfd_resume(struct kfd_dev *kfd,
 	return ret;
 }
 
-static int kfd_resume(struct kfd_dev *kfd)
+int kgd2kfd_resume_iommu(struct kfd_dev *kfd)
 {
 	int err = 0;
 
 	err = kfd_iommu_resume(kfd);
-	if (err) {
+	if (err)
 		dev_err(kfd_device,
 			"Failed to resume IOMMU for device %x:%x\n",
 			kfd->pdev->vendor, kfd->pdev->device);
-		return err;
-	}
+	return err;
+}
+
+static int kfd_resume(struct kfd_dev *kfd)
+{
+	int err = 0;
 
 	err = kfd->dqm->ops.start(kfd->dqm);
 	if (err) {


