Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07602264B1
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbfEVNZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:25:49 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:51396 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbfEVNZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:25:49 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC9D015BF;
        Wed, 22 May 2019 06:25:48 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 742E23F575;
        Wed, 22 May 2019 06:25:44 -0700 (PDT)
From:   Mark Rutland <mark.rutland@arm.com>
To:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        will.deacon@arm.com
Cc:     aou@eecs.berkeley.edu, arnd@arndb.de, bp@alien8.de,
        catalin.marinas@arm.com, davem@davemloft.net, fenghua.yu@intel.com,
        heiko.carstens@de.ibm.com, herbert@gondor.apana.org.au,
        ink@jurassic.park.msu.ru, jhogan@kernel.org, linux@armlinux.org.uk,
        mark.rutland@arm.com, mattst88@gmail.com, mingo@kernel.org,
        mpe@ellerman.id.au, palmer@sifive.com, paul.burton@mips.com,
        paulus@samba.org, ralf@linux-mips.org, rth@twiddle.net,
        stable@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        vgupta@synopsys.com
Subject: [PATCH 18/18] locking/atomic: s390/pci: remove redundant casts
Date:   Wed, 22 May 2019 14:22:50 +0100
Message-Id: <20190522132250.26499-19-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now that atomic64_read() returns s64 consistently, we don't need to
explicitly cast its return value. Drop the redundant casts.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/s390/pci/pci_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci_debug.c b/arch/s390/pci/pci_debug.c
index 45eccf79e990..3408c0df3ebf 100644
--- a/arch/s390/pci/pci_debug.c
+++ b/arch/s390/pci/pci_debug.c
@@ -75,7 +75,7 @@ static void pci_sw_counter_show(struct seq_file *m)
 
 	for (i = 0; i < ARRAY_SIZE(pci_sw_names); i++, counter++)
 		seq_printf(m, "%26s:\t%llu\n", pci_sw_names[i],
-			   (s64)atomic64_read(counter));
+			   atomic64_read(counter));
 }
 
 static int pci_perf_show(struct seq_file *m, void *v)
-- 
2.11.0

