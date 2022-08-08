Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1EB758BEB6
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 03:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiHHBbf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Aug 2022 21:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiHHBba (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Aug 2022 21:31:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DB15FC8;
        Sun,  7 Aug 2022 18:31:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9477D60DDB;
        Mon,  8 Aug 2022 01:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D6EC433D6;
        Mon,  8 Aug 2022 01:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659922288;
        bh=ZYta0xWaaaX3NVY+blxrrshyWYllF3ppbUR9PCuCCpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gH1p6fM9zuBlHXAcjzTGKQIX95z8lk3mDrgx+unCcY8skdBNipMHbxLNya3J48Z+n
         64fcUIL44XGYcOO9/YoLu3fqblt9tQcI5wVGXbvkBgzAe1VbR/vauqEi3TfRcUObRf
         cS9M9hqrnwSNDWwuWFiQ5ankNqPXUPC0MNM0j28v4ouevSARV2GVOadfaoa0P3qXWq
         /zxiwJakn39CNlUa3lBGWC0/ONN6oulLHXmIsSzSOR11UQ5aOSYTR0WfsxtZOfcduw
         /8X9iAbAMUFhFU4ZlX5kQYbTC2K0o1Z/u/HrSYNJH6WWLd1uwt/iiiRieajRKuodQ9
         Gc43+NomOWwLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, keescook@chromium.org, nathan@kernel.org,
        paulmck@kernel.org, frederic@kernel.org, jpoimboe@kernel.org,
        ebiederm@xmission.com, mhiramat@kernel.org, elver@google.com,
        linux@roeck-us.net, ashimida@linux.alibaba.com, song@kernel.org
Subject: [PATCH AUTOSEL 5.19 02/58] arch: make TRACE_IRQFLAGS_NMI_SUPPORT generic
Date:   Sun,  7 Aug 2022 21:30:20 -0400
Message-Id: <20220808013118.313965-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220808013118.313965-1-sashal@kernel.org>
References: <20220808013118.313965-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 4510bffb4d0246cdcc1f14c7367c026b807a862d ]

On most architectures, IRQ flag tracing is disabled in NMI context, and
architectures need to define and select TRACE_IRQFLAGS_NMI_SUPPORT in
order to enable this.

Commit:

  859d069ee1ddd878 ("lockdep: Prepare for NMI IRQ state tracking")

Permitted IRQ flag tracing in NMI context, allowing lockdep to work in
NMI context where an architecture had suitable entry logic. At the time,
most architectures did not have such suitable entry logic, and this broke
lockdep on such architectures. Thus, this was partially disabled in
commit:

  ed00495333ccc80f ("locking/lockdep: Fix TRACE_IRQFLAGS vs. NMIs")

... with architectures needing to select TRACE_IRQFLAGS_NMI_SUPPORT to
enable IRQ flag tracing in NMI context.

Currently TRACE_IRQFLAGS_NMI_SUPPORT is defined under
arch/x86/Kconfig.debug. Move it to arch/Kconfig so architectures can
select it without having to provide their own definition.

Since the regular TRACE_IRQFLAGS_SUPPORT is selected by
arch/x86/Kconfig, the select of TRACE_IRQFLAGS_NMI_SUPPORT is moved
there too.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20220511131733.4074499-2-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/Kconfig           | 3 +++
 arch/x86/Kconfig       | 1 +
 arch/x86/Kconfig.debug | 3 ---
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 71b9272acb28..5ea3e3838c21 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -223,6 +223,9 @@ config HAVE_FUNCTION_DESCRIPTORS
 config TRACE_IRQFLAGS_SUPPORT
 	bool
 
+config TRACE_IRQFLAGS_NMI_SUPPORT
+	bool
+
 #
 # An arch should select this if it provides all these things:
 #
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 52a7f91527fe..25e2b8b75e40 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -278,6 +278,7 @@ config X86
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
 	select TRACE_IRQFLAGS_SUPPORT
+	select TRACE_IRQFLAGS_NMI_SUPPORT
 	select USER_STACKTRACE_SUPPORT
 	select VIRT_TO_BUS
 	select HAVE_ARCH_KCSAN			if X86_64
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 340399f69954..bdfe08f1a930 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -1,8 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
-config TRACE_IRQFLAGS_NMI_SUPPORT
-	def_bool y
-
 config EARLY_PRINTK_USB
 	bool
 
-- 
2.35.1

