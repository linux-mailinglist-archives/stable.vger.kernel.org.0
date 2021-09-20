Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D374124D9
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353331AbhITSik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1380865AbhITSg2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:36:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03E0163315;
        Mon, 20 Sep 2021 17:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158972;
        bh=C4cH0UDDur67eRlFyBuo6RkYsdbJ2WoZPBYTLr1K/+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMtl7GR3SBC1Zj8zkSLgHJ569tYmL9m2CHZE3IxZ7h2rZjdpkO49C+FHmyxjyFYaK
         JMTevyl6K4DqDvQBRWtjgmji/uMdLU0H4TTrK1aUR95kIFdBJngEjIBpkBv4foBqHi
         7VixY7TqKnZ89iBnQ77bBw/kFGtsl9cCCmSrMMKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 018/168] drm/amdgpu: move iommu_resume before ip init/resume
Date:   Mon, 20 Sep 2021 18:42:36 +0200
Message-Id: <20210920163922.243795663@linuxfoundation.org>
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
@@ -2342,6 +2342,10 @@ static int amdgpu_device_ip_init(struct
 	if (r)
 		goto init_failed;
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		goto init_failed;
+
 	r = amdgpu_device_ip_hw_init_phase1(adev);
 	if (r)
 		goto init_failed;
@@ -3096,6 +3100,10 @@ static int amdgpu_device_ip_resume(struc
 {
 	int r;
 
+	r = amdgpu_amdkfd_resume_iommu(adev);
+	if (r)
+		return r;
+
 	r = amdgpu_device_ip_resume_phase1(adev);
 	if (r)
 		return r;
@@ -4534,6 +4542,10 @@ int amdgpu_do_asic_reset(struct list_hea
 				dev_warn(tmp_adev->dev, "asic atom init failed!");
 			} else {
 				dev_info(tmp_adev->dev, "GPU reset succeeded, trying to resume\n");
+				r = amdgpu_amdkfd_resume_iommu(tmp_adev);
+				if (r)
+					goto out;
+
 				r = amdgpu_device_ip_resume_phase1(tmp_adev);
 				if (r)
 					goto out;


