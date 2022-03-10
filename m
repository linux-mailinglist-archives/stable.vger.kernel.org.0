Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 462CE4D4B07
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242856AbiCJOVP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244256AbiCJOTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:19:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC1A1704D0;
        Thu, 10 Mar 2022 06:15:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 024F261C67;
        Thu, 10 Mar 2022 14:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD90BC36AF5;
        Thu, 10 Mar 2022 14:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921751;
        bh=TulCEYJwDG+ZNjCzCFBRTe+9gAE+iWf3pD+bnXcqBTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwTMYIL2V+H90wccEOYxrBMcRZnGxlIHaFzL0vKJ7FzQqic4IW2ROFFIC0UCtZVRN
         jJe+qvSAFDNSMgj2c3dqIGEMVz6KCjjllM15RKatXC0KjmWwj2sCT+tR88VJDqlXhG
         +/rgiKT5JTBZvS8TCHYvsAI/YhgAzWALxwG8n+hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, WANG Chao <chao.wang@ucloud.cn>,
        Borislav Petkov <bp@suse.de>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Kees Cook <keescook@chromium.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linux-kbuild@vger.kernel.org, srinivas.eeda@oracle.com,
        x86-ml <x86@kernel.org>, Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 28/38] x86, modpost: Replace last remnants of RETPOLINE with CONFIG_RETPOLINE
Date:   Thu, 10 Mar 2022 15:13:41 +0100
Message-Id: <20220310140808.958165558@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.136149678@linuxfoundation.org>
References: <20220310140808.136149678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Chao <chao.wang@ucloud.cn>

commit e4f358916d528d479c3c12bd2fd03f2d5a576380 upstream.

Commit

  4cd24de3a098 ("x86/retpoline: Make CONFIG_RETPOLINE depend on compiler support")

replaced the RETPOLINE define with CONFIG_RETPOLINE checks. Remove the
remaining pieces.

 [ bp: Massage commit message. ]

Fixes: 4cd24de3a098 ("x86/retpoline: Make CONFIG_RETPOLINE depend on compiler support")
Signed-off-by: WANG Chao <chao.wang@ucloud.cn>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reviewed-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: Michal Marek <michal.lkml@markovi.net>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-kbuild@vger.kernel.org
Cc: srinivas.eeda@oracle.com
Cc: stable <stable@vger.kernel.org>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20181210163725.95977-1-chao.wang@ucloud.cn
[bwh: Backported to 4.9: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c   |    2 +-
 include/linux/compiler-gcc.h |    2 +-
 include/linux/module.h       |    2 +-
 scripts/mod/modpost.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -586,7 +586,7 @@ static enum spectre_v2_user_mitigation s
 static enum spectre_v2_user_mitigation spectre_v2_user_ibpb __ro_after_init =
 	SPECTRE_V2_USER_NONE;
 
-#ifdef RETPOLINE
+#ifdef CONFIG_RETPOLINE
 static bool spectre_v2_bad_module;
 
 bool retpoline_module_ok(bool has_retpoline)
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -107,7 +107,7 @@
 #define __weak		__attribute__((weak))
 #define __alias(symbol)	__attribute__((alias(#symbol)))
 
-#ifdef RETPOLINE
+#ifdef CONFIG_RETPOLINE
 #define __noretpoline __attribute__((indirect_branch("keep")))
 #endif
 
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -791,7 +791,7 @@ static inline void module_bug_finalize(c
 static inline void module_bug_cleanup(struct module *mod) {}
 #endif	/* CONFIG_GENERIC_BUG */
 
-#ifdef RETPOLINE
+#ifdef CONFIG_RETPOLINE
 extern bool retpoline_module_ok(bool has_retpoline);
 #else
 static inline bool retpoline_module_ok(bool has_retpoline)
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -2147,7 +2147,7 @@ static void add_intree_flag(struct buffe
 /* Cannot check for assembler */
 static void add_retpoline(struct buffer *b)
 {
-	buf_printf(b, "\n#ifdef RETPOLINE\n");
+	buf_printf(b, "\n#ifdef CONFIG_RETPOLINE\n");
 	buf_printf(b, "MODULE_INFO(retpoline, \"Y\");\n");
 	buf_printf(b, "#endif\n");
 }


