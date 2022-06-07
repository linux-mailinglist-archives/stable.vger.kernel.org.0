Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFFF5416AF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377444AbiFGUyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378455AbiFGUwI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:52:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EAA2004F2;
        Tue,  7 Jun 2022 11:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B734B82182;
        Tue,  7 Jun 2022 18:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753B6C385A2;
        Tue,  7 Jun 2022 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627333;
        bh=RgCuTiD3kozF3mlD2ezwdETxBXaIcFW+5/2P0Urfp64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x++LNaYPkikP0X5pDogmom/6ZtFBazieFD8gEu+AyIdqIslTa0/TBOnRIwvF3dXcW
         msz2FgvAGOuzLI5ZWXYb/K/o7NAGjFlZDrQUszx6NVoLnU1oa3+Lqcuq2QflnIN8dW
         Cq03KXcptqbto0JqfcKypXY8OP2RZH4S07bHglxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 703/772] Kconfig: Add option for asm goto w/ tied outputs to workaround clang-13 bug
Date:   Tue,  7 Jun 2022 19:04:55 +0200
Message-Id: <20220607165009.763815047@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 1aa0e8b144b6474c4914439d232d15bfe883636b upstream.

Add a config option to guard (future) usage of asm_volatile_goto() that
includes "tied outputs", i.e. "+" constraints that specify both an input
and output parameter.  clang-13 has a bug[1] that causes compilation of
such inline asm to fail, and KVM wants to use a "+m" constraint to
implement a uaccess form of CMPXCHG[2].  E.g. the test code fails with

  <stdin>:1:29: error: invalid operand in inline asm: '.long (${1:l}) - .'
  int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }
                            ^
  <stdin>:1:29: error: unknown token in expression
  <inline asm>:1:9: note: instantiated into assembly here
          .long () - .
                 ^
  2 errors generated.

on clang-13, but passes on gcc (with appropriate asm goto support).  The
bug is fixed in clang-14, but won't be backported to clang-13 as the
changes are too invasive/risky.

gcc also had a similar bug[3], fixed in gcc-11, where gcc failed to
account for its behavior of assigning two numbers to tied outputs (one
for input, one for output) when evaluating symbolic references.

[1] https://github.com/ClangBuiltLinux/linux/issues/1512
[2] https://lore.kernel.org/all/YfMruK8%2F1izZ2VHS@google.com
[3] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=98096

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220202004945.2540433-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig |    5 +++++
 1 file changed, 5 insertions(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -77,6 +77,11 @@ config CC_HAS_ASM_GOTO_OUTPUT
 	depends on CC_HAS_ASM_GOTO
 	def_bool $(success,echo 'int foo(int x) { asm goto ("": "=r"(x) ::: bar); return x; bar: return 0; }' | $(CC) -x c - -c -o /dev/null)
 
+config CC_HAS_ASM_GOTO_TIED_OUTPUT
+	depends on CC_HAS_ASM_GOTO_OUTPUT
+	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
+	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
+
 config TOOLS_SUPPORT_RELR
 	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
 


