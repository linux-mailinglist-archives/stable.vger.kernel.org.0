Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E49D726489
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbfEVNXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:23:51 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50556 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728912AbfEVNXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:23:51 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AED080D;
        Wed, 22 May 2019 06:23:51 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CE43F3F575;
        Wed, 22 May 2019 06:23:46 -0700 (PDT)
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
Subject: [PATCH 02/18] locking/atomic: s390/pci: prepare for atomic64_read() conversion
Date:   Wed, 22 May 2019 14:22:34 +0100
Message-Id: <20190522132250.26499-3-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The return type of atomic64_read() varies by architecture. It may return
long (e.g. powerpc), long long (e.g. arm), or s64 (e.g. x86_64). This is
somewhat painful, and mandates the use of explicit casts in some cases
(e.g. when printing the return value).

To ameliorate matters, subsequent patches will make the atomic64 API
consistently use s64.

As a preparatory step, this patch updates the s390 pci debug code to
treat the return value of atomic64_read() as s64, using an explicit
cast. This cast will be removed once the s64 conversion is complete.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/s390/pci/pci_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_debug.c b/arch/s390/pci/pci_debug.c
index 6b48ca7760a7..45eccf79e990 100644
--- a/arch/s390/pci/pci_debug.c
+++ b/arch/s390/pci/pci_debug.c
@@ -74,8 +74,8 @@ static void pci_sw_counter_show(struct seq_file *m)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pci_sw_names); i++, counter++)
-		seq_printf(m, "%26s:\t%lu\n", pci_sw_names[i],
-			   atomic64_read(counter));
+		seq_printf(m, "%26s:\t%llu\n", pci_sw_names[i],
+			   (s64)atomic64_read(counter));
 }
 
 static int pci_perf_show(struct seq_file *m, void *v)
-- 
2.11.0

