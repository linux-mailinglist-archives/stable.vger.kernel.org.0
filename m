Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC493B6296
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbhF1Osn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235661AbhF1Op3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA8F361C8F;
        Mon, 28 Jun 2021 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890847;
        bh=KcYifVzG9X7A7bcMwDAzKpW1uDv3YCM5opz3g4aokfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=co96rN1p8tMYZAKQLEGrInmlwnw6NtlOlMc2sa0HN78D2bZJGoNL4sUc5b0Bf+I6s
         oDOS2bgL2I9aEKunLzMzpZ1aG1YJEaLtNVhnd32iAs4J2RmAAXMpv7Fdd3bCicn2WT
         deJx53iO+czIy3EBUKjiKoHVg/dSsrnuhHFnRYLoOmg3xky5TsdMxxucUlB1dPyNBu
         spATOMl75Uz1jWAAHd/kKx7gux9G2AWYcQgA44/KeLoPVYiF8D2LCR3mRIbGUhg/qc
         LzkiNT0CtnWUhJdNNRZMVho3H5Fe+PD7dusgSqbzlCB1nsex3tDe1ZE6AFrp/ykH51
         CWuXA5W1meIag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bumyong Lee <bumyong.lee@samsung.com>,
        Jongho Park <jongho7.park@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 069/109] dmaengine: pl330: fix wrong usage of spinlock flags in dma_cyclc
Date:   Mon, 28 Jun 2021 10:32:25 -0400
Message-Id: <20210628143305.32978-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index 15b30d2d8f7e..816630505294 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2671,13 +2671,15 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
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
@@ -2687,7 +2689,7 @@ static struct dma_async_tx_descriptor *pl330_prep_dma_cyclic(
 
 			list_move_tail(&first->node, &pl330->desc_pool);
 
-			spin_unlock_irqrestore(&pl330->pool_lock, flags);
+			spin_unlock_irqrestore(&pl330->pool_lock, iflags);
 
 			return NULL;
 		}
-- 
2.30.2

