Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D3F540D7A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353864AbiFGSso (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354116AbiFGSqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A15618FA5D;
        Tue,  7 Jun 2022 11:00:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 104DC616B6;
        Tue,  7 Jun 2022 18:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EEEC3411F;
        Tue,  7 Jun 2022 18:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624805;
        bh=pX0nzPf64Gi4N4lq58ZN23VDkANWV2A2CBadwxo9BvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OW2GvImPO43hKq1qfk7tHUfn9DvuP+Vm8uDtQeh4zaNeEPoxstS8V5AUYmMuUWmUy
         uexEQBOBux+zyhS00eZ3k6A3Lfa3S/Nbn6ZQ62U12/4DAvhFdlEB+Ws4D9fl91TNOY
         i5H7y6yCpPI4KWk0qptxYmz/LsmQszESB+9A/oyGGaxEeMcj8r5hpegok/kk5pALXE
         oivs0UWM78CFQE1cKLWIZJrX8aZ7xj+8NeqdwvW3wUzhB0EGqkue07tC+v0fioWNyi
         598UPxwd21Bc+N0MbtBEJNdlICsH8/5fcI/eolzKnelbHmURcM4bv8aRiVDFZDmAeP
         GzKNbG0ZA4THg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, frankja@linux.ibm.com,
        gor@linux.ibm.com, kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 36/38] s390/gmap: voluntarily schedule during key setting
Date:   Tue,  7 Jun 2022 13:58:31 -0400
Message-Id: <20220607175835.480735-36-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175835.480735-1-sashal@kernel.org>
References: <20220607175835.480735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Borntraeger <borntraeger@linux.ibm.com>

[ Upstream commit 6d5946274df1fff539a7eece458a43be733d1db8 ]

With large and many guest with storage keys it is possible to create
large latencies or stalls during initial key setting:

rcu: INFO: rcu_sched self-detected stall on CPU
rcu:   18-....: (2099 ticks this GP) idle=54e/1/0x4000000000000002 softirq=35598716/35598716 fqs=998
       (t=2100 jiffies g=155867385 q=20879)
Task dump for CPU 18:
CPU 1/KVM       R  running task        0 1030947 256019 0x06000004
Call Trace:
sched_show_task
rcu_dump_cpu_stacks
rcu_sched_clock_irq
update_process_times
tick_sched_handle
tick_sched_timer
__hrtimer_run_queues
hrtimer_interrupt
do_IRQ
ext_int_handler
ptep_zap_key

The mmap lock is held during the page walking but since this is a
semaphore scheduling is still possible. Same for the kvm srcu.
To minimize overhead do this on every segment table entry or large page.

Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220530092706.11637-2-borntraeger@linux.ibm.com
Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/gmap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index f2d19d40272c..2db097c14cec 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2596,6 +2596,18 @@ static int __s390_enable_skey_pte(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
+/*
+ * Give a chance to schedule after setting a key to 256 pages.
+ * We only hold the mm lock, which is a rwsem and the kvm srcu.
+ * Both can sleep.
+ */
+static int __s390_enable_skey_pmd(pmd_t *pmd, unsigned long addr,
+				  unsigned long next, struct mm_walk *walk)
+{
+	cond_resched();
+	return 0;
+}
+
 static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 				      unsigned long hmask, unsigned long next,
 				      struct mm_walk *walk)
@@ -2618,12 +2630,14 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 	end = start + HPAGE_SIZE - 1;
 	__storage_key_init_range(start, end);
 	set_bit(PG_arch_1, &page->flags);
+	cond_resched();
 	return 0;
 }
 
 static const struct mm_walk_ops enable_skey_walk_ops = {
 	.hugetlb_entry		= __s390_enable_skey_hugetlb,
 	.pte_entry		= __s390_enable_skey_pte,
+	.pmd_entry		= __s390_enable_skey_pmd,
 };
 
 int s390_enable_skey(void)
-- 
2.35.1

