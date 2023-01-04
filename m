Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D960365D866
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbjADQOM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:14:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbjADQNy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:13:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0A726F4
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0B87B81730
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3F0C433EF;
        Wed,  4 Jan 2023 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848830;
        bh=9MkbbxsK9aL9abwNpbWHTyHy3Sm/cMBJ8YxmLMLB6Ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b6k5WSJzSkE6LVQHtBn7D3WXxk64KDglrPVYbrukvRb9EchXYZraiDA/Xml8n09yT
         emXzSnRx8f4gcw/qAJ3u36v1FYn/VGtQ9nj+ZC83n8icWpLUBgYZ66JG/DPc5y7dhi
         kiVLhoy/bf0m9WO46hlSAc2D9zRrk6zQLLBZANYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Jeanson <mjeanson@efficios.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.1 091/207] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Date:   Wed,  4 Jan 2023 17:05:49 +0100
Message-Id: <20230104160514.817893156@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Jeanson <mjeanson@efficios.com>

commit ad050d2390fccb22aa3e6f65e11757ce7a5a7ca5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ftrace.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -64,17 +64,6 @@ void ftrace_graph_func(unsigned long ip,
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
@@ -83,7 +72,6 @@ static inline bool arch_syscall_match_sy
 		(!strncmp(sym, "ppc32_", 6) && !strcmp(sym + 6, name + 4)) ||
 		(!strncmp(sym, "ppc64_", 6) && !strcmp(sym + 6, name + 4));
 }
-#endif /* CONFIG_PPC64_ELF_ABI_V1 */
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
 #if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)


