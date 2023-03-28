Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 428C76CC4ED
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjC1PKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjC1PKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:10:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9B5EB51
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:08:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7DFA61861
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D59F8C433EF;
        Tue, 28 Mar 2023 15:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016134;
        bh=kV3THHze1rCwfklsM6UPvTmJfxhv3PNvg8Dbvy6leoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2XDj5NeFJ35aeooP7ZnD7pbD+ky01ivNaWMwLKBUXBi7l/LGYBQIDZzpecF40Nto
         cowdvxa6ObtKALbtX9ELvL1cxai+nQq+p6MhzqTqj1VojPsIp1BT558jC+YoZ7A2qn
         JqZExM46qWA5QwyVUwQTUoTYn1uLokf2lGL0Ubgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sanju Mehta <Sanju.Mehta@amd.com>,
        Anson Tsao <anson.tsao@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 078/146] thunderbolt: Disable interrupt auto clear for rings
Date:   Tue, 28 Mar 2023 16:42:47 +0200
Message-Id: <20230328142605.954955016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 468c49f44759720a312e52d44a71c3949ed63d7c upstream.

When interrupt auto clear is programmed, any read to the interrupt
status register will clear all interrupts.  If two interrupts have
come in before one can be serviced then this will cause lost interrupts.

On AMD USB4 routers this has manifested in odd problems particularly
with long strings of control tranfers such as reading the DROM via bit
banging.

Instead of clearing interrupts automatically, clear the bit corresponding
to the given ring's interrupt in the ISR.

Fixes: 7a1808f82a37 ("thunderbolt: Handle ring interrupt by reading interrupt status register")
Cc: Sanju Mehta <Sanju.Mehta@amd.com>
Cc: stable@vger.kernel.org
Tested-by: Anson Tsao <anson.tsao@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c      |   40 +++++++++++++++++++++++++---------------
 drivers/thunderbolt/nhi_regs.h |    6 ++++--
 2 files changed, 29 insertions(+), 17 deletions(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -68,24 +68,31 @@ static void ring_interrupt_active(struct
 		u32 step, shift, ivr, misc;
 		void __iomem *ivr_base;
 		int index;
+		int bit;
 
 		if (ring->is_tx)
 			index = ring->hop;
 		else
 			index = ring->hop + ring->nhi->hop_count;
 
-		if (ring->nhi->quirks & QUIRK_AUTO_CLEAR_INT) {
-			/*
-			 * Ask the hardware to clear interrupt status
-			 * bits automatically since we already know
-			 * which interrupt was triggered.
-			 */
-			misc = ioread32(ring->nhi->iobase + REG_DMA_MISC);
-			if (!(misc & REG_DMA_MISC_INT_AUTO_CLEAR)) {
-				misc |= REG_DMA_MISC_INT_AUTO_CLEAR;
-				iowrite32(misc, ring->nhi->iobase + REG_DMA_MISC);
-			}
-		}
+		/*
+		 * Intel routers support a bit that isn't part of
+		 * the USB4 spec to ask the hardware to clear
+		 * interrupt status bits automatically since
+		 * we already know which interrupt was triggered.
+		 *
+		 * Other routers explicitly disable auto-clear
+		 * to prevent conditions that may occur where two
+		 * MSIX interrupts are simultaneously active and
+		 * reading the register clears both of them.
+		 */
+		misc = ioread32(ring->nhi->iobase + REG_DMA_MISC);
+		if (ring->nhi->quirks & QUIRK_AUTO_CLEAR_INT)
+			bit = REG_DMA_MISC_INT_AUTO_CLEAR;
+		else
+			bit = REG_DMA_MISC_DISABLE_AUTO_CLEAR;
+		if (!(misc & bit))
+			iowrite32(misc | bit, ring->nhi->iobase + REG_DMA_MISC);
 
 		ivr_base = ring->nhi->iobase + REG_INT_VEC_ALLOC_BASE;
 		step = index / REG_INT_VEC_ALLOC_REGS * REG_INT_VEC_ALLOC_BITS;
@@ -390,14 +397,17 @@ EXPORT_SYMBOL_GPL(tb_ring_poll_complete)
 
 static void ring_clear_msix(const struct tb_ring *ring)
 {
+	int bit;
+
 	if (ring->nhi->quirks & QUIRK_AUTO_CLEAR_INT)
 		return;
 
+	bit = ring_interrupt_index(ring) & 31;
 	if (ring->is_tx)
-		ioread32(ring->nhi->iobase + REG_RING_NOTIFY_BASE);
+		iowrite32(BIT(bit), ring->nhi->iobase + REG_RING_INT_CLEAR);
 	else
-		ioread32(ring->nhi->iobase + REG_RING_NOTIFY_BASE +
-			 4 * (ring->nhi->hop_count / 32));
+		iowrite32(BIT(bit), ring->nhi->iobase + REG_RING_INT_CLEAR +
+			  4 * (ring->nhi->hop_count / 32));
 }
 
 static irqreturn_t ring_msix(int irq, void *data)
--- a/drivers/thunderbolt/nhi_regs.h
+++ b/drivers/thunderbolt/nhi_regs.h
@@ -77,12 +77,13 @@ struct ring_desc {
 
 /*
  * three bitfields: tx, rx, rx overflow
- * Every bitfield contains one bit for every hop (REG_HOP_COUNT). Registers are
- * cleared on read. New interrupts are fired only after ALL registers have been
+ * Every bitfield contains one bit for every hop (REG_HOP_COUNT).
+ * New interrupts are fired only after ALL registers have been
  * read (even those containing only disabled rings).
  */
 #define REG_RING_NOTIFY_BASE	0x37800
 #define RING_NOTIFY_REG_COUNT(nhi) ((31 + 3 * nhi->hop_count) / 32)
+#define REG_RING_INT_CLEAR	0x37808
 
 /*
  * two bitfields: rx, tx
@@ -105,6 +106,7 @@ struct ring_desc {
 
 #define REG_DMA_MISC			0x39864
 #define REG_DMA_MISC_INT_AUTO_CLEAR     BIT(2)
+#define REG_DMA_MISC_DISABLE_AUTO_CLEAR	BIT(17)
 
 #define REG_INMAIL_DATA			0x39900
 


