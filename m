Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07848286D4
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388046AbfEWTNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:13:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388560AbfEWTNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:13:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D19E217D7;
        Thu, 23 May 2019 19:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558638798;
        bh=DwPRsVPAigTrOiWpGpo/JfMhmIDhEdbd23DOd4P3y1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkcEaXSuKH5jLZs1r3e6WzrXxa40vOrS4R9DgWHHc1M+0F6VEgeOjSQpPNV7yWXeM
         w9PuyoHH0j/njQn89/I4SnzdaXoUtfJBoY4wtT4sUdeeWH0baSwcI8fwMlkpSXHhnY
         rcdIi7dpICzB18YMevpQpuDl+dp/Hfw2Cy0m951Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Gary R Hook <gary.hook@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Coly Li <colyli@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        "luto@kernel.org" <luto@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Matthew Wilcox <willy@infradead.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 69/77] x86/mm/mem_encrypt: Disable all instrumentation for early SME setup
Date:   Thu, 23 May 2019 21:06:27 +0200
Message-Id: <20190523181729.524273661@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181719.982121681@linuxfoundation.org>
References: <20190523181719.982121681@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b51ce3744f115850166f3d6c292b9c8cb849ad4f ]

Enablement of AMD's Secure Memory Encryption feature is determined very
early after start_kernel() is entered. Part of this procedure involves
scanning the command line for the parameter 'mem_encrypt'.

To determine intended state, the function sme_enable() uses library
functions cmdline_find_option() and strncmp(). Their use occurs early
enough such that it cannot be assumed that any instrumentation subsystem
is initialized.

For example, making calls to a KASAN-instrumented function before KASAN
is set up will result in the use of uninitialized memory and a boot
failure.

When AMD's SME support is enabled, conditionally disable instrumentation
of these dependent functions in lib/string.c and arch/x86/lib/cmdline.c.

 [ bp: Get rid of intermediary nostackp var and cleanup whitespace. ]

Fixes: aca20d546214 ("x86/mm: Add support to make use of Secure Memory Encryption")
Reported-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Coly Li <colyli@suse.de>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: "luto@kernel.org" <luto@kernel.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "mingo@redhat.com" <mingo@redhat.com>
Cc: "peterz@infradead.org" <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/155657657552.7116.18363762932464011367.stgit@sosrh3.amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/lib/Makefile | 12 ++++++++++++
 lib/Makefile          | 11 +++++++++++
 2 files changed, 23 insertions(+)

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index d435c89875c14..60b410ff31e8a 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -6,6 +6,18 @@
 # Produces uninteresting flaky coverage.
 KCOV_INSTRUMENT_delay.o	:= n
 
+# Early boot use of cmdline; don't instrument it
+ifdef CONFIG_AMD_MEM_ENCRYPT
+KCOV_INSTRUMENT_cmdline.o := n
+KASAN_SANITIZE_cmdline.o  := n
+
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_cmdline.o = -pg
+endif
+
+CFLAGS_cmdline.o := $(call cc-option, -fno-stack-protector)
+endif
+
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
 quiet_cmd_inat_tables = GEN     $@
diff --git a/lib/Makefile b/lib/Makefile
index b1ac450329033..4ea31c2d982df 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -17,6 +17,17 @@ KCOV_INSTRUMENT_list_debug.o := n
 KCOV_INSTRUMENT_debugobjects.o := n
 KCOV_INSTRUMENT_dynamic_debug.o := n
 
+# Early boot use of cmdline, don't instrument it
+ifdef CONFIG_AMD_MEM_ENCRYPT
+KASAN_SANITIZE_string.o := n
+
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_string.o = -pg
+endif
+
+CFLAGS_string.o := $(call cc-option, -fno-stack-protector)
+endif
+
 lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 rbtree.o radix-tree.o dump_stack.o timerqueue.o\
 	 idr.o int_sqrt.o extable.o \
-- 
2.20.1



