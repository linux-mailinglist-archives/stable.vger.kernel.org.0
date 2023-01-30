Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC16681020
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbjA3OAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236835AbjA3OAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:00:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE811116F
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:00:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02539B81154
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48410C433EF;
        Mon, 30 Jan 2023 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087196;
        bh=Cy+rMliy731X8nCrmtYnLpIciONNviBvc9cYiKPKdqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxdhmPivv+cm5xMpzaBmBsTQe262mre1RgtnIk76d5D9KTKnnhmo5pCnrRVMjEcM6
         dyZ+9gDGkggQq4ZtSG0+WVa0Wpy/S5+StBObVh1zrZV402mAij/gygv7BnmP6kTXWn
         bD+1l6BtxcVDlB3E0s6IdMzWuEmLGAM+ZjFQUKFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Pilmore <epilmore@gigaio.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/313] ptdma: pt_core_execute_cmd() should use spinlock
Date:   Mon, 30 Jan 2023 14:49:23 +0100
Message-Id: <20230130134342.618841840@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Pilmore <epilmore@gigaio.com>

[ Upstream commit 95e5fda3b5f9ed8239b145da3fa01e641cf5d53c ]

The interrupt handler (pt_core_irq_handler()) of the ptdma
driver can be called from interrupt context. The code flow
in this function can lead down to pt_core_execute_cmd() which
will attempt to grab a mutex, which is not appropriate in
interrupt context and ultimately leads to a kernel panic.
The fix here changes this mutex to a spinlock, which has
been verified to resolve the issue.

Fixes: fa5d823b16a9 ("dmaengine: ptdma: Initial driver for the AMD PTDMA")
Signed-off-by: Eric Pilmore <epilmore@gigaio.com>
Link: https://lore.kernel.org/r/20230119033907.35071-1-epilmore@gigaio.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ptdma/ptdma-dev.c | 7 ++++---
 drivers/dma/ptdma/ptdma.h     | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/ptdma/ptdma-dev.c b/drivers/dma/ptdma/ptdma-dev.c
index 377da23012ac..a2bf13ff18b6 100644
--- a/drivers/dma/ptdma/ptdma-dev.c
+++ b/drivers/dma/ptdma/ptdma-dev.c
@@ -71,12 +71,13 @@ static int pt_core_execute_cmd(struct ptdma_desc *desc, struct pt_cmd_queue *cmd
 	bool soc = FIELD_GET(DWORD0_SOC, desc->dw0);
 	u8 *q_desc = (u8 *)&cmd_q->qbase[cmd_q->qidx];
 	u32 tail;
+	unsigned long flags;
 
 	if (soc) {
 		desc->dw0 |= FIELD_PREP(DWORD0_IOC, desc->dw0);
 		desc->dw0 &= ~DWORD0_SOC;
 	}
-	mutex_lock(&cmd_q->q_mutex);
+	spin_lock_irqsave(&cmd_q->q_lock, flags);
 
 	/* Copy 32-byte command descriptor to hw queue. */
 	memcpy(q_desc, desc, 32);
@@ -91,7 +92,7 @@ static int pt_core_execute_cmd(struct ptdma_desc *desc, struct pt_cmd_queue *cmd
 
 	/* Turn the queue back on using our cached control register */
 	pt_start_queue(cmd_q);
-	mutex_unlock(&cmd_q->q_mutex);
+	spin_unlock_irqrestore(&cmd_q->q_lock, flags);
 
 	return 0;
 }
@@ -199,7 +200,7 @@ int pt_core_init(struct pt_device *pt)
 
 	cmd_q->pt = pt;
 	cmd_q->dma_pool = dma_pool;
-	mutex_init(&cmd_q->q_mutex);
+	spin_lock_init(&cmd_q->q_lock);
 
 	/* Page alignment satisfies our needs for N <= 128 */
 	cmd_q->qsize = Q_SIZE(Q_DESC_SIZE);
diff --git a/drivers/dma/ptdma/ptdma.h b/drivers/dma/ptdma/ptdma.h
index d093c43b7d13..21b4bf895200 100644
--- a/drivers/dma/ptdma/ptdma.h
+++ b/drivers/dma/ptdma/ptdma.h
@@ -196,7 +196,7 @@ struct pt_cmd_queue {
 	struct ptdma_desc *qbase;
 
 	/* Aligned queue start address (per requirement) */
-	struct mutex q_mutex ____cacheline_aligned;
+	spinlock_t q_lock ____cacheline_aligned;
 	unsigned int qidx;
 
 	unsigned int qsize;
-- 
2.39.0



