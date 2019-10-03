Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B9CCABAE
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbfJCP56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731058AbfJCP54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:57:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD719207FF;
        Thu,  3 Oct 2019 15:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118275;
        bh=LBsfjmAgo2l/l1JdRmZqSp8PzoxffRVmyKd6cl3Xm1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UwLZ0Bhqhr37xBw+Km5VTkNgbO3uWrU30jyT2M+mHBFqPYA4ngb4xhWC2Clg0yf5N
         RzU4nQQEiJhm2OB0I9H99fqHx7ooYE8uHdt4093fyO2K06vpKiMn3FWqbOyMMSDDOc
         rl77X7ZMnFE8pK79lwAU/ttUtm9nPZZYDTD3gkhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 53/99] dmaengine: iop-adma: use correct printk format strings
Date:   Thu,  3 Oct 2019 17:53:16 +0200
Message-Id: <20191003154322.154670034@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 00c9755524fbaa28117be774d7c92fddb5ca02f3 ]

When compile-testing on other architectures, we get lots of warnings
about incorrect format strings, like:

   drivers/dma/iop-adma.c: In function 'iop_adma_alloc_slots':
   drivers/dma/iop-adma.c:307:6: warning: format '%x' expects argument of type 'unsigned int', but argument 6 has type 'dma_addr_t {aka long long unsigned int}' [-Wformat=]

   drivers/dma/iop-adma.c: In function 'iop_adma_prep_dma_memcpy':
>> drivers/dma/iop-adma.c:518:40: warning: format '%u' expects argument of type 'unsigned int', but argument 5 has type 'size_t {aka long unsigned int}' [-Wformat=]

Use %zu for printing size_t as required, and cast the dma_addr_t
arguments to 'u64' for printing with %llx. Ideally this should use
the %pad format string, but that requires an lvalue argument that
doesn't work here.

Link: https://lore.kernel.org/r/20190809163334.489360-3-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/iop-adma.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/iop-adma.c b/drivers/dma/iop-adma.c
index e4f43125e0fbb..a390415c97a86 100644
--- a/drivers/dma/iop-adma.c
+++ b/drivers/dma/iop-adma.c
@@ -126,9 +126,9 @@ static void __iop_adma_slot_cleanup(struct iop_adma_chan *iop_chan)
 	list_for_each_entry_safe(iter, _iter, &iop_chan->chain,
 					chain_node) {
 		pr_debug("\tcookie: %d slot: %d busy: %d "
-			"this_desc: %#x next_desc: %#x ack: %d\n",
+			"this_desc: %#x next_desc: %#llx ack: %d\n",
 			iter->async_tx.cookie, iter->idx, busy,
-			iter->async_tx.phys, iop_desc_get_next_desc(iter),
+			iter->async_tx.phys, (u64)iop_desc_get_next_desc(iter),
 			async_tx_test_ack(&iter->async_tx));
 		prefetch(_iter);
 		prefetch(&_iter->async_tx);
@@ -316,9 +316,9 @@ iop_adma_alloc_slots(struct iop_adma_chan *iop_chan, int num_slots,
 				int i;
 				dev_dbg(iop_chan->device->common.dev,
 					"allocated slot: %d "
-					"(desc %p phys: %#x) slots_per_op %d\n",
+					"(desc %p phys: %#llx) slots_per_op %d\n",
 					iter->idx, iter->hw_desc,
-					iter->async_tx.phys, slots_per_op);
+					(u64)iter->async_tx.phys, slots_per_op);
 
 				/* pre-ack all but the last descriptor */
 				if (num_slots != slots_per_op)
@@ -526,7 +526,7 @@ iop_adma_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dma_dest,
 		return NULL;
 	BUG_ON(len > IOP_ADMA_MAX_BYTE_COUNT);
 
-	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
+	dev_dbg(iop_chan->device->common.dev, "%s len: %zu\n",
 		__func__, len);
 
 	spin_lock_bh(&iop_chan->lock);
@@ -559,7 +559,7 @@ iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 	BUG_ON(len > IOP_ADMA_XOR_MAX_BYTE_COUNT);
 
 	dev_dbg(iop_chan->device->common.dev,
-		"%s src_cnt: %d len: %u flags: %lx\n",
+		"%s src_cnt: %d len: %zu flags: %lx\n",
 		__func__, src_cnt, len, flags);
 
 	spin_lock_bh(&iop_chan->lock);
@@ -592,7 +592,7 @@ iop_adma_prep_dma_xor_val(struct dma_chan *chan, dma_addr_t *dma_src,
 	if (unlikely(!len))
 		return NULL;
 
-	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %u\n",
+	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %zu\n",
 		__func__, src_cnt, len);
 
 	spin_lock_bh(&iop_chan->lock);
@@ -630,7 +630,7 @@ iop_adma_prep_dma_pq(struct dma_chan *chan, dma_addr_t *dst, dma_addr_t *src,
 	BUG_ON(len > IOP_ADMA_XOR_MAX_BYTE_COUNT);
 
 	dev_dbg(iop_chan->device->common.dev,
-		"%s src_cnt: %d len: %u flags: %lx\n",
+		"%s src_cnt: %d len: %zu flags: %lx\n",
 		__func__, src_cnt, len, flags);
 
 	if (dmaf_p_disabled_continue(flags))
@@ -693,7 +693,7 @@ iop_adma_prep_dma_pq_val(struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 		return NULL;
 	BUG_ON(len > IOP_ADMA_XOR_MAX_BYTE_COUNT);
 
-	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %u\n",
+	dev_dbg(iop_chan->device->common.dev, "%s src_cnt: %d len: %zu\n",
 		__func__, src_cnt, len);
 
 	spin_lock_bh(&iop_chan->lock);
-- 
2.20.1



