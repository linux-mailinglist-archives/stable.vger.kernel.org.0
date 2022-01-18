Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3199B4917F8
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348018AbiARCnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:43:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54188 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345355AbiARCis (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:38:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8574B612C9;
        Tue, 18 Jan 2022 02:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE4FC36AEB;
        Tue, 18 Jan 2022 02:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473527;
        bh=5qnT/ZKpsAPdNJ9R7DEiWjtGbRKYGDcgnO84ikNbvSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYQLzaqgKvZsX0JKjLIEP0U1Wqcyd4gbLSvmiCFpD04DrFFfbfNj2eQVDPFFF/meY
         tCW1ggnm5vvDY4pqEHCS7wZ0AWHsKCxhJYjBi9t+bRCZLnBhC8SudD4VGC71o+V9V/
         tTMuubddT3buUT71mN6Ul8/wZHhzzS7n1wTx6NnulNQuoylDMOF6Ll7JZzfzpJAtkl
         zZCqDXf+Vz1I6aNipjwVKqq0/9CNBzWw15XUiculQQfAaJMBUMF2Knqqa6Z2Q76EO9
         eW6fxFUH+ogWPa1EZ6KQzPcpbOBNZxnhpek1jaXElgyXA6s+jHajb0C1oE0kBWA7is
         0NoatAsk5MpLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Joerg Albert <joerg.albert@iav.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 150/188] drm/etnaviv: consider completed fence seqno in hang check
Date:   Mon, 17 Jan 2022 21:31:14 -0500
Message-Id: <20220118023152.1948105-150-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index feb6da1b6cebc..bbf391f48f949 100644
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

