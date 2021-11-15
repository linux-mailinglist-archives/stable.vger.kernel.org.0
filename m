Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834CE4526C8
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346773AbhKPCK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:40730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239026AbhKOR7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B54A632D0;
        Mon, 15 Nov 2021 17:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997740;
        bh=zuPjlIYJYKZ3QiZEr0D6UcZ6zWlmvrvVMVVsV8F/cPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtIi8RT/1v0F1kp+R3wPcXIDTOS8H8QGuKn+yMFHZUp5FrbDnIagZMfR5kNW/YdOG
         qDkuhja5/pjMt5XYxIuHvW9KQuDwX0sa9Yd7acEX2U1544fjZsg2kZPdYGT2p2o1iJ
         WW/JeOiocSzyfkzxkNx+BsK4U+BtsuDIOKuEFu94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, youling <youling257@gmail.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/575] drm/amdkfd: fix resume error when iommu disabled in Picasso
Date:   Mon, 15 Nov 2021 17:59:00 +0100
Message-Id: <20211115165351.150701140@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 903170e59342c..5751bddc9cadd 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -744,6 +744,7 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 	kfd_double_confirm_iommu_support(kfd);
 
 	if (kfd_iommu_device_init(kfd)) {
+		kfd->use_iommu_v2 = false;
 		dev_err(kfd_device, "Error initializing iommuv2\n");
 		goto device_iommu_error;
 	}
-- 
2.33.0



