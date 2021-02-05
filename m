Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD78311444
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhBEWCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:02:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:44678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231489AbhBEOye (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:54:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06434650C9;
        Fri,  5 Feb 2021 14:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534501;
        bh=Nw4bYKAmuQK2ybBR8s65hqtGG2O36emorJfd7nWAqPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H5eNfvcsg+venXBXmp5HenrE4rtNhRHAnx4OcqEfEmA2jym/SalhAFzeEN/N9NTID
         X+bBM4EbYo4SCI71UJC4tiYXYQzcYuYxCCYLlkPXgntb8n0AT4iWHXVgbPUH6lrgqD
         c9EEOC2Zd6fWuggP2NdnUmQb6Ce0W4KyleU7c8UI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/15] x86: __always_inline __{rd,wr}msr()
Date:   Fri,  5 Feb 2021 15:08:54 +0100
Message-Id: <20210205140650.103083578@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140649.733510103@linuxfoundation.org>
References: <20210205140649.733510103@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 66a425011c61e71560c234492d204e83cfb73d1d ]

When the compiler choses to not inline the trivial MSR helpers:

  vmlinux.o: warning: objtool: __sev_es_nmi_complete()+0xce: call to __wrmsr.constprop.14() leaves .noinstr.text section

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Link: https://lore.kernel.org/r/X/bf3gV+BW7kGEsB@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/msr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 30df295f6d94c..18f9a9b7280bd 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -88,7 +88,7 @@ static inline void do_trace_rdpmc(unsigned int msr, u64 val, int failed) {}
  * think of extending them - you will be slapped with a stinking trout or a frozen
  * shark will reach you, wherever you are! You've been warned.
  */
-static inline unsigned long long notrace __rdmsr(unsigned int msr)
+static __always_inline unsigned long long __rdmsr(unsigned int msr)
 {
 	DECLARE_ARGS(val, low, high);
 
@@ -100,7 +100,7 @@ static inline unsigned long long notrace __rdmsr(unsigned int msr)
 	return EAX_EDX_VAL(val, low, high);
 }
 
-static inline void notrace __wrmsr(unsigned int msr, u32 low, u32 high)
+static __always_inline void __wrmsr(unsigned int msr, u32 low, u32 high)
 {
 	asm volatile("1: wrmsr\n"
 		     "2:\n"
-- 
2.27.0



