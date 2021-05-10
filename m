Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16933378845
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239115AbhEJLVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236810AbhEJLK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7970261482;
        Mon, 10 May 2021 11:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644744;
        bh=GXgwS477ZFIFyxILoCsoeJjdFko0lrRngwkhvWY9Pss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jf5ZSOLAbvyEdeU9HOzmT3QiWiXnx9pK+Du9yn0xvE8F/DA9EJFfACch2x4WLYLSQ
         L++UJaxDGG5U2yYWl5Yu1/fo6TGy0eN+8xwpnblcbYmneGTgfJZlZUYjG3Nd+7a17c
         UR0hnrzUzi59MJNDyrqmmwoz/bkc/IXnCun8RbEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, shaoyunl <shaoyun.liu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 189/384] drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f
Date:   Mon, 10 May 2021 12:19:38 +0200
Message-Id: <20210510102021.114954440@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index afbbec82a289..9be945d8e72f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -535,7 +535,7 @@ void amdgpu_irq_gpu_reset_resume_helper(struct amdgpu_device *adev)
 		for (j = 0; j < AMDGPU_MAX_IRQ_SRC_ID; ++j) {
 			struct amdgpu_irq_src *src = adev->irq.client[i].sources[j];
 
-			if (!src)
+			if (!src || !src->funcs || !src->funcs->set)
 				continue;
 			for (k = 0; k < src->num_types; k++)
 				amdgpu_irq_update(adev, src, k);
-- 
2.30.2



