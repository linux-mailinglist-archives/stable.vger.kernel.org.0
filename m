Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08BF83136F8
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhBHPSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:18:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232699AbhBHPI5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:08:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41C7564ECB;
        Mon,  8 Feb 2021 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612796806;
        bh=8nH3qRivrO5E+F6y1Ttt6BSVl0UawVdXt1IkzWevB7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2cbd6n2DtKG9nuovLGwYn8wRrP4leE+GtbjMEQ3wpjSc41VVYGavhkegEApGWKwxL
         NFEpjO63zib3du3EbTYAzScdhyleiCUpenYMQhu76LzOZyGCW2clZruoQ8DNFcbmCv
         kGph+A3+9WOjKmCEKonzk0g5MGPKxKqnAYMdz5G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Seth Forshee <seth.forshee@canonical.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 4.14 26/30] x86/build: Disable CET instrumentation in the kernel
Date:   Mon,  8 Feb 2021 16:01:12 +0100
Message-Id: <20210208145806.298526525@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145805.239714726@linuxfoundation.org>
References: <20210208145805.239714726@linuxfoundation.org>
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
@@ -844,12 +844,6 @@ KBUILD_CFLAGS   += $(call cc-option,-Wer
 # change __FILE__ to the relative path from the srctree
 KBUILD_CFLAGS	+= $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 
-# ensure -fcf-protection is disabled when using retpoline as it is
-# incompatible with -mindirect-branch=thunk-extern
-ifdef CONFIG_RETPOLINE
-KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
-endif
-
 # use the deterministic mode of AR if available
 KBUILD_ARFLAGS := $(call ar-option,D)
 
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -138,6 +138,9 @@ else
         KBUILD_CFLAGS += -mno-red-zone
         KBUILD_CFLAGS += -mcmodel=kernel
 
+	# Intel CET isn't enabled in the kernel
+	KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
+
         # -funit-at-a-time shrinks the kernel .text considerably
         # unfortunately it makes reading oopses harder.
         KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)


