Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41A459A1ED
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349951AbiHSPqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349903AbiHSPqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:46:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF073E23;
        Fri, 19 Aug 2022 08:46:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E4BCB827F8;
        Fri, 19 Aug 2022 15:45:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84C4C433C1;
        Fri, 19 Aug 2022 15:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660923958;
        bh=BskiOcygZDnKCjEtWX7rGX+jjb5kSQVz2n/d/kxc8x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrYROKtdxZSkkJrjp4bmx2DjUaQjzZODxyQLy2VgNyl0GV70fCkP8u0IC8OiPu1KI
         uR/eilOHvgS7KoEif6r9N8XZBpY6mPa3yI5WR6tToNz1IYlDtpBesuD4XY6RuSNC32
         X7b7Cxi1/b4bjSkGS86ikJt+6l0yD5MTm6mii+u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 001/545] Makefile: link with -z noexecstack --no-warn-rwx-segments
Date:   Fri, 19 Aug 2022 17:36:11 +0200
Message-Id: <20220819153829.220984987@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
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

commit 0d362be5b14200b77ecc2127936a5ff82fbffe41 upstream.

Users of GNU ld (BFD) from binutils 2.39+ will observe multiple
instances of a new warning when linking kernels in the form:

  ld: warning: vmlinux: missing .note.GNU-stack section implies executable stack
  ld: NOTE: This behaviour is deprecated and will be removed in a future version of the linker
  ld: warning: vmlinux has a LOAD segment with RWX permissions

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
 Makefile |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Makefile
+++ b/Makefile
@@ -983,6 +983,11 @@ KBUILD_CFLAGS   += $(KCFLAGS)
 KBUILD_LDFLAGS_MODULE += --build-id=sha1
 LDFLAGS_vmlinux += --build-id=sha1
 
+KBUILD_LDFLAGS	+= -z noexecstack
+ifeq ($(CONFIG_LD_IS_BFD),y)
+KBUILD_LDFLAGS	+= $(call ld-option,--no-warn-rwx-segments)
+endif
+
 ifeq ($(CONFIG_STRIP_ASM_SYMS),y)
 LDFLAGS_vmlinux	+= $(call ld-option, -X,)
 endif


