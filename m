Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA423548A85
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385702AbiFMOqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386364AbiFMOpG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:45:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4322CB8BC5;
        Mon, 13 Jun 2022 04:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 203D8B80ECD;
        Mon, 13 Jun 2022 11:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A46CC34114;
        Mon, 13 Jun 2022 11:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121099;
        bh=reSh3o33ZqNq0NqYioUu+8w+hd6FEd7K/Cf3BqMB9N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qNaANn0IBF0BhuFAmeF3dWMMZCyoY9WPzNLRd7LqqEhgpQYUDKiV/14OVZyOvoE6b
         zzsl12Isqoaa+5BiyioirVrdlCSgj39I9QSkmanT8lHUIvWZNzEPbqaUNPZ814kAvl
         nCpQxrscWb9m92g/CXvBIMt5tXrAKSPOjjLxLtfE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 248/298] s390/gmap: voluntarily schedule during key setting
Date:   Mon, 13 Jun 2022 12:12:22 +0200
Message-Id: <20220613094932.605487383@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index dfee0ebb2fac..88f6d923ee45 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2601,6 +2601,18 @@ static int __s390_enable_skey_pte(pte_t *pte, unsigned long addr,
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
@@ -2623,12 +2635,14 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
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



