Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F81F5F270E
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJBXJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 19:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiJBXIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 19:08:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B86D48E8B;
        Sun,  2 Oct 2022 16:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABBE160F1B;
        Sun,  2 Oct 2022 22:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51814C433C1;
        Sun,  2 Oct 2022 22:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751145;
        bh=K+Hk7w9wTcA9CRYbyUi0ingfM/N1GEAxCU+yw0HRkwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrwm10nygtwlSP9ZhRFU4Z9kfSGn3UwsfBqZtRLwUn9Gatw0zgOsLiWtvZHf9vc/6
         YV5Ednj0Fmjsv282NskogkMPWfKyhTmXDkQYWQ4UteCo6fPibqGl/UMgpEaUUrlqAj
         6SnghxyCKQJPYNo2jaU7YUbPJnhmzTO/6XnoDha8HlnHubGqhyW9Za565B74ADgJ2E
         JgLjfv46bIpuOr7ij+8sHX4QrpFvqMbfW/phJlc6N7gGKvhu6IGrSdeh3lRn5qV1yF
         aP0w6w0fGlNs01shwt0TVB6/XCxQgg6isRYisIemno6FO6cbrXHe+h7S7sX31nr1tJ
         1L0l1DbbCZRRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Gow <davidgow@google.com>,
        Lukas Straub <lukasstraub2@web.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, andreyknvl@gmail.com,
        dvyukov@google.com, trishalfonso@google.com,
        linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 11/14] arch: um: Mark the stack non-executable to fix a binutils warning
Date:   Sun,  2 Oct 2022 18:51:52 -0400
Message-Id: <20221002225155.239480-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225155.239480-1-sashal@kernel.org>
References: <20221002225155.239480-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Gow <davidgow@google.com>

[ Upstream commit bd71558d585ac61cfd799db7f25e78dca404dd7a ]

Since binutils 2.39, ld will print a warning if any stack section is
executable, which is the default for stack sections on files without a
.note.GNU-stack section.

This was fixed for x86 in commit ffcf9c5700e4 ("x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments"),
but remained broken for UML, resulting in several warnings:

/usr/bin/ld: warning: arch/x86/um/vdso/vdso.o: missing .note.GNU-stack section implies executable stack
/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
/usr/bin/ld: warning: .tmp_vmlinux.kallsyms1 has a LOAD segment with RWX permissions
/usr/bin/ld: warning: .tmp_vmlinux.kallsyms1.o: missing .note.GNU-stack section implies executable stack
/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
/usr/bin/ld: warning: .tmp_vmlinux.kallsyms2 has a LOAD segment with RWX permissions
/usr/bin/ld: warning: .tmp_vmlinux.kallsyms2.o: missing .note.GNU-stack section implies executable stack
/usr/bin/ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
/usr/bin/ld: warning: vmlinux has a LOAD segment with RWX permissions

Link both the VDSO and vmlinux with -z noexecstack, fixing the warnings
about .note.GNU-stack sections. In addition, pass --no-warn-rwx-segments
to dodge the remaining warnings about LOAD segments with RWX permissions
in the kallsyms objects. (Note that this flag is apparently not
available on lld, so hide it behind a test for BFD, which is what the
x86 patch does.)

Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ffcf9c5700e49c0aee42dcba9a12ba21338e8136
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=ba951afb99912da01a6e8434126b8fac7aa75107
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Lukas Straub <lukasstraub2@web.de>
Tested-by: Lukas Straub <lukasstraub2@web.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Makefile          | 8 ++++++++
 arch/x86/um/vdso/Makefile | 2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 1cea46ff9bb7..775615141339 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -131,10 +131,18 @@ export LDS_ELF_FORMAT := $(ELF_FORMAT)
 # The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
 
+# Avoid binutils 2.39+ warnings by marking the stack non-executable and
+# ignorning warnings for the kallsyms sections.
+LDFLAGS_EXECSTACK = -z noexecstack
+ifeq ($(CONFIG_LD_IS_BFD),y)
+LDFLAGS_EXECSTACK += $(call ld-option,--no-warn-rwx-segments)
+endif
+
 LD_FLAGS_CMDLINE = $(foreach opt,$(KBUILD_LDFLAGS),-Wl,$(opt))
 
 # Used by link-vmlinux.sh which has special support for um link
 export CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
+export LDFLAGS_vmlinux := $(LDFLAGS_EXECSTACK)
 
 # When cleaning we don't include .config, so we don't include
 # TT or skas makefiles and don't clean skas_ptregs.h.
diff --git a/arch/x86/um/vdso/Makefile b/arch/x86/um/vdso/Makefile
index 5943387e3f35..5ca366e15c76 100644
--- a/arch/x86/um/vdso/Makefile
+++ b/arch/x86/um/vdso/Makefile
@@ -62,7 +62,7 @@ quiet_cmd_vdso = VDSO    $@
 		       -Wl,-T,$(filter %.lds,$^) $(filter %.o,$^) && \
 		 sh $(srctree)/$(src)/checkundef.sh '$(NM)' '$@'
 
-VDSO_LDFLAGS = -fPIC -shared -Wl,--hash-style=sysv
+VDSO_LDFLAGS = -fPIC -shared -Wl,--hash-style=sysv -z noexecstack
 GCOV_PROFILE := n
 
 #
-- 
2.35.1

