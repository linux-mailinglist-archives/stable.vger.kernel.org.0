Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E195EA5FA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239540AbiIZM0m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbiIZMZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:25:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85DCAA4F1;
        Mon, 26 Sep 2022 04:06:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBB81B80918;
        Mon, 26 Sep 2022 10:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9170C433D6;
        Mon, 26 Sep 2022 10:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188269;
        bh=J2FzTDlTOhaUoqPy+dQ1EKMEgMjgxwgJxc64jwZD0wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOv5CS+3i8Xryml+i37z3vlh4SxU2bGmD43S5FGymKEm+2dRC09QVEv2735cM1161
         bNvQCCT9oSIGRNV62CC5Hxe0QRCXk9p3GSy3tyWBHaFuH895JIh8lJ85oy6/lKnrVu
         6ac1gQ3WRpoz5yYPTjFMOK0ue97aNeYB6vLGgxtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/141] net: ipa: DMA addresses are nicely aligned
Date:   Mon, 26 Sep 2022 12:12:02 +0200
Message-Id: <20220926100757.910176097@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 19aaf72c0c7a26ab7ffc655a6d84da6a379f899b ]

A recent patch avoided doing 64-bit modulo operations by checking
the alignment of some DMA allocations using only the lower 32 bits
of the address.

David Laight pointed out (after the fix was committed) that DMA
allocations might already satisfy the alignment requirements.  And
he was right.

Remove the alignment checks that occur after DMA allocation requests,
and update comments to explain why the constraint is satisfied.  The
only place IPA_TABLE_ALIGN was used was to check the alignment; it is
therefore no longer needed, so get rid of it.

Add comments where GSI_RING_ELEMENT_SIZE and the tre_count and
event_count channel data fields are defined to make explicit they
are required to be powers of 2.

Revise a comment in gsi_trans_pool_init_dma(), taking into account
that dma_alloc_coherent() guarantees its result is aligned to a page
size (or order thereof).

Don't bother printing an error if a DMA allocation fails.

Suggested-by: David Laight <David.Laight@ACULAB.COM>
Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cf412ec33325 ("net: ipa: properly limit modem routing table use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c         | 13 ++++---------
 drivers/net/ipa/gsi_private.h |  2 +-
 drivers/net/ipa/gsi_trans.c   |  9 ++++-----
 drivers/net/ipa/ipa_data.h    |  4 ++--
 drivers/net/ipa/ipa_table.c   | 24 ++++++------------------
 5 files changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index e46d3622f9eb..64b12e462765 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1256,18 +1256,13 @@ static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
 	dma_addr_t addr;
 
 	/* Hardware requires a 2^n ring size, with alignment equal to size.
-	 * The size is a power of 2, so we can check alignment using just
-	 * the bottom 32 bits for a DMA address of any size.
+	 * The DMA address returned by dma_alloc_coherent() is guaranteed to
+	 * be a power-of-2 number of pages, which satisfies the requirement.
 	 */
 	ring->virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
-	if (ring->virt && lower_32_bits(addr) % size) {
-		dma_free_coherent(dev, size, ring->virt, addr);
-		dev_err(dev, "unable to alloc 0x%x-aligned ring buffer\n",
-			size);
-		return -EINVAL;	/* Not a good error value, but distinct */
-	} else if (!ring->virt) {
+	if (!ring->virt)
 		return -ENOMEM;
-	}
+
 	ring->addr = addr;
 	ring->count = count;
 
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index 1785c9d3344d..d58dce46e061 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -14,7 +14,7 @@ struct gsi_trans;
 struct gsi_ring;
 struct gsi_channel;
 
-#define GSI_RING_ELEMENT_SIZE	16	/* bytes */
+#define GSI_RING_ELEMENT_SIZE	16	/* bytes; must be a power of 2 */
 
 /* Return the entry that follows one provided in a transaction pool */
 void *gsi_trans_pool_next(struct gsi_trans_pool *pool, void *element);
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 6c3ed5b17b80..70c2b585f98d 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -153,11 +153,10 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	size = __roundup_pow_of_two(size);
 	total_size = (count + max_alloc - 1) * size;
 
-	/* The allocator will give us a power-of-2 number of pages.  But we
-	 * can't guarantee that, so request it.  That way we won't waste any
-	 * memory that would be available beyond the required space.
-	 *
-	 * Note that gsi_trans_pool_exit_dma() assumes the total allocated
+	/* The allocator will give us a power-of-2 number of pages
+	 * sufficient to satisfy our request.  Round up our requested
+	 * size to avoid any unused space in the allocation.  This way
+	 * gsi_trans_pool_exit_dma() can assume the total allocated
 	 * size is exactly (count * size).
 	 */
 	total_size = get_order(total_size) << PAGE_SHIFT;
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 7fc1058a5ca9..ba05e26c3c60 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -72,8 +72,8 @@
  * that can be included in a single transaction.
  */
 struct gsi_channel_data {
-	u16 tre_count;
-	u16 event_count;
+	u16 tre_count;			/* must be a power of 2 */
+	u16 event_count;		/* must be a power of 2 */
 	u8 tlv_count;
 };
 
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 4f15391aad5f..087bcae29cc7 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -96,9 +96,6 @@
  *                 ----------------------
  */
 
-/* IPA hardware constrains filter and route tables alignment */
-#define IPA_TABLE_ALIGN			128	/* Minimum table alignment */
-
 /* Assignment of route table entries to the modem and AP */
 #define IPA_ROUTE_MODEM_MIN		0
 #define IPA_ROUTE_MODEM_COUNT		8
@@ -656,26 +653,17 @@ int ipa_table_init(struct ipa *ipa)
 
 	ipa_table_validate_build();
 
+	/* The IPA hardware requires route and filter table rules to be
+	 * aligned on a 128-byte boundary.  We put the "zero rule" at the
+	 * base of the table area allocated here.  The DMA address returned
+	 * by dma_alloc_coherent() is guaranteed to be a power-of-2 number
+	 * of pages, which satisfies the rule alignment requirement.
+	 */
 	size = IPA_ZERO_RULE_SIZE + (1 + count) * IPA_TABLE_ENTRY_SIZE;
 	virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
 	if (!virt)
 		return -ENOMEM;
 
-	/* We put the "zero rule" at the base of our table area.  The IPA
-	 * hardware requires route and filter table rules to be aligned
-	 * on a 128-byte boundary.  As long as the alignment constraint
-	 * is a power of 2, we can check alignment using just the bottom
-	 * 32 bits for a DMA address of any size.
-	 */
-	BUILD_BUG_ON(!is_power_of_2(IPA_TABLE_ALIGN));
-	if (lower_32_bits(addr) % IPA_TABLE_ALIGN) {
-		dev_err(dev, "table address %pad not %u-byte aligned\n",
-			&addr, IPA_TABLE_ALIGN);
-		dma_free_coherent(dev, size, virt, addr);
-
-		return -ERANGE;
-	}
-
 	ipa->table_virt = virt;
 	ipa->table_addr = addr;
 
-- 
2.35.1



