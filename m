Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60147452094
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345324AbhKPAzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245733AbhKOTVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8CC363288;
        Mon, 15 Nov 2021 18:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001616;
        bh=nnoI8PKTNJPb58Rsneu+k3K8BYiYVFKucbDiQSgEg9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aieq6oJk3efVrELkxoJJBIjQcjU00eUZr30OT3MvAKm1ly4bSxu0ujQqwwI7IJpBq
         hXU7G9M5bcAdtT+ut94GWpmaH6zWO7QKz//BCJo/Cif27NLj9U8OTgBpgnmbq8jWt/
         5niGbw9fGKPSUK4pRPo92j0oCQAfxcamLh7cM6Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, youling <youling257@gmail.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 257/917] drm/amdkfd: fix resume error when iommu disabled in Picasso
Date:   Mon, 15 Nov 2021 17:55:52 +0100
Message-Id: <20211115165437.509025737@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifan Zhang <yifan1.zhang@amd.com>

[ Upstream commit 6f4b590aae217da16cfa44039a2abcfb209137ab ]

When IOMMU disabled in sbios and kfd in iommuv2 path,
IOMMU resume failure blocks system resume. Don't allow kfd to
use iommu v2 when iommu is disabled.

Reported-by: youling <youling257@gmail.com>
Tested-by: youling <youling257@gmail.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index a6afacc3b10cd..88c483f699894 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -916,6 +916,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 	kfd_double_confirm_iommu_support(kfd);
 
 	if (kfd_iommu_device_init(kfd)) {
+		kfd->use_iommu_v2 = false;
 		dev_err(kfd_device, "Error initializing iommuv2\n");
 		goto device_iommu_error;
 	}
-- 
2.33.0



