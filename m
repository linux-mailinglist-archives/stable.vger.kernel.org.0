Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FA6499685
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445703AbiAXVEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442681AbiAXUzF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:55:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C424FC047CEA;
        Mon, 24 Jan 2022 12:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64D5D60FF4;
        Mon, 24 Jan 2022 20:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40324C340E5;
        Mon, 24 Jan 2022 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054418;
        bh=vYqT50n7P1s8BSjh/eXllW0EJ7z12+co5rPuam7sJbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TYyh5XBlFvxKoAoO0sml/3pU7PIEzYfxgW6XIpXGKrtrce2ayECh4Hq1FURd453Uf
         0yRqNi8TCAUxHemrjOoDCA0jxNNWR9LTb64ityVdj6kN2MbRytu79yxJRqZUBpOhrD
         bIFICgezYC0sSq2EeomiTFyUBhapWjBPvanr+jzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Albert <joerg.albert@iav.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 383/563] drm/etnaviv: consider completed fence seqno in hang check
Date:   Mon, 24 Jan 2022 19:42:28 +0100
Message-Id: <20220124184037.671331423@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index cd46c882269cc..026b6c0731198 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_sched.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_sched.c
@@ -106,8 +106,10 @@ static void etnaviv_sched_timedout_job(struct drm_sched_job *sched_job)
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



