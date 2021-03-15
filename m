Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC0333B8A6
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233939AbhCOOEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233083AbhCOOAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5544464F5B;
        Mon, 15 Mar 2021 14:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816823;
        bh=F7ooJGIPfcpYwlEUhOQ2t4Gu4YpBSugLrYGOn/zF/y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzGR/V/a7sGLgTdq/4oCR4g+Tp6jrUwlAY8jsx357vfnFzIJuDvY5Ao2b6JmmNEPX
         BfMMmkeVuL6CYadOjJqa/udD1yzL/0aC1K+xhAEdS1gCQJCmzjGXPzsQyuTOiYlCAP
         QX1pXpmGB63fyDKqKbBZEEumLMXQAafGyYDB6KrI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 85/95] stop_machine: mark helpers __always_inline
Date:   Mon, 15 Mar 2021 14:57:55 +0100
Message-Id: <20210315135743.075174308@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit cbf78d85079cee662c45749ef4f744d41be85d48 ]

With clang-13, some functions only get partially inlined, with a
specialized version referring to a global variable.  This triggers a
harmless build-time check for the intel-rng driver:

WARNING: modpost: drivers/char/hw_random/intel-rng.o(.text+0xe): Section mismatch in reference from the function stop_machine() to the function .init.text:intel_rng_hw_init()
The function stop_machine() references
the function __init intel_rng_hw_init().
This is often because stop_machine lacks a __init
annotation or the annotation of intel_rng_hw_init is wrong.

In this instance, an easy workaround is to force the stop_machine()
function to be inline, along with related interfaces that did not show the
same behavior at the moment, but theoretically could.

The combination of the two patches listed below triggers the behavior in
clang-13, but individually these commits are correct.

Link: https://lkml.kernel.org/r/20210225130153.1956990-1-arnd@kernel.org
Fixes: fe5595c07400 ("stop_machine: Provide stop_machine_cpuslocked()")
Fixes: ee527cd3a20c ("Use stop_machine_run in the Intel RNG driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/stop_machine.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 6d3635c86dbe..ccdaa8fd5657 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -138,7 +138,7 @@ int stop_machine_from_inactive_cpu(cpu_stop_fn_t fn, void *data,
 				   const struct cpumask *cpus);
 #else	/* CONFIG_SMP || CONFIG_HOTPLUG_CPU */
 
-static inline int stop_machine_cpuslocked(cpu_stop_fn_t fn, void *data,
+static __always_inline int stop_machine_cpuslocked(cpu_stop_fn_t fn, void *data,
 					  const struct cpumask *cpus)
 {
 	unsigned long flags;
@@ -149,14 +149,15 @@ static inline int stop_machine_cpuslocked(cpu_stop_fn_t fn, void *data,
 	return ret;
 }
 
-static inline int stop_machine(cpu_stop_fn_t fn, void *data,
-			       const struct cpumask *cpus)
+static __always_inline int
+stop_machine(cpu_stop_fn_t fn, void *data, const struct cpumask *cpus)
 {
 	return stop_machine_cpuslocked(fn, data, cpus);
 }
 
-static inline int stop_machine_from_inactive_cpu(cpu_stop_fn_t fn, void *data,
-						 const struct cpumask *cpus)
+static __always_inline int
+stop_machine_from_inactive_cpu(cpu_stop_fn_t fn, void *data,
+			       const struct cpumask *cpus)
 {
 	return stop_machine(fn, data, cpus);
 }
-- 
2.30.1



