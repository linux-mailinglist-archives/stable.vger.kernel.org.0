Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B894388CB7
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 13:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350529AbhESLZW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 07:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350339AbhESLZT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 07:25:19 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64AEC0613CE;
        Wed, 19 May 2021 04:23:59 -0700 (PDT)
Date:   Wed, 19 May 2021 11:23:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621423438;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iAXAUArqh6DsaVjCU+NUVObsM0uEAWgGBNbNgpdCKYs=;
        b=m0qIGMUU5Z/MSzvGLzA7mpLCfUSSIDx1XI/KJiQngQ5jWI8WfZVs0rZheTXmbTIqpwPdzY
        J5JBbwPXQQrzQwkUMRUfgHOLup7Uf2wjmWb66LGp4wD/P8hJG6nKIs8UfCMuiiWA0AZj1Q
        JLXR2NHCk4yjgpUM6GwncPwN6XuyvBxxWVCLqr77SjyJiXFvpVtPCTNmkZ/TWuCvqm05Ee
        tqpb+N7jpv9nGnBYuCkGND/rTvu5AwJUoH2iiWB+Uf8wAOPX8e3RbO3bsxlSiT29baVToF
        wmK8l6K8Paj2uHT0lSIwGSPsFxx2xuGmkLMbxLSvH0o7vZMMYci0oapgEK27qA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621423438;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iAXAUArqh6DsaVjCU+NUVObsM0uEAWgGBNbNgpdCKYs=;
        b=NCtb0Q8Tn13DufqbeNLZc8mfZliUINDOIKeDg5bqcCJODSx7u3Zk98SK0kpqjq9aSC0LiW
        6JDklMJyYJmXCWCg==
From:   "tip-bot2 for Nathan Chancellor" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/build: Fix location of '-plugin-opt=' flags
Cc:     Anthony Ruhier <aruhier@mailbox.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210518190106.60935-1-nathan@kernel.org>
References: <20210518190106.60935-1-nathan@kernel.org>
MIME-Version: 1.0
Message-ID: <162142343747.29796.17891708186447529713.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     0024430e920f2900654ad83cd081cf52e02a3ef5
Gitweb:        https://git.kernel.org/tip/0024430e920f2900654ad83cd081cf52e02a3ef5
Author:        Nathan Chancellor <nathan@kernel.org>
AuthorDate:    Tue, 18 May 2021 12:01:06 -07:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Wed, 19 May 2021 13:05:53 +02:00

x86/build: Fix location of '-plugin-opt=' flags

Commit b33fff07e3e3 ("x86, build: allow LTO to be selected") added a
couple of '-plugin-opt=' flags to KBUILD_LDFLAGS because the code model
and stack alignment are not stored in LLVM bitcode.

However, these flags were added to KBUILD_LDFLAGS prior to the
emulation flag assignment, which uses ':=', so they were overwritten
and never added to $(LD) invocations.

The absence of these flags caused misalignment issues in the
AMDGPU driver when compiling with CONFIG_LTO_CLANG, resulting in
general protection faults.

Shuffle the assignment below the initial one so that the flags are
properly passed along and all of the linker flags stay together.

At the same time, avoid any future issues with clobbering flags by
changing the emulation flag assignment to '+=' since KBUILD_LDFLAGS is
already defined with ':=' in the main Makefile before being exported for
modification here as a result of commit:

  ce99d0bf312d ("kbuild: clear LDFLAGS in the top Makefile")

Fixes: b33fff07e3e3 ("x86, build: allow LTO to be selected")
Reported-by: Anthony Ruhier <aruhier@mailbox.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Anthony Ruhier <aruhier@mailbox.org>
Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1374
Link: https://lore.kernel.org/r/20210518190106.60935-1-nathan@kernel.org
---
 arch/x86/Makefile | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index c77c5d8..3075294 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -178,11 +178,6 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
 	KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args,)
 endif
 
-ifdef CONFIG_LTO_CLANG
-KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
-		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
-endif
-
 # Workaround for a gcc prelease that unfortunately was shipped in a suse release
 KBUILD_CFLAGS += -Wno-sign-compare
 #
@@ -202,7 +197,12 @@ ifdef CONFIG_RETPOLINE
   endif
 endif
 
-KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
+KBUILD_LDFLAGS += -m elf_$(UTS_MACHINE)
+
+ifdef CONFIG_LTO_CLANG
+KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
+		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
+endif
 
 ifdef CONFIG_X86_NEED_RELOCS
 LDFLAGS_vmlinux := --emit-relocs --discard-none
