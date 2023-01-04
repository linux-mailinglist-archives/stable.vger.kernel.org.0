Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD3C65DF97
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 23:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjADWGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 17:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjADWGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 17:06:36 -0500
Received: from smtpout.efficios.com (unknown [IPv6:2607:5300:203:b2ee::31e5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8199B10B72
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1672869993;
        bh=LPLlJeCyff97fMHqrMzHSesN1PMALIuHvtIJvvzX1nE=;
        h=From:To:Cc:Subject:Date:From;
        b=fgjGv9xjSX+nao3FevDTjEillrHHbZZyPtns3c2n/yXK9kR47KIQdgDHQHsO5P1bp
         mCOFOMWXBUIoHJ/boWVrirR1AGj6TinQfpo7GbfSiicMiO+nAU6iFmk8nfFiDoqeMS
         TtTyr3oGWkJMEVv0fNlbAAquF3DMpq96OlFshQkX0XQDqllG3g1arEFk8grkaQXPMM
         w+4Zt7KtOAQqm3mIpdjOf8CUy4ztQqzM5jS8ck6QMfDMXCAFCJJhutG/N0bej7EW3u
         xfKsscxfIJ/b0/st6Lm7RlGfZyQqkSkaupxPbkoynzCrcHEEvmtO7xs9i9lwBImmcJ
         4ZigZfJKbjB9w==
Received: from multivac.lan (unknown [38.141.136.237])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4NnNwn4mKqzdGv;
        Wed,  4 Jan 2023 17:06:33 -0500 (EST)
From:   Michael Jeanson <mjeanson@efficios.com>
To:     stable@vger.kernel.org
Cc:     Michael Jeanson <mjeanson@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [PATCH] powerpc/ftrace: fix syscall tracing on PPC64_ELF_ABI_V1
Date:   Wed,  4 Jan 2023 17:06:02 -0500
Message-Id: <20230104220602.1301028-1-mjeanson@efficios.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RDNS_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ad050d2390fccb22aa3e6f65e11757ce7a5a7ca5 ]

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
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Michael Jeanson <mjeanson@efficios.com>
Link: https://lore.kernel.org/r/20221201161442.2127231-1-mjeanson@efficios.com
---
 arch/powerpc/include/asm/ftrace.h | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index 02d32d6422cd..ab9368094f64 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -74,17 +74,6 @@ struct dyn_arch_ftrace {
  * those.
  */
 #define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
-#ifdef PPC64_ELF_ABI_v1
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
@@ -93,7 +82,6 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 		(!strncmp(sym, "ppc32_", 6) && !strcmp(sym + 6, name + 4)) ||
 		(!strncmp(sym, "ppc64_", 6) && !strcmp(sym + 6, name + 4));
 }
-#endif /* PPC64_ELF_ABI_v1 */
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
 #if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)
-- 
2.39.0

