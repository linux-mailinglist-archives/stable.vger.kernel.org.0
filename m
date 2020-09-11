Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294C026617D
	for <lists+stable@lfdr.de>; Fri, 11 Sep 2020 16:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgIKOsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 10:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:54396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgIKNCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Sep 2020 09:02:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 945EB22287;
        Fri, 11 Sep 2020 12:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599829020;
        bh=Rd1MFRgUDEkTx/wiIJII+ZUZaJaafXMLUlnBw2t2XPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPlkZFJBxSIkWT1/wUQY/Q3mLERZlWRoHCEf5kCnpNJU0HTnfTquv4n8SjWWqJoVE
         unyC2DihD0X4iOr4beCrrD6amkjmBL2DNeQYqrt9Mw76WtcIeWKb5PESzwTqOkB51j
         zkkAte+K7TvXkxwKnBGgKnBZgll9YYNfnhU6mdB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 07/71] s390: dont trace preemption in percpu macros
Date:   Fri, 11 Sep 2020 14:45:51 +0200
Message-Id: <20200911122505.306213989@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911122504.928931589@linuxfoundation.org>
References: <20200911122504.928931589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 90240dfef76a1..5889c1ed84c46 100644
--- a/arch/s390/include/asm/percpu.h
+++ b/arch/s390/include/asm/percpu.h
@@ -28,7 +28,7 @@
 	typedef typeof(pcp) pcp_op_T__;					\
 	pcp_op_T__ old__, new__, prev__;				\
 	pcp_op_T__ *ptr__;						\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp));					\
 	prev__ = *ptr__;						\
 	do {								\
@@ -36,7 +36,7 @@
 		new__ = old__ op (val);					\
 		prev__ = cmpxchg(ptr__, old__, new__);			\
 	} while (prev__ != old__);					\
-	preempt_enable();						\
+	preempt_enable_notrace();					\
 	new__;								\
 })
 
@@ -67,7 +67,7 @@
 	typedef typeof(pcp) pcp_op_T__; 				\
 	pcp_op_T__ val__ = (val);					\
 	pcp_op_T__ old__, *ptr__;					\
-	preempt_disable();						\
+	preempt_disable_notrace();					\
 	ptr__ = raw_cpu_ptr(&(pcp)); 				\
 	if (__builtin_constant_p(val__) &&				\
 	    ((szcast)val__ > -129) && ((szcast)val__ < 128)) {		\
@@ -83,7 +83,7 @@
 			: [val__] "d" (val__)				\
 			: "cc");					\
 	}								\
-	preempt_enable();						\
+	preempt_enable_notrace();					\
 }
 
 #define this_cpu_add_4(pcp, val) arch_this_cpu_add(pcp, val, "laa", "asi", int)
@@ -94,14 +94,14 @@
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
 
@@ -113,14 +113,14 @@
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
@@ -135,10 +135,10 @@
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
 
@@ -151,10 +151,10 @@
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
 
@@ -170,11 +170,11 @@
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



