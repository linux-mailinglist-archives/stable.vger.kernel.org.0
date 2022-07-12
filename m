Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3635724CB
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbiGLTCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbiGLTBn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:01:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B543732EE4;
        Tue, 12 Jul 2022 11:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79D62B81BAB;
        Tue, 12 Jul 2022 18:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD6AC3411C;
        Tue, 12 Jul 2022 18:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651745;
        bh=Hj9y0EMpELMnc+8la5ocvDNDFnUT/82b6WQhamMX5Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sNAW9ie92JqWpXTdmJj4Fs9B95xP7Mjayk9Co0f19or1UpxUjLE5LMtupfGrN5sfA
         Hg+1idw4aUT8vYfAJo4uAv5y+DaZ9SUkkn6o4VeIzX9cT31igyzu2So33Vb/h4ujqb
         yVXV6ottdmiwbiBG1k0kJSxdptbPxUkUcb+2PEgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 5.15 12/78] x86/asm: Fixup odd GEN-for-each-reg.h usage
Date:   Tue, 12 Jul 2022 20:38:42 +0200
Message-Id: <20220712183239.345894286@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
References: <20220712183238.844813653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Peter Zijlstra <peterz@infradead.org>

commit b6d3d9944bd7c9e8c06994ead3c9952f673f2a66 upstream.

Currently GEN-for-each-reg.h usage leaves GEN defined, relying on any
subsequent usage to start with #undef, which is rude.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Tested-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/r/20211026120310.041792350@infradead.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/asm-prototypes.h |    2 +-
 arch/x86/lib/retpoline.S              |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/asm-prototypes.h
+++ b/arch/x86/include/asm/asm-prototypes.h
@@ -19,9 +19,9 @@ extern void cmpxchg8b_emu(void);
 
 #ifdef CONFIG_RETPOLINE
 
-#undef GEN
 #define GEN(reg) \
 	extern asmlinkage void __x86_indirect_thunk_ ## reg (void);
 #include <asm/GEN-for-each-reg.h>
+#undef GEN
 
 #endif /* CONFIG_RETPOLINE */
--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -55,10 +55,10 @@ SYM_FUNC_END(__x86_indirect_thunk_\reg)
 #define __EXPORT_THUNK(sym)	_ASM_NOKPROBE(sym); EXPORT_SYMBOL(sym)
 #define EXPORT_THUNK(reg)	__EXPORT_THUNK(__x86_indirect_thunk_ ## reg)
 
-#undef GEN
 #define GEN(reg) THUNK reg
 #include <asm/GEN-for-each-reg.h>
-
 #undef GEN
+
 #define GEN(reg) EXPORT_THUNK(reg)
 #include <asm/GEN-for-each-reg.h>
+#undef GEN


