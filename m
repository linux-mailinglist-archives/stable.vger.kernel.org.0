Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B166264AE
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 15:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbfEVNZo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 09:25:44 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:51338 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729126AbfEVNZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 09:25:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BFFF80D;
        Wed, 22 May 2019 06:25:43 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5ACE53F575;
        Wed, 22 May 2019 06:25:39 -0700 (PDT)
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
Subject: [PATCH 17/18] locking/atomic: crypto: nx: remove redundant casts
Date:   Wed, 22 May 2019 14:22:49 +0100
Message-Id: <20190522132250.26499-18-mark.rutland@arm.com>
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
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will.deacon@arm.com>
---
 drivers/crypto/nx/nx-842-pseries.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 9432e9e42afe..5cf77729a438 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -870,7 +870,7 @@ static ssize_t nx842_##_name##_show(struct device *dev,		\
 	local_devdata = rcu_dereference(devdata);			\
 	if (local_devdata)						\
 		p = snprintf(buf, PAGE_SIZE, "%lld\n",			\
-		       (s64)atomic64_read(&local_devdata->counters->_name));	\
+		       atomic64_read(&local_devdata->counters->_name));	\
 	rcu_read_unlock();						\
 	return p;							\
 }
@@ -924,7 +924,7 @@ static ssize_t nx842_timehist_show(struct device *dev,
 	for (i = 0; i < (NX842_HIST_SLOTS - 2); i++) {
 		bytes = snprintf(p, bytes_remain, "%u-%uus:\t%lld\n",
 			       i ? (2<<(i-1)) : 0, (2<<i)-1,
-			       (s64)atomic64_read(&times[i]));
+			       atomic64_read(&times[i]));
 		bytes_remain -= bytes;
 		p += bytes;
 	}
@@ -932,7 +932,7 @@ static ssize_t nx842_timehist_show(struct device *dev,
 	 * 2<<(NX842_HIST_SLOTS - 2) us */
 	bytes = snprintf(p, bytes_remain, "%uus - :\t%lld\n",
 			2<<(NX842_HIST_SLOTS - 2),
-			(s64)atomic64_read(&times[(NX842_HIST_SLOTS - 1)]));
+			atomic64_read(&times[(NX842_HIST_SLOTS - 1)]));
 	p += bytes;
 
 	rcu_read_unlock();
-- 
2.11.0

