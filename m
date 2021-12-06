Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1AD5469C6A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhLFPWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:22:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37002 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359067AbhLFPUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:20:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC8EC61320;
        Mon,  6 Dec 2021 15:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB5AC341C5;
        Mon,  6 Dec 2021 15:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803794;
        bh=um8oBo1wD9n6QxX25vwKi45jzaIete6Fpcxqi1IEgHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFvALBeIpqsRtqAD2UggzflWZmFJiRTck9WtOySzh0iO3oWdTGiialryRMBLKywhD
         T+0w83TLBuPBSZLd0WTyNq/1VeQGY8ERKL3UhZj07ekTkfPrRRZm4H3r13u+/kzy6F
         Jm6k/Qluz1yIxTfzG25iJ7+t7P9hPDe85VSF2QGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 049/130] drm/amdgpu: add amdgpu_amdkfd_resume_iommu
Date:   Mon,  6 Dec 2021 15:56:06 +0100
Message-Id: <20211206145601.374801900@linuxfoundation.org>
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
@@ -194,6 +194,16 @@ void amdgpu_amdkfd_suspend(struct amdgpu
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
@@ -126,6 +126,7 @@ int amdgpu_amdkfd_init(void);
 void amdgpu_amdkfd_fini(void);
 
 void amdgpu_amdkfd_suspend(struct amdgpu_device *adev, bool run_pm);
+int amdgpu_amdkfd_resume_iommu(struct amdgpu_device *adev);
 int amdgpu_amdkfd_resume(struct amdgpu_device *adev, bool run_pm);
 void amdgpu_amdkfd_interrupt(struct amdgpu_device *adev,
 			const void *ih_ring_entry);


