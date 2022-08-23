Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 628AE59DA1F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352262AbiHWKFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351823AbiHWKDg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:03:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675557C74C;
        Tue, 23 Aug 2022 01:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAB55B8105C;
        Tue, 23 Aug 2022 08:51:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC59C433C1;
        Tue, 23 Aug 2022 08:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244675;
        bh=gLM8LBhORFu5PwRUSqfEW5Kpwo0NNLq/B/aFZnNfZHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+wa5B2rHzM0c48BerkRvvDhR3Dvn7h2GW19luSf4Roj4lfo2wP3ZviTqDNxcQWdl
         Rg6tQ9MilRvSh+qRTwHPT6NyeK27dP4IlF8gV7VhG1C7dc8fk68EBggSC+hQuCD4VP
         A5M63qoE6CW/8mSGbPhJlsVj4sdrdOChz8FMY564=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 132/244] powerpc/pci: Fix get_phb_number() locking
Date:   Tue, 23 Aug 2022 10:24:51 +0200
Message-Id: <20220823080103.521023017@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit 8d48562a2729742f767b0fdd994d6b2a56a49c63 upstream.

The recent change to get_phb_number() causes a DEBUG_ATOMIC_SLEEP
warning on some systems:

  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper
  preempt_count: 1, expected: 0
  RCU nest depth: 0, expected: 0
  1 lock held by swapper/1:
   #0: c157efb0 (hose_spinlock){+.+.}-{2:2}, at: pcibios_alloc_controller+0x64/0x220
  Preemption disabled at:
  [<00000000>] 0x0
  CPU: 0 PID: 1 Comm: swapper Not tainted 5.19.0-yocto-standard+ #1
  Call Trace:
  [d101dc90] [c073b264] dump_stack_lvl+0x50/0x8c (unreliable)
  [d101dcb0] [c0093b70] __might_resched+0x258/0x2a8
  [d101dcd0] [c0d3e634] __mutex_lock+0x6c/0x6ec
  [d101dd50] [c0a84174] of_alias_get_id+0x50/0xf4
  [d101dd80] [c002ec78] pcibios_alloc_controller+0x1b8/0x220
  [d101ddd0] [c140c9dc] pmac_pci_init+0x198/0x784
  [d101de50] [c140852c] discover_phbs+0x30/0x4c
  [d101de60] [c0007fd4] do_one_initcall+0x94/0x344
  [d101ded0] [c1403b40] kernel_init_freeable+0x1a8/0x22c
  [d101df10] [c00086e0] kernel_init+0x34/0x160
  [d101df30] [c001b334] ret_from_kernel_thread+0x5c/0x64

This is because pcibios_alloc_controller() holds hose_spinlock but
of_alias_get_id() takes of_mutex which can sleep.

The hose_spinlock protects the phb_bitmap, and also the hose_list, but
it doesn't need to be held while get_phb_number() calls the OF routines,
because those are only looking up information in the device tree.

So fix it by having get_phb_number() take the hose_spinlock itself, only
where required, and then dropping the lock before returning.
pcibios_alloc_controller() then needs to take the lock again before the
list_add() but that's safe, the order of the list is not important.

Fixes: 0fe1e96fef0a ("powerpc/pci: Prefer PCI domain assignment via DT 'linux,pci-domain' and alias")
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220815065550.1303620-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/pci-common.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -67,10 +67,6 @@ void set_pci_dma_ops(const struct dma_ma
 	pci_dma_ops = dma_ops;
 }
 
-/*
- * This function should run under locking protection, specifically
- * hose_spinlock.
- */
 static int get_phb_number(struct device_node *dn)
 {
 	int ret, phb_id = -1;
@@ -107,15 +103,20 @@ static int get_phb_number(struct device_
 	if (!ret)
 		phb_id = (int)(prop & (MAX_PHBS - 1));
 
+	spin_lock(&hose_spinlock);
+
 	/* We need to be sure to not use the same PHB number twice. */
 	if ((phb_id >= 0) && !test_and_set_bit(phb_id, phb_bitmap))
-		return phb_id;
+		goto out_unlock;
 
 	/* If everything fails then fallback to dynamic PHB numbering. */
 	phb_id = find_first_zero_bit(phb_bitmap, MAX_PHBS);
 	BUG_ON(phb_id >= MAX_PHBS);
 	set_bit(phb_id, phb_bitmap);
 
+out_unlock:
+	spin_unlock(&hose_spinlock);
+
 	return phb_id;
 }
 
@@ -126,10 +127,13 @@ struct pci_controller *pcibios_alloc_con
 	phb = zalloc_maybe_bootmem(sizeof(struct pci_controller), GFP_KERNEL);
 	if (phb == NULL)
 		return NULL;
-	spin_lock(&hose_spinlock);
+
 	phb->global_number = get_phb_number(dev);
+
+	spin_lock(&hose_spinlock);
 	list_add_tail(&phb->list_node, &hose_list);
 	spin_unlock(&hose_spinlock);
+
 	phb->dn = dev;
 	phb->is_dynamic = slab_is_available();
 #ifdef CONFIG_PPC64


