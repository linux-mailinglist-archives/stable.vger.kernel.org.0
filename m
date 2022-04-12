Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8262D4FD5C2
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352886AbiDLHda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354889AbiDLH05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126F4473A7;
        Tue, 12 Apr 2022 00:06:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80E28616DC;
        Tue, 12 Apr 2022 07:06:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9029DC385AC;
        Tue, 12 Apr 2022 07:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747209;
        bh=ntbeJfFcUf36LtQuxnH6guNMinHbq9Rd/OpBJmA0IJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SpSq9+vG6f3NH9SCT8X4kb095Scn8IavoVN54Ug7ggZrax6RlfVMFrVQ3WDVV6uK/
         TK8DliI8lXubBNrEx8zsLVoL+gXIWDsWC/AYoSkSUD2+zmBkir6lJTYP0CAhfuvzGH
         g7BEAiYhxpPG+MxL46CdOT1OMF9MyA4oaRq5wsaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingyi Wang <wangjingyi11@huawei.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.16 281/285] irqchip/gic-v4: Wait for GICR_VPENDBASER.Dirty to clear before descheduling
Date:   Tue, 12 Apr 2022 08:32:18 +0200
Message-Id: <20220412062951.762096947@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit af27e41612ec7e5b4783f589b753a7c31a37aac8 upstream.

The way KVM drives GICv4.{0,1} is as follows:
- vcpu_load() makes the VPE resident, instructing the RD to start
  scanning for interrupts
- just before entering the guest, we check that the RD has finished
  scanning and that we can start running the vcpu
- on preemption, we deschedule the VPE by making it invalid on
  the RD

However, we are preemptible between the first two steps. If it so
happens *and* that the RD was still scanning, we nonetheless write
to the GICR_VPENDBASER register while Dirty is set, and bad things
happen (we're in UNPRED land).

This affects both the 4.0 and 4.1 implementations.

Make sure Dirty is cleared before performing the deschedule,
meaning that its_clear_vpend_valid() becomes a sort of full VPE
residency barrier.

Reported-by: Jingyi Wang <wangjingyi11@huawei.com>
Tested-by: Nianyao Tang <tangnianyao@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Fixes: 57e3cebd022f ("KVM: arm64: Delay the polling of the GICR_VPENDBASER.Dirty bit")
Link: https://lore.kernel.org/r/4aae10ba-b39a-5f84-754b-69c2eb0a2c03@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3007,18 +3007,12 @@ static int __init allocate_lpi_tables(vo
 	return 0;
 }
 
-static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
+static u64 read_vpend_dirty_clear(void __iomem *vlpi_base)
 {
 	u32 count = 1000000;	/* 1s! */
 	bool clean;
 	u64 val;
 
-	val = gicr_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
-	val &= ~GICR_VPENDBASER_Valid;
-	val &= ~clr;
-	val |= set;
-	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
-
 	do {
 		val = gicr_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
 		clean = !(val & GICR_VPENDBASER_Dirty);
@@ -3029,10 +3023,26 @@ static u64 its_clear_vpend_valid(void __
 		}
 	} while (!clean && count);
 
-	if (unlikely(val & GICR_VPENDBASER_Dirty)) {
+	if (unlikely(!clean))
 		pr_err_ratelimited("ITS virtual pending table not cleaning\n");
+
+	return val;
+}
+
+static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
+{
+	u64 val;
+
+	/* Make sure we wait until the RD is done with the initial scan */
+	val = read_vpend_dirty_clear(vlpi_base);
+	val &= ~GICR_VPENDBASER_Valid;
+	val &= ~clr;
+	val |= set;
+	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
+
+	val = read_vpend_dirty_clear(vlpi_base);
+	if (unlikely(val & GICR_VPENDBASER_Dirty))
 		val |= GICR_VPENDBASER_PendingLast;
-	}
 
 	return val;
 }


