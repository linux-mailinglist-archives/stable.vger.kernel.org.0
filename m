Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5A97952C
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388638AbfG2Tj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:39:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389007AbfG2Tj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:39:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08B12054F;
        Mon, 29 Jul 2019 19:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429167;
        bh=ogbnlNUC6S7tpD8mTLT2XLlDbNBJ0HCrvSqhti6Jxuw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KapHvvS6dW9o+4e4HRc8FjdTmOoftIELdt8Cmlw9B9ze7L8fxvhbLvE/V/a+hUgq
         XFxQ9bNRefFlYiL6DEq4X4ZbW+k4SjgOS4kYb0QHOEOQ40S0qjNty8XeG8bd/fC17X
         YJecCYP1cmJo15h8ldnEj8X5D1KxkxmxJ0rnWvg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oak Zeng <ozeng@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/113] drm/amdkfd: Fix a potential memory leak
Date:   Mon, 29 Jul 2019 21:21:40 +0200
Message-Id: <20190729190658.972829549@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190655.455345569@linuxfoundation.org>
References: <20190729190655.455345569@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



