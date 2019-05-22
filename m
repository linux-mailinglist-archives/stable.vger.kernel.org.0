Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B850926487
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfEVNXh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:23:37 -0400
Received: from foss.arm.com ([217.140.101.70]:50502 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbfEVNXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:23:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5C86F80D;
        Wed, 22 May 2019 06:23:37 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1CF133F575;
        Wed, 22 May 2019 06:23:32 -0700 (PDT)
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
Subject: [PATCH 01/18] locking/atomic: crypto: nx: prepare for atomic64_read() conversion
Date:   Wed, 22 May 2019 14:22:33 +0100
Message-Id: <20190522132250.26499-2-mark.rutland@arm.com>
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

As a preparatory step, this patch updates the nx-842 code to treat the
return value of atomic64_read() as s64, using explicit casts. These
casts will be removed once the s64 conversion is complete.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 drivers/crypto/nx/nx-842-pseries.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 57932848361b..9432e9e42afe 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -869,8 +869,8 @@ static ssize_t nx842_##_name##_show(struct device *dev,		\
 	rcu_read_lock();						\
 	local_devdata = rcu_dereference(devdata);			\
 	if (local_devdata)						\
-		p = snprintf(buf, PAGE_SIZE, "%ld\n",			\
-		       atomic64_read(&local_devdata->counters->_name));	\
+		p = snprintf(buf, PAGE_SIZE, "%lld\n",			\
+		       (s64)atomic64_read(&local_devdata->counters->_name));	\
 	rcu_read_unlock();						\
 	return p;							\
 }
@@ -922,17 +922,17 @@ static ssize_t nx842_timehist_show(struct device *dev,
 	}
 
 	for (i = 0; i < (NX842_HIST_SLOTS - 2); i++) {
-		bytes = snprintf(p, bytes_remain, "%u-%uus:\t%ld\n",
+		bytes = snprintf(p, bytes_remain, "%u-%uus:\t%lld\n",
 			       i ? (2<<(i-1)) : 0, (2<<i)-1,
-			       atomic64_read(&times[i]));
+			       (s64)atomic64_read(&times[i]));
 		bytes_remain -= bytes;
 		p += bytes;
 	}
 	/* The last bucket holds everything over
 	 * 2<<(NX842_HIST_SLOTS - 2) us */
-	bytes = snprintf(p, bytes_remain, "%uus - :\t%ld\n",
+	bytes = snprintf(p, bytes_remain, "%uus - :\t%lld\n",
 			2<<(NX842_HIST_SLOTS - 2),
-			atomic64_read(&times[(NX842_HIST_SLOTS - 1)]));
+			(s64)atomic64_read(&times[(NX842_HIST_SLOTS - 1)]));
 	p += bytes;
 
 	rcu_read_unlock();
-- 
2.11.0

