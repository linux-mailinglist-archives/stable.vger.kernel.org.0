Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590996DB65
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732895AbfGSEII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:08:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731309AbfGSEIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:08:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42E72184E;
        Fri, 19 Jul 2019 04:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509286;
        bh=IfB97Bn5uzpoLRSH6ClsAiqyxggvd+YTlvZlopvmv7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z8/uqkai8qnKP7bh8Xuch6IZuqQON642mY1UiLwrS7a00U2N527L796wu7JT26lIb
         ebNsXi/3i/4ot51z/H7xWZdQm7SpXOsf4vebjIGrOv8fG2FUq4cj3/LybVOwbxEPV/
         8cXIadA2/RxEdBPcjtismYs7RZGCAXsdoo8bZO2M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oak Zeng <ozeng@amd.com>, Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 013/101] drm/amdkfd: Fix a potential memory leak
Date:   Fri, 19 Jul 2019 00:06:04 -0400
Message-Id: <20190719040732.17285-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oak Zeng <ozeng@amd.com>

[ Upstream commit e73390d181103a19e1111ec2f25559a0570e9fe0 ]

Free mqd_mem_obj it GTT buffer allocation for MQD+control stack fails.

Signed-off-by: Oak Zeng <ozeng@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index 0cedb37cf513..985bebde5a34 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -75,6 +75,7 @@ static int init_mqd(struct mqd_manager *mm, void **mqd,
 	struct v9_mqd *m;
 	struct kfd_dev *kfd = mm->dev;
 
+	*mqd_mem_obj = NULL;
 	/* From V9,  for CWSR, the control stack is located on the next page
 	 * boundary after the mqd, we will use the gtt allocation function
 	 * instead of sub-allocation function.
@@ -92,8 +93,10 @@ static int init_mqd(struct mqd_manager *mm, void **mqd,
 	} else
 		retval = kfd_gtt_sa_allocate(mm->dev, sizeof(struct v9_mqd),
 				mqd_mem_obj);
-	if (retval != 0)
+	if (retval) {
+		kfree(*mqd_mem_obj);
 		return -ENOMEM;
+	}
 
 	m = (struct v9_mqd *) (*mqd_mem_obj)->cpu_ptr;
 	addr = (*mqd_mem_obj)->gpu_addr;
-- 
2.20.1

