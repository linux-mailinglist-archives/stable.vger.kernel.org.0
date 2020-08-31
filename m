Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC9A257D3E
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgHaPbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728803AbgHaPbH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:31:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24ED72192A;
        Mon, 31 Aug 2020 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887867;
        bh=9xF3pCnhJDst3nnSSl/WT0nA5l0CMHpfotCF6C81O0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=159UmC4+i6GfcoAbezyrDAHgsI60mck7Fs9g0CDNTkl9/gpn+6r43AXJvuGf+YXhZ
         7stBAuEFTyQgLngaEUz3pOW80/MxoWlLzTR8X8Ai+yad0IW6Q2NuvEisNhoc8MWl0u
         LV8uBPdXSljs+kPd1V9M21quNfSO13wfdyHKTqtI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/23] s390: don't trace preemption in percpu macros
Date:   Mon, 31 Aug 2020 11:30:33 -0400
Message-Id: <20200831153039.1024302-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153039.1024302-1-sashal@kernel.org>
References: <20200831153039.1024302-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 1196f12a2c960951d02262af25af0bb1775ebcc2 ]

Since commit a21ee6055c30 ("lockdep: Change hardirq{s_enabled,_context}
to per-cpu variables") the lockdep code itself uses percpu variables. This
leads to recursions because the percpu macros are calling preempt_enable()
which might call trace_preempt_on().

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/include/asm/percpu.h | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/s390/include/asm/percpu.h b/arch/s390/include/asm/percpu.h
index 50b4ce8cddfdc..918f0ba4f4d20 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -29,7 +29,7 @@
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ old__, new__, prev__;				\
 	pcp_op_T__ *ptr__;						\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));					\
 	prev__ = *ptr__;						\
 	do {								\
@@ -37,7 +37,7 @@
 		new__ = old__ op (val);					\
 		prev__ = cmpxchg(ptr__, old__, new__);			\
 	} while (prev__ != old__);					\
-	preempt_enable();						\
+	preempt_enable_notrace();					\
 	new__;								\
 })
 
@@ -68,7 +68,7 @@
 	typedef typeof(pcp) pcp_op_T__; 				\
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp)); 				\
 	if (__builtin_constant_p(val__) &&				\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {		\
@@ -84,7 +84,7 @@
 			: [val__] "d" (val__)				\
 			: "cc");					\
 	}								\
-	preempt_enable();						\
+	preempt_enable_notrace();					\
 }
 
 #define this_cpu_add_4(pcp, val) arch_this_cpu_add(pcp, val, "laa", "asi", int)
@@ -95,14 +95,14 @@
 	typedef typeof(pcp) pcp_op_T__; 				\
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));	 				\
 	asm volatile(							\
 		op "    %[old__],%[val__],%[ptr__]\n"			\
 		: [old__] "=d" (old__), [ptr__] "+Q" (*ptr__)		\
 		: [val__] "d" (val__)					\
 		: "cc");						\
-	preempt_enable();						\
+	preempt_enable_notrace();						\
 	old__ + val__;							\
 })
 
@@ -114,14 +114,14 @@
 	typedef typeof(pcp) pcp_op_T__; 				\
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));	 				\
 	asm volatile(							\
 		op "    %[old__],%[val__],%[ptr__]\n"			\
 		: [old__] "=d" (old__), [ptr__] "+Q" (*ptr__)		\
 		: [val__] "d" (val__)					\
 		: "cc");						\
-	preempt_enable();						\
+	preempt_enable_notrace();					\
 }
 
 #define this_cpu_and_4(pcp, val)	arch_this_cpu_to_op(pcp, val, "lan")
@@ -136,10 +136,10 @@
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ ret__;						\
 	pcp_op_T__ *ptr__;						\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));					\
 	ret__ = cmpxchg(ptr__, oval, nval);				\
-	preempt_enable();						\
+	preempt_enable_notrace();					\
 	ret__;								\
 })
 
@@ -152,10 +152,10 @@
 ({									\
 	typeof(pcp) *ptr__;						\
 	typeof(pcp) ret__;						\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));					\
 	ret__ = xchg(ptr__, nval);					\
-	preempt_enable();						\
+	preempt_enable_notrace();					\
 	ret__;								\
 })
 
@@ -171,11 +171,11 @@
 	typeof(pcp1) *p1__;						\
 	typeof(pcp2) *p2__;						\
 	int ret__;							\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	p1__ = raw_cpu_ptr(&(pcp1));					\
 	p2__ = raw_cpu_ptr(&(pcp2));					\
 	ret__ = __cmpxchg_double(p1__, p2__, o1__, o2__, n1__, n2__);	\
-	preempt_enable();						\
+	preempt_enable_notrace();					\
 	ret__;								\
 })
 
-- 
2.25.1

