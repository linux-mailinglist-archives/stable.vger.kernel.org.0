Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E4331378E
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbhBHP1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:34484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhBHPSs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:18:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9FF664F02;
        Mon,  8 Feb 2021 15:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797132;
        bh=/lB1CqoITpXl91Hx5Owmq4+rsmXz8vTSzRSAOHty2oI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uYqI7/VSUHPfQPu/7YwQAaqd2KyLaFztC8DVKfKpFU+BFZ5P0KcmHXHcphT1jaGVA
         T6ZqmC1siOMZZHxtvLLkPSFGFn+jQfa3KE1wGpMZiKizI5ioDm25UG3AQJHliQrUhu
         9dIJJRxMvLL3WKpAlpH1ArYHDOyz+o2neSfrJnsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Seth Forshee <seth.forshee@canonical.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 5.4 54/65] x86/build: Disable CET instrumentation in the kernel
Date:   Mon,  8 Feb 2021 16:01:26 +0100
Message-Id: <20210208145812.313985463@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145810.230485165@linuxfoundation.org>
References: <20210208145810.230485165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 20bf2b378729c4a0366a53e2018a0b70ace94bcd upstream.

With retpolines disabled, some configurations of GCC, and specifically
the GCC versions 9 and 10 in Ubuntu will add Intel CET instrumentation
to the kernel by default. That breaks certain tracing scenarios by
adding a superfluous ENDBR64 instruction before the fentry call, for
functions which can be called indirectly.

CET instrumentation isn't currently necessary in the kernel, as CET is
only supported in user space. Disable it unconditionally and move it
into the x86's Makefile as CET/CFI... enablement should be a per-arch
decision anyway.

 [ bp: Massage and extend commit message. ]

Fixes: 29be86d7f9cb ("kbuild: add -fcf-protection=none when using retpoline flags")
Reported-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Tested-by: Nikolay Borisov <nborisov@suse.com>
Cc: <stable@vger.kernel.org>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Link: https://lkml.kernel.org/r/20210128215219.6kct3h2eiustncws@treble
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile          |    6 ------
 arch/x86/Makefile |    3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -920,12 +920,6 @@ KBUILD_CFLAGS   += $(call cc-option,-Wer
 # change __FILE__ to the relative path from the srctree
 KBUILD_CFLAGS	+= $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 
-# ensure -fcf-protection is disabled when using retpoline as it is
-# incompatible with -mindirect-branch=thunk-extern
-ifdef CONFIG_RETPOLINE
-KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
-endif
-
 include scripts/Makefile.kasan
 include scripts/Makefile.extrawarn
 include scripts/Makefile.ubsan
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -131,6 +131,9 @@ else
 
         KBUILD_CFLAGS += -mno-red-zone
         KBUILD_CFLAGS += -mcmodel=kernel
+
+	# Intel CET isn't enabled in the kernel
+	KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
 endif
 
 ifdef CONFIG_X86_X32


