Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983AE469C6C
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347913AbhLFPWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:22:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38978 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359484AbhLFPUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:20:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC5DB61321;
        Mon,  6 Dec 2021 15:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB1EC341C1;
        Mon,  6 Dec 2021 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803799;
        bh=kCfyxNu9J4nF9/ZaoXcd7fTh3FfDzEv7qOs0W5HMDY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0+erF2mzQNYReNsTRI4Yz7+CbPmNYrn+PFjPCi0c/wWpU4CVpKYq27XnQeNiHwD12
         QQXYwlk/Z/I3AJ2KSzz03nX5C8HTWHF0zpS/2NGktZ/+kWwenb7U6UOJMw7uX4dpa/
         BKEMSBxWgitnQKhQBU6ZMj8mZmPipdgmQupsaCpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 050/130] drm/amdgpu: move iommu_resume before ip init/resume
Date:   Mon,  6 Dec 2021 15:56:07 +0100
Message-Id: <20211206145601.413365434@linuxfoundation.org>
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


