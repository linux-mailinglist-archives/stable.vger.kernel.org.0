Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446CF5942D8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348047AbiHOW3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351090AbiHOW1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282BF422E6;
        Mon, 15 Aug 2022 12:47:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2769B80EB2;
        Mon, 15 Aug 2022 19:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE37C433D6;
        Mon, 15 Aug 2022 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592829;
        bh=ZYta0xWaaaX3NVY+blxrrshyWYllF3ppbUR9PCuCCpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S02tSGYNebssgymk4QypzxyqCjNls6S6kgVGDY5i1hfDZ753LyHrfDw/fg5nz5EyQ
         mJA+6gDZ70nDYJL9UU/ZUYwfOgc4L834EpTqoMOZrBfWKOGQg9mptdZ3Duk4zeirtU
         LQKAui8bV1rn6lWYMMSrkK/N2BsV3l517naeUQJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0148/1157] arch: make TRACE_IRQFLAGS_NMI_SUPPORT generic
Date:   Mon, 15 Aug 2022 19:51:44 +0200
Message-Id: <20220815180445.581946288@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



