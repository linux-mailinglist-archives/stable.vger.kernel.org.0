Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26611A0BBC
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgDGKZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:35668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728497AbgDGKZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 842CA20644;
        Tue,  7 Apr 2020 10:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255110;
        bh=q7wvOp/B+vcsKe//MRTz/um2sZICyj6+bgXMc/jce7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuNRWLG0fboRy3+wTx8zjgBPnsM8s6RUZPQltm29vqsZ+9CH3HvZ4zD7oNP3N1Z+h
         hR5P38nGDhGiSZYCU4wwktYVai2sZN55DLcofTrJQHxIGFrWJ7wmhDwiuFaZrvoYVB
         8ecNBkHKFsxlrhVMA7oPwVFobK04KwMFoEIcwbEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 09/46] drm/amdgpu: add fbdev suspend/resume on gpu reset
Date:   Tue,  7 Apr 2020 12:21:40 +0200
Message-Id: <20200407101500.474076886@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 063e768ebd27d3ec0d6908b7f8ea9b0a732b9949 ]

This can fix the baco reset failure seen on Navi10.
And this should be a low risk fix as the same sequence
is already used for system suspend/resume.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 332b9c24a2cd0..9a8a1c6ca3210 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3854,6 +3854,8 @@ static int amdgpu_do_asic_reset(struct amdgpu_hive_info *hive,
 				if (r)
 					goto out;
 
+				amdgpu_fbdev_set_suspend(tmp_adev, 0);
+
 				/* must succeed. */
 				amdgpu_ras_resume(tmp_adev);
 
@@ -4023,6 +4025,8 @@ int amdgpu_device_gpu_recover(struct amdgpu_device *adev,
 		 */
 		amdgpu_unregister_gpu_instance(tmp_adev);
 
+		amdgpu_fbdev_set_suspend(adev, 1);
+
 		/* disable ras on ALL IPs */
 		if (!in_ras_intr && amdgpu_device_ip_need_full_reset(tmp_adev))
 			amdgpu_ras_suspend(tmp_adev);
-- 
2.20.1



