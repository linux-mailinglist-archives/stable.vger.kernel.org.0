Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62334124DC
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379738AbhITSim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380655AbhITSg1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D138063318;
        Mon, 20 Sep 2021 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158970;
        bh=VzkhfAzd0nfpuUZebesnToiQjgXAkm5q69+Q7WSNwgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KyvI1t825dJ9tG70uQzHNmaxNaL/qCePT/f8znFUzSZQXvRTOc10seA8G2ieQzC0m
         rq6OnJN6o/ujE73rRch8ihKW5U5uD7gYUActB1owDUHXtxijspmXkozsNXrL2wkDSl
         UCh3ji/bYUybYfhchTeybxOdGBfCei0ssqVFOYCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 017/168] drm/amdgpu: add amdgpu_amdkfd_resume_iommu
Date:   Mon, 20 Sep 2021 18:42:35 +0200
Message-Id: <20210920163922.212118654@linuxfoundation.org>
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

commit 8066008482e533e91934bee49765bf8b4a7c40db upstream.

Add amdgpu_amdkfd_resume_iommu for amdgpu.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211277
Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |   10 ++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |    1 +
 2 files changed, 11 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -191,6 +191,16 @@ void amdgpu_amdkfd_suspend(struct amdgpu
 		kgd2kfd_suspend(adev->kfd.dev, run_pm);
 }
 
+int amdgpu_amdkfd_resume_iommu(struct amdgpu_device *adev)
+{
+	int r = 0;
+
+	if (adev->kfd.dev)
+		r = kgd2kfd_resume_iommu(adev->kfd.dev);
+
+	return r;
+}
+
 int amdgpu_amdkfd_resume(struct amdgpu_device *adev, bool run_pm)
 {
 	int r = 0;
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -137,6 +137,7 @@ int amdgpu_amdkfd_init(void);
 void amdgpu_amdkfd_fini(void);
 
 void amdgpu_amdkfd_suspend(struct amdgpu_device *adev, bool run_pm);
+int amdgpu_amdkfd_resume_iommu(struct amdgpu_device *adev);
 int amdgpu_amdkfd_resume(struct amdgpu_device *adev, bool run_pm);
 void amdgpu_amdkfd_interrupt(struct amdgpu_device *adev,
 			const void *ih_ring_entry);


