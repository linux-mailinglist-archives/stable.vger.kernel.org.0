Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23165371C18
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbhECQvO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:51:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233744AbhECQt0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:49:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDBE06162A;
        Mon,  3 May 2021 16:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060014;
        bh=XY5Q3F7k4aS58IjutYJQkeCihrbXMHpVgZ7yIBOo/oY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYqKhondP9okMkiYRawaywJLuVL57355PDwKEcSBrx3UJhGfX9ensiyLoxlnBkyN3
         M1uB3+cRdX9bTH0NAlptUj5MteiSiTR+RP9MukxR9/cBY8r8DqcZ6fyBlzO4mX375a
         ehLSGnb896Plg6zbNZowI4B16l8aqAZd/KPycKer8p+woSRnw8WsSWESBP8CuOd7L/
         hrX/1YrZFfqdK7Oc0bC5nZyUdN/uONQbbOyuzl44YRkeFYa0PDJRGT1odDL4VMdtdM
         zu32qRuN0AvFVh+Bo0mtupQVrobxEk0jKhzjVn7wBSDYTiECGx7jcmNwz0QhddBkl+
         O0+gP7V7a3Y3A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     shaoyunl <shaoyun.liu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 22/57] drm/amdgpu : Fix asic reset regression issue introduce by 8f211fe8ac7c4f
Date:   Mon,  3 May 2021 12:39:06 -0400
Message-Id: <20210503163941.2853291-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163941.2853291-1-sashal@kernel.org>
References: <20210503163941.2853291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 2a3f5ec298db..76429932035e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_irq.c
@@ -469,7 +469,7 @@ void amdgpu_irq_gpu_reset_resume_helper(struct amdgpu_device *adev)
 		for (j = 0; j < AMDGPU_MAX_IRQ_SRC_ID; ++j) {
 			struct amdgpu_irq_src *src = adev->irq.client[i].sources[j];
 
-			if (!src)
+			if (!src || !src->funcs || !src->funcs->set)
 				continue;
 			for (k = 0; k < src->num_types; k++)
 				amdgpu_irq_update(adev, src, k);
-- 
2.30.2

