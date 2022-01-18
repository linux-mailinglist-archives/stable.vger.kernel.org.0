Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7AAE491AD5
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353005AbiARDAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351506AbiARCyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:54:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2877C02B844;
        Mon, 17 Jan 2022 18:43:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B195B81132;
        Tue, 18 Jan 2022 02:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB39BC36AF4;
        Tue, 18 Jan 2022 02:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473824;
        bh=vYqT50n7P1s8BSjh/eXllW0EJ7z12+co5rPuam7sJbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvHW+5OTXEVW4x4gv9mpinXXAx4svqjAOK80/X4OECqSk5qTKkiV6EoCoFOwhlUNL
         goCC9aVqHo18Nfe6wWsNigZ20pPqtWGKnNhyCRHupORwsMDafvDRx3PXttfGCUe2c5
         UluUYZwCpCydMOndNvVL1BFlntWazxqz6dNOyA4f+llNCnvWNCHMbfsznl8blpwGnB
         6CQWf2dBdj+j7mYPkRduf/ly5PuwRTCT2zgFPRdvebYWQ8mwacZuIyn2TM5fEBZVJ2
         r7T7vVAzomD/o0k/RfERqo4gVQgZXgzeH0RARf/jIE8/EnTu2ZczoYgFWVvXLvPuPY
         b8N7DwEB3ygeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        Joerg Albert <joerg.albert@iav.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        Sasha Levin <sashal@kernel.org>, airlied@linux.ie,
        daniel@ffwll.ch, etnaviv@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 088/116] drm/etnaviv: consider completed fence seqno in hang check
Date:   Mon, 17 Jan 2022 21:39:39 -0500
Message-Id: <20220118024007.1950576-88-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
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

