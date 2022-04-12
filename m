Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707304FD94F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377596AbiDLHum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359414AbiDLHnB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:43:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94317255AE;
        Tue, 12 Apr 2022 00:23:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F69BB81B13;
        Tue, 12 Apr 2022 07:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A134DC385A1;
        Tue, 12 Apr 2022 07:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748183;
        bh=jdSrlme+ldB8gp5g95tgqulfRXTKB43uz9/V2NDGTck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEqfOneQftJvc6t7KHCzMdWGm5Cdhg/HPQNsnv64DwPj34k1M3sk7wEMxwqO3t1Sk
         yNWL2FEGRgoU6jYPAiQIzWYNEUGO5tpD52ZZiz+DjGIqPrbD55lq7GVygtX1gW3qlM
         uoNQCzjE6zyxNsDGUMhJQdgoEWw68cAA8fwJb/QE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 5.17 329/343] x86/bug: Prevent shadowing in __WARN_FLAGS
Date:   Tue, 12 Apr 2022 08:32:27 +0200
Message-Id: <20220412063000.815412501@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

commit 9ce02f0fc68326dd1f87a0a3a4c6ae7fdd39e6f6 upstream.

The macro __WARN_FLAGS() uses a local variable named "f". This being a
common name, there is a risk of shadowing other variables.

For example, GCC would yield:

| In file included from ./include/linux/bug.h:5,
|                  from ./include/linux/cpumask.h:14,
|                  from ./arch/x86/include/asm/cpumask.h:5,
|                  from ./arch/x86/include/asm/msr.h:11,
|                  from ./arch/x86/include/asm/processor.h:22,
|                  from ./arch/x86/include/asm/timex.h:5,
|                  from ./include/linux/timex.h:65,
|                  from ./include/linux/time32.h:13,
|                  from ./include/linux/time.h:60,
|                  from ./include/linux/stat.h:19,
|                  from ./include/linux/module.h:13,
|                  from virt/lib/irqbypass.mod.c:1:
| ./include/linux/rcupdate.h: In function 'rcu_head_after_call_rcu':
| ./arch/x86/include/asm/bug.h:80:21: warning: declaration of 'f' shadows a parameter [-Wshadow]
|    80 |         __auto_type f = BUGFLAG_WARNING|(flags);                \
|       |                     ^
| ./include/asm-generic/bug.h:106:17: note: in expansion of macro '__WARN_FLAGS'
|   106 |                 __WARN_FLAGS(BUGFLAG_ONCE |                     \
|       |                 ^~~~~~~~~~~~
| ./include/linux/rcupdate.h:1007:9: note: in expansion of macro 'WARN_ON_ONCE'
|  1007 |         WARN_ON_ONCE(func != (rcu_callback_t)~0L);
|       |         ^~~~~~~~~~~~
| In file included from ./include/linux/rbtree.h:24,
|                  from ./include/linux/mm_types.h:11,
|                  from ./include/linux/buildid.h:5,
|                  from ./include/linux/module.h:14,
|                  from virt/lib/irqbypass.mod.c:1:
| ./include/linux/rcupdate.h:1001:62: note: shadowed declaration is here
|  1001 | rcu_head_after_call_rcu(struct rcu_head *rhp, rcu_callback_t f)
|       |                                               ~~~~~~~~~~~~~~~^

For reference, sparse also warns about it, c.f. [1].

This patch renames the variable from f to __flags (with two underscore
prefixes as suggested in the Linux kernel coding style [2]) in order
to prevent collisions.

[1] https://lore.kernel.org/all/CAFGhKbyifH1a+nAMCvWM88TK6fpNPdzFtUXPmRGnnQeePV+1sw@mail.gmail.com/

[2] Linux kernel coding style, section 12) Macros, Enums and RTL,
paragraph 5) namespace collisions when defining local variables in
macros resembling functions
https://www.kernel.org/doc/html/latest/process/coding-style.html#macros-enums-and-rtl

Fixes: bfb1a7c91fb7 ("x86/bug: Merge annotate_reachable() into_BUG_FLAGS() asm")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lkml.kernel.org/r/20220324023742.106546-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/bug.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -77,9 +77,9 @@ do {								\
  */
 #define __WARN_FLAGS(flags)					\
 do {								\
-	__auto_type f = BUGFLAG_WARNING|(flags);		\
+	__auto_type __flags = BUGFLAG_WARNING|(flags);		\
 	instrumentation_begin();				\
-	_BUG_FLAGS(ASM_UD2, f, ASM_REACHABLE);			\
+	_BUG_FLAGS(ASM_UD2, __flags, ASM_REACHABLE);		\
 	instrumentation_end();					\
 } while (0)
 


