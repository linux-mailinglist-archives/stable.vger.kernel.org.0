Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EE665D529
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239579AbjADOKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbjADOKV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51223FA01
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:09:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D30561749
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2F0C433D2;
        Wed,  4 Jan 2023 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841385;
        bh=0cOE7mUav4KCyGnCSOHyaUBIPnMuWDT+Ij2sVJ4BEEU=;
        h=Subject:To:Cc:From:Date:From;
        b=bNCWE2hqpByEUKj6p7yjwXOhIQB7viS7O1XaWMn4S/kEVr+J2tlbzPgfwev03RFUB
         gn0pRq92DHjA+ZZZLGgUzc4VKX8Sc1cn/A0bhN4TJ+pWsp8r5FZvTVyfWYp0ONqgwS
         4O6a4cXdCAy56cALTLm47lreINBT58RtHuF4/764=
Subject: FAILED: patch "[PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1" failed to apply to 5.10-stable tree
To:     mjeanson@efficios.com, mathieu.desnoyers@efficios.com,
        mpe@ellerman.id.au
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:09:34 +0100
Message-ID: <167284137419223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

ad050d2390fc ("powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1")
7d40aff8213c ("powerpc: Replace PPC64_ELF_ABI_v{1/2} by CONFIG_PPC64_ELF_ABI_V{1/2}")
7001052160d1 ("Merge tag 'x86_core_for_5.18_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ad050d2390fccb22aa3e6f65e11757ce7a5a7ca5 Mon Sep 17 00:00:00 2001
From: Michael Jeanson <mjeanson@efficios.com>
Date: Thu, 1 Dec 2022 11:14:42 -0500
Subject: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1

In v5.7 the powerpc syscall entry/exit logic was rewritten in C, on
PPC64_ELF_ABI_V1 this resulted in the symbols in the syscall table
changing from their dot prefixed variant to the non-prefixed ones.

Since ftrace prefixes a dot to the syscall names when matching them to
build its syscall event list, this resulted in no syscall events being
available.

Remove the PPC64_ELF_ABI_V1 specific version of
arch_syscall_match_sym_name to have the same behavior across all powerpc
variants.

Fixes: 68b34588e202 ("powerpc/64/sycall: Implement syscall entry/exit logic in C")
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221201161442.2127231-1-mjeanson@efficios.com

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index ade406dc6504..441c5f08258b 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -71,17 +71,6 @@ void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
  * those.
  */
 #define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
-#ifdef CONFIG_PPC64_ELF_ABI_V1
-static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
-{
-	/* We need to skip past the initial dot, and the __se_sys alias */
-	return !strcmp(sym + 1, name) ||
-		(!strncmp(sym, ".__se_sys", 9) && !strcmp(sym + 6, name)) ||
-		(!strncmp(sym, ".ppc_", 5) && !strcmp(sym + 5, name + 4)) ||
-		(!strncmp(sym, ".ppc32_", 7) && !strcmp(sym + 7, name + 4)) ||
-		(!strncmp(sym, ".ppc64_", 7) && !strcmp(sym + 7, name + 4));
-}
-#else
 static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
 {
 	return !strcmp(sym, name) ||
@@ -90,7 +79,6 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 		(!strncmp(sym, "ppc32_", 6) && !strcmp(sym + 6, name + 4)) ||
 		(!strncmp(sym, "ppc64_", 6) && !strcmp(sym + 6, name + 4));
 }
-#endif /* CONFIG_PPC64_ELF_ABI_V1 */
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
 #if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)

