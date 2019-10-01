Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D934EC3B4B
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbfJAQna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732757AbfJAQn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BA0F21924;
        Tue,  1 Oct 2019 16:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948208;
        bh=9KK+zWA/y/bDSujiZFJZWo7AuGxM4XHwDzPBWNMWyak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDv/Y3mZ6kiybuF65Y9SCXMnVtGvRisxiB+0l6Ci36tBFoDXhX+8GK+rpny4ig9k6
         95FfXHbdKhK3ErxoBF8BlIl1j1TIvGnnfwGnxLUbAy/ZS2v0oJ0Vp/Ll9QVfaooOND
         cnNORkoxUJ6kAICc40KPvNuWwgYxDYzvmdXHYdPg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Kuehling <Felix.Kuehling@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 13/43] drm/amdgpu: Fix KFD-related kernel oops on Hawaii
Date:   Tue,  1 Oct 2019 12:42:41 -0400
Message-Id: <20191001164311.15993-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit dcafbd50f2e4d5cc964aae409fb5691b743fba23 ]

Hawaii needs to flush caches explicitly, submitting an IB in a user
VMID from kernel mode. There is no s_fence in this case.

Fixes: eb3961a57424 ("drm/amdgpu: remove fence context from the job")
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
index 51b5e977ca885..f4e9d1b10e3ed 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ib.c
@@ -139,7 +139,8 @@ int amdgpu_ib_schedule(struct amdgpu_ring *ring, unsigned num_ibs,
 	/* ring tests don't use a job */
 	if (job) {
 		vm = job->vm;
-		fence_ctx = job->base.s_fence->scheduled.context;
+		fence_ctx = job->base.s_fence ?
+			job->base.s_fence->scheduled.context : 0;
 	} else {
 		vm = NULL;
 		fence_ctx = 0;
-- 
2.20.1

