Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D060E3CE36B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244296AbhGSPh6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:37:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348273AbhGSPfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB1EC6141E;
        Mon, 19 Jul 2021 16:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711212;
        bh=wb24qyQbbZ4G0BR10Lg7jOKybgjnlwOQVtC4b9/RbVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7BXS5zCBWAZWqUtQcm1ZuGm/Lk+7K7Iy8Ohf5NTbt37TZ9xRLuHXq66bdBxJNVlO
         rC4V733ZrFpo3tzbaHcCbSxGsf7+zMNpjVLnxkbkDMowxbZSNM+MocZ0j3XYgLv3k7
         u8y1RfpbV+X2GIMST1fIprLUSYbe7RsVdn9oZRAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brian Cain <bcain@codeaurora.org>,
        Oliver Glitta <glittao@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 268/351] hexagon: handle {,SOFT}IRQENTRY_TEXT in linker script
Date:   Mon, 19 Jul 2021 16:53:34 +0200
Message-Id: <20210719144953.809284731@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 6fef087d0d37ba7dba8f3d75566eb4c256cd6742 ]

Patch series "hexagon: Fix build error with CONFIG_STACKDEPOT and select CONFIG_ARCH_WANT_LD_ORPHAN_WARN".

This series fixes an error with ARCH=hexagon that was pointed out by the
patch "mm/slub: use stackdepot to save stack trace in objects".

The first patch fixes that error by handling the '.irqentry.text' and
'.softirqentry.text' sections.

The second patch switches Hexagon over to the common DISCARDS macro, which
should have been done when Hexagon was merged into the tree to match
commit 023bf6f1b8bf ("linker script: unify usage of discard definition").

The third patch selects CONFIG_ARCH_WANT_LD_ORPHAN_WARN so that something
like this does not happen again.

This patch (of 3):

Patch "mm/slub: use stackdepot to save stack trace in objects" in -mm
selects CONFIG_STACKDEPOT when CONFIG_STACKTRACE_SUPPORT is selected and
CONFIG_STACKDEPOT requires IRQENTRY_TEXT and SOFTIRQENTRY_TEXT to be
handled after commit 505a0ef15f96 ("kasan: stackdepot: move
filter_irq_stacks() to stackdepot.c") due to the use of the
__{,soft}irqentry_text_{start,end} section symbols.  If those sections are
not handled, the build is broken.

$ make ARCH=hexagon CROSS_COMPILE=hexagon-linux- LLVM=1 LLVM_IAS=1 defconfig all
...
ld.lld: error: undefined symbol: __irqentry_text_start
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a

ld.lld: error: undefined symbol: __irqentry_text_end
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a

ld.lld: error: undefined symbol: __softirqentry_text_start
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a

ld.lld: error: undefined symbol: __softirqentry_text_end
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
>>> referenced by stackdepot.c
>>>               stackdepot.o:(filter_irq_stacks) in archive lib/built-in.a
...

Add these sections to the Hexagon linker script so the build continues to
work.  ld.lld's orphan section warning would have caught this prior to the
-mm commit mentioned above:

ld.lld: warning: kernel/built-in.a(softirq.o):(.softirqentry.text) is being placed in '.softirqentry.text'
ld.lld: warning: kernel/built-in.a(softirq.o):(.softirqentry.text) is being placed in '.softirqentry.text'
ld.lld: warning: kernel/built-in.a(softirq.o):(.softirqentry.text) is being placed in '.softirqentry.text'

Link: https://lkml.kernel.org/r/20210521011239.1332345-1-nathan@kernel.org
Link: https://lkml.kernel.org/r/20210521011239.1332345-2-nathan@kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1381
Fixes: 505a0ef15f96 ("kasan: stackdepot: move filter_irq_stacks() to stackdepot.c")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Brian Cain <bcain@codeaurora.org>
Cc: Oliver Glitta <glittao@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/hexagon/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/hexagon/kernel/vmlinux.lds.S b/arch/hexagon/kernel/vmlinux.lds.S
index 35b18e55eae8..20f19539c5fc 100644
--- a/arch/hexagon/kernel/vmlinux.lds.S
+++ b/arch/hexagon/kernel/vmlinux.lds.S
@@ -38,6 +38,8 @@ SECTIONS
 	.text : AT(ADDR(.text)) {
 		_text = .;
 		TEXT_TEXT
+		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		SCHED_TEXT
 		CPUIDLE_TEXT
 		LOCK_TEXT
-- 
2.30.2



