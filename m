Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE60D38A256
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbhETJkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233311AbhETJjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:39:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2EE4961421;
        Thu, 20 May 2021 09:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503064;
        bh=DMPfJLhMJ1dY0RoG7NKxrjmH+LGy7NrejNLEePArhVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vU3tJ05e3fA6TMCWM86a1EMYF0g3VFmOG0dS2ItkkpCc1iAFwbXhjfY8QILQx/xN5
         D0WeH9rJquFgHym75DuQoIIuvPnEiA2cdleRmu62vGG2qWemuNnomYoewH7v3RlVVQ
         nwEHa8++h77E8BmZgVXDV4lZv8L7mjrvBEz/OJVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, shaoyunl <shaoyun.liu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/425] drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f
Date:   Thu, 20 May 2021 11:17:01 +0200
Message-Id: <20210520092133.145144528@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: shaoyunl <shaoyun.liu@amd.com>

[ Upstream commit c8941550aa66b2a90f4b32c45d59e8571e33336e ]

This recent change introduce SDMA interrupt info printing with irq->process function.
These functions do not require a set function to enable/disable the irq

Signed-off-by: shaoyunl <shaoyun.liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
index 1abf5b5bac9e..18402a6ba8fe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -447,7 +447,7 @@ void amdgpu_irq_gpu_reset_resume_helper(struct amdgpu_device *adev)
 		for (j = 0; j < AMDGPU_MAX_IRQ_SRC_ID; ++j) {
 			struct amdgpu_irq_src *src = adev->irq.client[i].sources[j];
 
-			if (!src)
+			if (!src || !src->funcs || !src->funcs->set)
 				continue;
 			for (k = 0; k < src->num_types; k++)
 				amdgpu_irq_update(adev, src, k);
-- 
2.30.2



