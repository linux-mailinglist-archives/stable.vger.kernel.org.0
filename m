Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8146959DB35
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352912AbiHWKXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354104AbiHWKUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF17816A9;
        Tue, 23 Aug 2022 02:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AC61B81C28;
        Tue, 23 Aug 2022 09:02:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01D5C433C1;
        Tue, 23 Aug 2022 09:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245323;
        bh=bLCLK6K8yuOyc8MbJTgMJSd+85QxC9+CZ5FW4UNulCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAFHrhBFS4/HAS2OCtNnR/m5dMDYaXE/915nUoxDxj4BAYaJyJJCPaSFk7E7rqhom
         RPuiITM903mwcA6TUM+T2Sxj4Uf6j7JppzOd6BJnAgY4pWLiwzwU4m31H1ScGF9XoJ
         p3DAR2/SYQuGMQd+N5YshgBN0cRXF5+aZTT4ry2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 002/287] x86: link vdso and boot with -z noexecstack --no-warn-rwx-segments
Date:   Tue, 23 Aug 2022 10:22:51 +0200
Message-Id: <20220823080100.348256127@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit ffcf9c5700e49c0aee42dcba9a12ba21338e8136 upstream.

Users of GNU ld (BFD) from binutils 2.39+ will observe multiple
instances of a new warning when linking kernels in the form:

  ld: warning: arch/x86/boot/pmjump.o: missing .note.GNU-stack section implies executable stack
  ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
  ld: warning: arch/x86/boot/compressed/vmlinux has a LOAD segment with RWX permissions

Generally, we would like to avoid the stack being executable.  Because
there could be a need for the stack to be executable, assembler sources
have to opt-in to this security feature via explicit creation of the
.note.GNU-stack feature (which compilers create by default) or command
line flag --noexecstack.  Or we can simply tell the linker the
production of such sections is irrelevant and to link the stack as
--noexecstack.

LLVM's LLD linker defaults to -z noexecstack, so this flag isn't
strictly necessary when linking with LLD, only BFD, but it doesn't hurt
to be explicit here for all linkers IMO.  --no-warn-rwx-segments is
currently BFD specific and only available in the current latest release,
so it's wrapped in an ld-option check.

While the kernel makes extensive usage of ELF sections, it doesn't use
permissions from ELF segments.

Link: https://lore.kernel.org/linux-block/3af4127a-f453-4cf7-f133-a181cce06f73@kernel.dk/
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=ba951afb99912da01a6e8434126b8fac7aa75107
Link: https://github.com/llvm/llvm-project/issues/57009
Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/boot/Makefile            |    2 +-
 arch/x86/boot/compressed/Makefile |    4 ++++
 arch/x86/entry/vdso/Makefile      |    2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -100,7 +100,7 @@ $(obj)/zoffset.h: $(obj)/compressed/vmli
 AFLAGS_header.o += -I$(objtree)/$(obj)
 $(obj)/header.o: $(obj)/zoffset.h
 
-LDFLAGS_setup.elf	:= -m elf_i386 -T
+LDFLAGS_setup.elf	:= -m elf_i386 -z noexecstack -T
 $(obj)/setup.elf: $(src)/setup.ld $(SETUP_OBJS) FORCE
 	$(call if_changed,ld)
 
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -57,6 +57,10 @@ else
 KBUILD_LDFLAGS += $(shell $(LD) --help 2>&1 | grep -q "\-z noreloc-overflow" \
 	&& echo "-z noreloc-overflow -pie --no-dynamic-linker")
 endif
+
+KBUILD_LDFLAGS += -z noexecstack
+KBUILD_LDFLAGS += $(call ld-option,--no-warn-rwx-segments)
+
 LDFLAGS_vmlinux := -T
 
 hostprogs-y	:= mkpiggy
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -172,7 +172,7 @@ quiet_cmd_vdso = VDSO    $@
 
 VDSO_LDFLAGS = -shared $(call ld-option, --hash-style=both) \
 	$(call ld-option, --build-id) $(call ld-option, --eh-frame-hdr) \
-	-Bsymbolic
+	-Bsymbolic -z noexecstack
 GCOV_PROFILE := n
 
 #


