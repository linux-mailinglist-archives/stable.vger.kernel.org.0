Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A99A47263A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbhLMJtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38038 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbhLMJrH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 38BB7CE0E29;
        Mon, 13 Dec 2021 09:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D841CC00446;
        Mon, 13 Dec 2021 09:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388824;
        bh=f1z6pgnMtO5cJQlso1Ab2tO1c69kf+mXxCQqm67iGrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pls2Hj2Xoa43QpBUIgzjzp+o03ubC0sYzXdN8aUDWI2TlHAvXyJ+ueeO5vAo8SvEw
         l3xvB4FYwp6KAzadEE1vu23TYIcdWGCddqjJhPI30EQ5fHx/OvBIWvsuQcFO6zLPUM
         cinvh295CK6t0xWaIz3FbPcujf8FGlzamhNucPzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 022/132] drm/amdkfd: separate kfd_iommu_resume from kfd_resume
Date:   Mon, 13 Dec 2021 10:29:23 +0100
Message-Id: <20211213092939.860749058@linuxfoundation.org>
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
@@ -305,6 +305,7 @@ bool kgd2kfd_device_init(struct kfd_dev
 			 const struct kgd2kfd_shared_resources *gpu_resources);
 void kgd2kfd_device_exit(struct kfd_dev *kfd);
 void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm);
+int kgd2kfd_resume_iommu(struct kfd_dev *kfd);
 int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm);
 int kgd2kfd_pre_reset(struct kfd_dev *kfd);
 int kgd2kfd_post_reset(struct kfd_dev *kfd);
@@ -343,6 +344,11 @@ static inline void kgd2kfd_suspend(struc
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
@@ -896,17 +896,21 @@ int kgd2kfd_resume(struct kfd_dev *kfd,
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


