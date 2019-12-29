Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1A612CA15
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfL2SQj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:16:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727141AbfL2RYE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:24:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3A01207FD;
        Sun, 29 Dec 2019 17:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640243;
        bh=LzEFEz/rwAarUMRtuzFxTzAa7OZ9EE8KIOv5dBfUEak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xiWFZ15D+UJ5rFUiJrfJNSPKiEE+aMfOXj8e/JFhC4e9gS4acz4xEkRImreKzjLQ3
         NCd0BapaMdHDhsCkKUBf0lhe6JFLx4SDL07P5oQ2zd1Th4Q4KLkS9Bu9qZMmL4vfAL
         rnYm8RYllvjAy4puZwdaVOkLVj6Ih3yFtDmj3Dnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/161] s390/time: ensure get_clock_monotonic() returns monotonic values
Date:   Sun, 29 Dec 2019 18:18:44 +0100
Message-Id: <20191229162423.283631437@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 64539c221672..0f12a3f91282 100644
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



