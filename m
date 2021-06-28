Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D17D93B6457
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbhF1PG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237237AbhF1PF1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:05:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42ED961CFE;
        Mon, 28 Jun 2021 14:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891408;
        bh=nQe34rF7Lrty/+cKhZjeckygj78u5V0t75kW6rxMuF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M/8I+N4+2dbXtndBpXo0Y9EvoqwN7pAt8s0a46yyG1+hDUF4E+7PwQo6kFaeM/WBP
         EBwAKnMLjJpYsvzLSZ4FxBGgqs+RG+hjmOLx/gDyHPCff3BeJhd36RR8ji5i/ToSBh
         39l7U6n7sy6dPPiyTw0wftzglotHxjTX+F25cHepuZkxfXor6Yc9dnOQYAFlWhGh88
         iDgQY6JFuvWBShBmmQHOK0M4xT05T/Ko008AtnY7nZkeO4Q/Ot/cVDJ0iMoATze6D5
         gxu67DsVboYRDNVT1UeMGXXKFNfCo9YlIsZKYiu23Yphfud7NrCKw5udDZhbqnVMJs
         b/HyRJFyZ2sLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bumyong Lee <bumyong.lee@samsung.com>,
        Jongho Park <jongho7.park@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 36/57] dmaengine: pl330: fix wrong usage of spinlock flags in dma_cyclc
Date:   Mon, 28 Jun 2021 10:42:35 -0400
Message-Id: <20210628144256.34524-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bumyong Lee <bumyong.lee@samsung.com>

commit 4ad5dd2d7876d79507a20f026507d1a93b8fff10 upstream.

flags varible which is the input parameter of pl330_prep_dma_cyclic()
should not be used by spinlock_irq[save/restore] function.

Signed-off-by: Jongho Park <jongho7.park@samsung.com>
Signed-off-by: Bumyong Lee <bumyong.lee@samsung.com>
Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Link: https://lore.kernel.org/r/20210507063647.111209-1-chanho61.park@samsung.com
Fixes: f6f2421c0a1c ("dmaengine: pl330: Merge dma_pl330_dmac and pl330_dmac structs")
Cc: stable@vger.kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/pl330.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 7f66ae1945b2..6ea993478ddd 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2531,13 +2531,15 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 	for (i = 0; i < len / period_len; i++) {
 		desc = pl330_get_desc(pch);
 		if (!desc) {
+			unsigned long iflags;
+
 			dev_err(pch->dmac->ddma.dev, "%s:%d Unable to fetch desc\n",
 				__func__, __LINE__);
 
 			if (!first)
 				return NULL;
 
-			spin_lock_irqsave(&pl330->pool_lock, flags);
+			spin_lock_irqsave(&pl330->pool_lock, iflags);
 
 			while (!list_empty(&first->node)) {
 				desc = list_entry(first->node.next,
@@ -2547,7 +2549,7 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 
 			list_move_tail(&first->node, &pl330->desc_pool);
 
-			spin_unlock_irqrestore(&pl330->pool_lock, flags);
+			spin_unlock_irqrestore(&pl330->pool_lock, iflags);
 
 			return NULL;
 		}
-- 
2.30.2

