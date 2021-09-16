Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B53540E657
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242210AbhIPRVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346326AbhIPRSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 856F461BA1;
        Thu, 16 Sep 2021 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810458;
        bh=YKSI2PNHhxTaGksaY2QMsaRY63mNGMnQknFbukAf0cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XchP4pd+agi1G5oq5ZSKJx+2HEyu71ESkZY67+eOOQOApwDi/TjfPs667RhMoSg8n
         KfrreVrEcJYT2mAdpgCKaD79QYTrpuLLE4oA+Z8Cc/GVfhWBvNW9x12Sg8OYPfJIcc
         tHX1DMm4Kh8FpUw6pgEmbYwHTDr6TALMMcsJZLJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yongqiang Niu <yongqiang.niu@mediatek.com>,
        Nicolas Boichat <drinkcat@chromium.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 148/432] soc: mediatek: cmdq: add address shift in jump
Date:   Thu, 16 Sep 2021 17:58:17 +0200
Message-Id: <20210916155815.770761422@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yongqiang Niu <yongqiang.niu@mediatek.com>

[ Upstream commit 8b60ed2b1674b78ebc433a11efa7d48821229037 ]

Add address shift when compose jump instruction
to compatible with 35bit format.

Fixes: 0858fde496f8 ("mailbox: cmdq: variablize address shift in platform")
Signed-off-by: Yongqiang Niu <yongqiang.niu@mediatek.com>
Reviewed-by: Nicolas Boichat <drinkcat@chromium.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mtk-cmdq-mailbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mtk-cmdq-mailbox.c b/drivers/mailbox/mtk-cmdq-mailbox.c
index 67a42b514429..4f907e8f3894 100644
--- a/drivers/mailbox/mtk-cmdq-mailbox.c
+++ b/drivers/mailbox/mtk-cmdq-mailbox.c
@@ -168,7 +168,8 @@ static void cmdq_task_insert_into_thread(struct cmdq_task *task)
 	dma_sync_single_for_cpu(dev, prev_task->pa_base,
 				prev_task->pkt->cmd_buf_size, DMA_TO_DEVICE);
 	prev_task_base[CMDQ_NUM_CMD(prev_task->pkt) - 1] =
-		(u64)CMDQ_JUMP_BY_PA << 32 | task->pa_base;
+		(u64)CMDQ_JUMP_BY_PA << 32 |
+		(task->pa_base >> task->cmdq->shift_pa);
 	dma_sync_single_for_device(dev, prev_task->pa_base,
 				   prev_task->pkt->cmd_buf_size, DMA_TO_DEVICE);
 
-- 
2.30.2



