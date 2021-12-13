Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A03247263B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237419AbhLMJtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:49:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56838 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbhLMJrM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B520DB80CAB;
        Mon, 13 Dec 2021 09:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CF8C00446;
        Mon, 13 Dec 2021 09:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388830;
        bh=kCfyxNu9J4nF9/ZaoXcd7fTh3FfDzEv7qOs0W5HMDY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xtu4jCPtS8VnNKNIx1whUc3DkC1GLfA2HlpoLBuCAgCw3yq2FeZFYGilWwzv8ZoZm
         Cfbu+SOOJZLGLubYP36cehifhKqr0PxUmZupldgumv5f4GHpa8BprCoV2EaxDsbWfo
         C7DuG9a8QXcGtiSQBfwgDd4EqZBi/bKkPQ94LHJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 024/132] drm/amdgpu: move iommu_resume before ip init/resume
Date:   Mon, 13 Dec 2021 10:29:25 +0100
Message-Id: <20211213092939.936729537@linuxfoundation.org>
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

commit f02abeb0779700c308e661a412451b38962b8a0b upstream.

Separate iommu_resume from kfd_resume, and move it before
other amdgpu ip init/resume.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211277
Signed-off-by: James Zhu <James.Zhu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2220,6 +2220,10 @@ static int amdgpu_device_ip_init(struct
 	if (r)
 		goto init_failed;
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
@@ -2913,6 +2917,10 @@ static int amdgpu_device_ip_resume(struc
 {
 	int r;
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		return r;
+
 	r = amdgpu_device_ip_resume_phase1(adev);
 	if (r)
 		return r;
@@ -4296,6 +4304,10 @@ static int amdgpu_do_asic_reset(struct a
 
 			if (!r) {
 				dev_info(tmp_adev->dev, "GPU reset succeeded, trying to resume\n");
+				r = amdgpu_amdkfd_resume_iommu(tmp_adev);
+				if (r)
+					goto out;
+
 				r = amdgpu_device_ip_resume_phase1(tmp_adev);
 				if (r)
 					goto out;


