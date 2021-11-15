Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0C451009
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242481AbhKOSlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242432AbhKOSgu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:36:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB38A63270;
        Mon, 15 Nov 2021 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999384;
        bh=61IdOsDbuR23eh4huIIIW5QN7TMSHXB+vB+VngHPjD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z3nCmxNdXdkpl/m9tyX3i8FdjlOrfgDBjyyoF62rl4q+4VVxcZ7Yvrxr0+jZVfTfQ
         gduiQG8HiYMee1nqYenjKBwYcvIrqCxdyyf83d/UL/oo713qL7JEPqItnltP5qQUV6
         r4Kr6fB8VxVXnoEyR/AjfVZ7FyLZcEOHO/3mE8DI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, youling <youling257@gmail.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 276/849] drm/amdkfd: fix resume error when iommu disabled in Picasso
Date:   Mon, 15 Nov 2021 17:55:59 +0100
Message-Id: <20211115165429.584416461@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index ef64fb8f1bbf5..900ea693c71c6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -867,6 +867,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 	kfd_double_confirm_iommu_support(kfd);
 
 	if (kfd_iommu_device_init(kfd)) {
+		kfd->use_iommu_v2 = false;
 		dev_err(kfd_device, "Error initializing iommuv2\n");
 		goto device_iommu_error;
 	}
-- 
2.33.0



