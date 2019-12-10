Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB09A1193CD
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfLJVKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:60598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728531AbfLJVKd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:10:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F228246C4;
        Tue, 10 Dec 2019 21:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012233;
        bh=qoWIB+0WSAHa/3SwzS6I1z52KR/Wh/ZPFYeXYzN9PqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftwrQ6ccbopfaYCsCYq4OVICDtXHKYkm3focToIOSF0BVMjaoC75D4cQJqGUsLy3X
         1qe0lERg5TU1PDWMoxku12/SPpk5i6m0P/GBjBs4+sE6trBALv9OVotW73LjtKW1px
         SckpQsmkthGyKOWFHsUkJz5uyi+OrZYPmuBkvdgg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 182/350] s390/time: ensure get_clock_monotonic() returns monotonic values
Date:   Tue, 10 Dec 2019 16:04:47 -0500
Message-Id: <20191210210735.9077-143-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[ Upstream commit 011620688a71f2f1fe9901dbc2479a7c01053196 ]

The current implementation of get_clock_monotonic() leaves it up to
the caller to call the function with preemption disabled. The only
core kernel caller (sched_clock) however does not disable preemption.

In order to make sure that all callers of this function see monotonic
values handle disabling preemption within the function itself.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/timex.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/timex.h b/arch/s390/include/asm/timex.h
index 64539c221672b..0f12a3f912820 100644
--- a/arch/s390/include/asm/timex.h
+++ b/arch/s390/include/asm/timex.h
@@ -10,8 +10,9 @@
 #ifndef _ASM_S390_TIMEX_H
 #define _ASM_S390_TIMEX_H
 
-#include <asm/lowcore.h>
+#include <linux/preempt.h>
 #include <linux/time64.h>
+#include <asm/lowcore.h>
 
 /* The value of the TOD clock for 1.1.1970. */
 #define TOD_UNIX_EPOCH 0x7d91048bca000000ULL
@@ -186,15 +187,18 @@ extern unsigned char tod_clock_base[16] __aligned(8);
 /**
  * get_clock_monotonic - returns current time in clock rate units
  *
- * The caller must ensure that preemption is disabled.
  * The clock and tod_clock_base get changed via stop_machine.
- * Therefore preemption must be disabled when calling this
- * function, otherwise the returned value is not guaranteed to
- * be monotonic.
+ * Therefore preemption must be disabled, otherwise the returned
+ * value is not guaranteed to be monotonic.
  */
 static inline unsigned long long get_tod_clock_monotonic(void)
 {
-	return get_tod_clock() - *(unsigned long long *) &tod_clock_base[1];
+	unsigned long long tod;
+
+	preempt_disable();
+	tod = get_tod_clock() - *(unsigned long long *) &tod_clock_base[1];
+	preempt_enable();
+	return tod;
 }
 
 /**
-- 
2.20.1

