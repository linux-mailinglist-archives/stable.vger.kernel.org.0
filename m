Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B00264AA
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfEVNZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:25:38 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:51290 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbfEVNZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:25:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1C9415AB;
        Wed, 22 May 2019 06:25:37 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A90103F575;
        Wed, 22 May 2019 06:25:33 -0700 (PDT)
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
Subject: [PATCH 16/18] locking/atomic: use s64 for atomic64_t on 64-bit
Date:   Wed, 22 May 2019 14:22:48 +0100
Message-Id: <20190522132250.26499-17-mark.rutland@arm.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190522132250.26499-1-mark.rutland@arm.com>
References: <20190522132250.26499-1-mark.rutland@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Now that all architectures use 64 consistently as the base type for the
atomic64 API, let's have the CONFIG_64BIT definition of atomic64_t use
s64 as the underlying type for atomic64_t, rather than long, matching
the generated headers.

On architectures where atomic64_read(v) is READ_ONCE(v->counter), this
patch will cause the return type of atomic64_read() to be s64.

As of this patch, the atomic64 API can be relied upon to consistently
return s64 where a value rather than boolean condition is returned. This
should make code more robust, and simpler, allowing for the removal of
casts previously required to ensure consistent types.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 include/linux/types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index 231114ae38f4..05030f608be3 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -174,7 +174,7 @@ typedef struct {
 
 #ifdef CONFIG_64BIT
 typedef struct {
-	long counter;
+	s64 counter;
 } atomic64_t;
 #endif
 
-- 
2.11.0

