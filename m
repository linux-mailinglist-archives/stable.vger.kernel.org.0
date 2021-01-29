Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F723308C25
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhA2SHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbhA2SHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:07:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DDCC061573;
        Fri, 29 Jan 2021 10:06:51 -0800 (PST)
Date:   Fri, 29 Jan 2021 18:06:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1611943609;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xoKTnUoAAt8ABC/tZXbtJQcCJA5QY831zR+wgAnp0QU=;
        b=kl7qyfpXuZVCAK1mf/ah9L3pDjK6xVHAxdNHep3rTJDY+7E9MievMmWtljTV3pK7Vum8Ca
        FzH4vH/1KnxeedgvYSQDmKM7M1d92cSrYTRVXX6wDOicbz9g1+fhw1x3xxC9Npy6iugLph
        dd5LUHYPbFPUDb9wb1lv1/SWkwF/3boxM2yJuLSNJg1k6XuQgKW/6uhWq8qoAeVfTifZbD
        o7duv+0ncXK0rtLKGxjMGLb6PG126HMO5bPdjR8G4yvgGsO/oHSMdzCHZIMQnmfprNAatp
        szXnpM+P9s7vFGtHiSPKjfs30DU+ahwI7OumUS7Jcm8j7eEeudhQDBCXK/1LJg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1611943609;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xoKTnUoAAt8ABC/tZXbtJQcCJA5QY831zR+wgAnp0QU=;
        b=OWURa6Cd8jRIiSvWqiCOAKYhroCzUFOd7NCHvZAzg6uz92nUjZH7i2D7vU/ykXbcDEEtbQ
        rJ6exerW7nJE6cAw==
From:   "tip-bot2 for Josh Poimboeuf" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/build: Disable CET instrumentation in the kernel
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>, <stable@vger.kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210128215219.6kct3h2eiustncws@treble>
References: <20210128215219.6kct3h2eiustncws@treble>
MIME-Version: 1.0
Message-ID: <161194360841.23325.13929660311475931111.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     20bf2b378729c4a0366a53e2018a0b70ace94bcd
Gitweb:        https://git.kernel.org/tip/20bf2b378729c4a0366a53e2018a0b70ace94bcd
Author:        Josh Poimboeuf <jpoimboe@redhat.com>
AuthorDate:    Thu, 28 Jan 2021 15:52:19 -06:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Fri, 29 Jan 2021 18:41:06 +01:00

x86/build: Disable CET instrumentation in the kernel

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
---
 Makefile          | 6 ------
 arch/x86/Makefile | 3 +++
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index e0af7a4..51c2bf3 100644
--- a/Makefile
+++ b/Makefile
@@ -948,12 +948,6 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)
 # change __FILE__ to the relative path from the srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 
-# ensure -fcf-protection is disabled when using retpoline as it is
-# incompatible with -mindirect-branch=thunk-extern
-ifdef CONFIG_RETPOLINE
-KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
-endif
-
 # include additional Makefiles when needed
 include-y			:= scripts/Makefile.extrawarn
 include-$(CONFIG_KASAN)		+= scripts/Makefile.kasan
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 7116da3..5857917 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -120,6 +120,9 @@ else
 
         KBUILD_CFLAGS += -mno-red-zone
         KBUILD_CFLAGS += -mcmodel=kernel
+
+	# Intel CET isn't enabled in the kernel
+	KBUILD_CFLAGS += $(call cc-option,-fcf-protection=none)
 endif
 
 ifdef CONFIG_X86_X32
