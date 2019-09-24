Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A650BCFEE
	for <lists+stable@lfdr.de>; Tue, 24 Sep 2019 19:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633117AbfIXQoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Sep 2019 12:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390485AbfIXQoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Sep 2019 12:44:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2857320872;
        Tue, 24 Sep 2019 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569343451;
        bh=c7zXr1QtC0TThWpH9wNCX5riuVJELFhrzHMZGgtypPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCtP2ZkeJkep2VHzmlKV+RjZJFyOmIWHFS2tQZ6x8w/XmdbxUaFsKOackClOP95P9
         7tsycYBEuzoLZ5wKTs5fD0t0ltIsrbbz6LAoLHGszKcigj5pa3LDIRxSxutmCNtx2w
         dZTwRAR7ff2hk6CRtdOpK/TpcAcgzpnL6/23jVl4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 53/87] drm/amdgpu/sdma5: fix number of sdma5 trap irq types for navi1x
Date:   Tue, 24 Sep 2019 12:41:09 -0400
Message-Id: <20190924164144.25591-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190924164144.25591-1-sashal@kernel.org>
References: <20190924164144.25591-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaojie Yuan <xiaojie.yuan@amd.com>

[ Upstream commit 9e48495017342c5d445b25eedd86d6fd884a6496 ]

v2: set num_types based on num_instances

navi1x has 2 sdma engines but commit
"e7b58d03b678 drm/amdgpu: reorganize sdma v4 code to support more instances"
changes the max number of sdma irq types (AMDGPU_SDMA_IRQ_LAST) from 2 to 8
which causes amdgpu_irq_gpu_reset_resume_helper() to recover irq of sdma
engines with following logic:

(enable irq for sdma0) * 1 time
(enable irq for sdma1) * 1 time
(disable irq for sdma1) * 6 times

as a result, after gpu reset, interrupt for sdma1 is lost.

Signed-off-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index 3747c3f1f0cc8..15c371fac469e 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1583,7 +1583,8 @@ static const struct amdgpu_irq_src_funcs sdma_v5_0_illegal_inst_irq_funcs = {
 
 static void sdma_v5_0_set_irq_funcs(struct amdgpu_device *adev)
 {
-	adev->sdma.trap_irq.num_types = AMDGPU_SDMA_IRQ_LAST;
+	adev->sdma.trap_irq.num_types = AMDGPU_SDMA_IRQ_INSTANCE0 +
+					adev->sdma.num_instances;
 	adev->sdma.trap_irq.funcs = &sdma_v5_0_trap_irq_funcs;
 	adev->sdma.illegal_inst_irq.funcs = &sdma_v5_0_illegal_inst_irq_funcs;
 }
-- 
2.20.1

