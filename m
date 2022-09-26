Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1089C5EA284
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiIZLJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237431AbiIZLIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:08:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9200DF5F;
        Mon, 26 Sep 2022 03:34:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3739960AF5;
        Mon, 26 Sep 2022 10:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C5FC433D6;
        Mon, 26 Sep 2022 10:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188367;
        bh=9z6oqa5xkv1hJphIGbEyX/Kj8XIteefP56ek+6gh3SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBHrHF9TEGU9TujG1bCjNzoB+0/Ppp5vFUCBXU8xWDqQ3qJ1Uees+szKDoXwV4/tk
         6Snc5jEWLO0rztpPJtVKr0N4pDpm/zoJrifrZxX+aW3tE9QncxkC1DPi06SUGEcai5
         anwUhr4VZ3eLQ8q+y7QHwiUYaONX7oDUQj2Tk7bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Alex Elder <elder@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 095/141] net: ipa: avoid 64-bit modulus
Date:   Mon, 26 Sep 2022 12:12:01 +0200
Message-Id: <20220926100757.872073671@linuxfoundation.org>
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

[ Upstream commit 437c78f976f5b39fc4b2a1c65903a229f55912dd ]

It is possible for a 32 bit x86 build to use a 64 bit DMA address.

There are two remaining spots where the IPA driver does a modulo
operation to check alignment of a DMA address, and under certain
conditions this can lead to a build error on i386 (at least).

The alignment checks we're doing are for power-of-2 values, and this
means the lower 32 bits of the DMA address can be used.  This ensures
both operands to the modulo operator are 32 bits wide.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Alex Elder <elder@linaro.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cf412ec33325 ("net: ipa: properly limit modem routing table use")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/gsi.c       | 11 +++++++----
 drivers/net/ipa/ipa_table.c |  9 ++++++---
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index fe91b72eca36..e46d3622f9eb 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1251,15 +1251,18 @@ static void gsi_evt_ring_rx_update(struct gsi_evt_ring *evt_ring, u32 index)
 /* Initialize a ring, including allocating DMA memory for its entries */
 static int gsi_ring_alloc(struct gsi *gsi, struct gsi_ring *ring, u32 count)
 {
-	size_t size = count * GSI_RING_ELEMENT_SIZE;
+	u32 size = count * GSI_RING_ELEMENT_SIZE;
 	struct device *dev = gsi->dev;
 	dma_addr_t addr;
 
-	/* Hardware requires a 2^n ring size, with alignment equal to size */
+	/* Hardware requires a 2^n ring size, with alignment equal to size.
+	 * The size is a power of 2, so we can check alignment using just
+	 * the bottom 32 bits for a DMA address of any size.
+	 */
 	ring->virt = dma_alloc_coherent(dev, size, &addr, GFP_KERNEL);
-	if (ring->virt && addr % size) {
+	if (ring->virt && lower_32_bits(addr) % size) {
 		dma_free_coherent(dev, size, ring->virt, addr);
-		dev_err(dev, "unable to alloc 0x%zx-aligned ring buffer\n",
+		dev_err(dev, "unable to alloc 0x%x-aligned ring buffer\n",
 			size);
 		return -EINVAL;	/* Not a good error value, but distinct */
 	} else if (!ring->virt) {
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 45e1d68b4694..4f15391aad5f 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -662,10 +662,13 @@ int ipa_table_init(struct ipa *ipa)
 		return -ENOMEM;
 
 	/* We put the "zero rule" at the base of our table area.  The IPA
-	 * hardware requires rules to be aligned on a 128-byte boundary.
-	 * Make sure the allocation satisfies this constraint.
+	 * hardware requires route and filter table rules to be aligned
+	 * on a 128-byte boundary.  As long as the alignment constraint
+	 * is a power of 2, we can check alignment using just the bottom
+	 * 32 bits for a DMA address of any size.
 	 */
-	if (addr % IPA_TABLE_ALIGN) {
+	BUILD_BUG_ON(!is_power_of_2(IPA_TABLE_ALIGN));
+	if (lower_32_bits(addr) % IPA_TABLE_ALIGN) {
 		dev_err(dev, "table address %pad not %u-byte aligned\n",
 			&addr, IPA_TABLE_ALIGN);
 		dma_free_coherent(dev, size, virt, addr);
-- 
2.35.1



