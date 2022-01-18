Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8DE491627
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343661AbiARCc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46568 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344181AbiARC3S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CFD86119A;
        Tue, 18 Jan 2022 02:29:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5D7C36AF3;
        Tue, 18 Jan 2022 02:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472957;
        bh=F4q09PcjBgUukBysrwd15UYEG4A+dn6xaDs9qiOmli0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6gpgXkuCaXj95D6jsFtlcJM0K4FL34XGJdOUyLdC1lRS/jfVsIKJHrztFIkmgYmF
         osE8v7G3+fZ3s/i+HIpgCpVIcSnx/FJ/g+EB56Kz9ve2JibXK7XuomsPMzHRJ+f9wu
         uCVr/elsyvwsEl29aJQWCKDTZoOq9ofOs4w+Dv7eJV0jLoKvdIxP9lNqxbPSNzykTr
         dTEiz3CesCMNIBmJpcBRgVnCEBfYvHc3pgL4aj9NIcVwZkXQmrLq75jBP18+hBxVFw
         Uwzc6jhsMsPZlx1yUSxKCw8eyLOBnEDiYkBLZB9rBbohsnHdPIP4A6egoIkCBnhX4c
         IwYJuS7IaB/6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Joerg Albert <joerg.albert@iav.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 177/217] drm/etnaviv: consider completed fence seqno in hang check
Date:   Mon, 17 Jan 2022 21:19:00 -0500
Message-Id: <20220118021940.1942199-177-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit cdd156955f946beaa5f3a00d8ccf90e5a197becc ]

Some GPU heavy test programs manage to trigger the hangcheck quite often.
If there are no other GPU users in the system and the test program
exhibits a very regular structure in the commandstreams that are being
submitted, we can end up with two distinct submits managing to trigger
the hangcheck with the FE in a very similar address range. This leads
the hangcheck to believe that the GPU is stuck, while in reality the GPU
is already busy working on a different job. To avoid those spurious
GPU resets, also remember and consider the last completed fence seqno
in the hang check.

Reported-by: Joerg Albert <joerg.albert@iav.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h   | 1 +
 drivers/gpu/drm/etnaviv/etnaviv_sched.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
index 1c75c8ed5bcea..85eddd492774d 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -130,6 +130,7 @@ struct etnaviv_gpu {
 
 	/* hang detection */
 	u32 hangcheck_dma_addr;
+	u32 hangcheck_fence;
 
 	void __iomem *mmio;
 	int irq;
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_sched.c b/drivers/gpu/drm/etnaviv/etnaviv_sched.c
index 180bb633d5c53..58f593b278c15 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_sched.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_sched.c
@@ -107,8 +107,10 @@ static enum drm_gpu_sched_stat etnaviv_sched_timedout_job(struct drm_sched_job
 	 */
 	dma_addr = gpu_read(gpu, VIVS_FE_DMA_ADDRESS);
 	change = dma_addr - gpu->hangcheck_dma_addr;
-	if (change < 0 || change > 16) {
+	if (gpu->completed_fence != gpu->hangcheck_fence ||
+	    change < 0 || change > 16) {
 		gpu->hangcheck_dma_addr = dma_addr;
+		gpu->hangcheck_fence = gpu->completed_fence;
 		goto out_no_timeout;
 	}
 
-- 
2.34.1

