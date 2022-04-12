Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280754FD58A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377533AbiDLHuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359393AbiDLHnA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083752CCA6;
        Tue, 12 Apr 2022 00:22:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB537B81B4F;
        Tue, 12 Apr 2022 07:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31232C385A5;
        Tue, 12 Apr 2022 07:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748141;
        bh=gG2l95nc3o6r+Na0a2Vg2hAkYDSYrk+WcrC0aYTmvr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdW5GiT1D0exoHLmo/S3MUSBzB3SvWi18J0z/GF/Qw4Bpjd7gZAb1+V7CK0b+Llsk
         u+Q60+gFx0Gxr7Fz2pJAqlM6aEynQ4DOuTej/wHCsTtXOX/DM6x7YZaClZRyOoJXkd
         sPWPBW7tOL3OfEturxtrdB1mhZsqU5GT90ZrrAq4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingyi Wang <wangjingyi11@huawei.com>,
        Nianyao Tang <tangnianyao@huawei.com>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.17 335/343] irqchip/gic-v4: Wait for GICR_VPENDBASER.Dirty to clear before descheduling
Date:   Tue, 12 Apr 2022 08:32:33 +0200
Message-Id: <20220412063000.988387489@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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
@@ -3011,18 +3011,12 @@ static int __init allocate_lpi_tables(vo
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
@@ -3033,10 +3027,26 @@ static u64 its_clear_vpend_valid(void __
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


