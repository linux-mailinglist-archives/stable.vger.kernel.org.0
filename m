Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4EA6CC5EB
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 17:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbjC1PTs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 11:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbjC1PTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 11:19:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A908E113C7
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 08:17:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24A9E6184B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 15:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F1FC433D2;
        Tue, 28 Mar 2023 15:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680016142;
        bh=euySgtFla8nW1hKEmnuwoq4Dc8abVxKVz5lV6/AqKiM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZDcXkTLwHKLrJfSRK8T8FdQDuf7ORRJHAyFVXS45ma9ZbN9sOp+KitU/LMF9fphll
         Giaw8YJA7TmlgZb2xoyrvU4KX2ARn7SgUl824rNda3vVakwbJPKOER7SsUnsktlgzt
         lDBrDpVjPi/L/M2GplZdeLs7woKTzakUdxXeqQlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tom Rix <trix@redhat.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 081/146] thunderbolt: Rename shadowed variables bit to interrupt_bit and auto_clear_bit
Date:   Tue, 28 Mar 2023 16:42:50 +0200
Message-Id: <20230328142606.087832792@linuxfoundation.org>
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

From: Tom Rix <trix@redhat.com>

commit 58cdfe6f58b35f17f56386f5fcf937168a423ad1 upstream.

cppcheck reports
drivers/thunderbolt/nhi.c:74:7: style: Local variable 'bit' shadows outer variable [shadowVariable]
  int bit;
      ^
drivers/thunderbolt/nhi.c:66:6: note: Shadowed declaration
 int bit = ring_interrupt_index(ring) & 31;
     ^
drivers/thunderbolt/nhi.c:74:7: note: Shadow variable
  int bit;
      ^
For readablity rename the outer to interrupt_bit and the innner
to auto_clear_bit.

Fixes: 468c49f44759 ("thunderbolt: Disable interrupt auto clear for ring")
Cc: stable@vger.kernel.org
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/nhi.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -60,15 +60,15 @@ static void ring_interrupt_active(struct
 {
 	int reg = REG_RING_INTERRUPT_BASE +
 		  ring_interrupt_index(ring) / 32 * 4;
-	int bit = ring_interrupt_index(ring) & 31;
-	int mask = 1 << bit;
+	int interrupt_bit = ring_interrupt_index(ring) & 31;
+	int mask = 1 << interrupt_bit;
 	u32 old, new;
 
 	if (ring->irq > 0) {
 		u32 step, shift, ivr, misc;
 		void __iomem *ivr_base;
+		int auto_clear_bit;
 		int index;
-		int bit;
 
 		if (ring->is_tx)
 			index = ring->hop;
@@ -88,11 +88,12 @@ static void ring_interrupt_active(struct
 		 */
 		misc = ioread32(ring->nhi->iobase + REG_DMA_MISC);
 		if (ring->nhi->quirks & QUIRK_AUTO_CLEAR_INT)
-			bit = REG_DMA_MISC_INT_AUTO_CLEAR;
+			auto_clear_bit = REG_DMA_MISC_INT_AUTO_CLEAR;
 		else
-			bit = REG_DMA_MISC_DISABLE_AUTO_CLEAR;
-		if (!(misc & bit))
-			iowrite32(misc | bit, ring->nhi->iobase + REG_DMA_MISC);
+			auto_clear_bit = REG_DMA_MISC_DISABLE_AUTO_CLEAR;
+		if (!(misc & auto_clear_bit))
+			iowrite32(misc | auto_clear_bit,
+				  ring->nhi->iobase + REG_DMA_MISC);
 
 		ivr_base = ring->nhi->iobase + REG_INT_VEC_ALLOC_BASE;
 		step = index / REG_INT_VEC_ALLOC_REGS * REG_INT_VEC_ALLOC_BITS;
@@ -112,7 +113,7 @@ static void ring_interrupt_active(struct
 
 	dev_dbg(&ring->nhi->pdev->dev,
 		"%s interrupt at register %#x bit %d (%#x -> %#x)\n",
-		active ? "enabling" : "disabling", reg, bit, old, new);
+		active ? "enabling" : "disabling", reg, interrupt_bit, old, new);
 
 	if (new == old)
 		dev_WARN(&ring->nhi->pdev->dev,


