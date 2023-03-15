Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FC46BB201
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjCOMcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbjCOMbp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D384896F2A;
        Wed, 15 Mar 2023 05:31:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39049B81E00;
        Wed, 15 Mar 2023 12:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B585C433D2;
        Wed, 15 Mar 2023 12:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883462;
        bh=O9G3Ukd/8dqvyDo7r2q/sW72hVNnJsrFDdx48qvwsmA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GEscC2Mh87NwTojGMokSkq5RcD0KR0hlPLOZpuemv0ZS4xJk0EzUSHvZt6yun2BPR
         wbcS5lcGF6B1gvyqObfMAHHZL0BX/oIxUFCDDfr7iYf2OdtQbrk8VkA+a6pk1CBw2g
         HgSSTk5ulGOU8IDUCUyL3UBVWp4BbU58snRtkQNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andres Freund <andres@anarazel.de>,
        Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ben Hutchings <benh@debian.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5.15 137/145] tools bpf_jit_disasm: Fix compilation error with new binutils
Date:   Wed, 15 Mar 2023 13:13:23 +0100
Message-Id: <20230315115743.439488716@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andres Freund <andres@anarazel.de>

commit 96ed066054abf11c7d3e106e3011a51f3f1227a3 upstream.

binutils changed the signature of init_disassemble_info(), which now causes
compilation to fail for tools/bpf/bpf_jit_disasm.c, e.g. on debian
unstable.

Relevant binutils commit:

  https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=60a3da00bd5407f07

Wire up the feature test and switch to init_disassemble_info_compat(),
which were introduced in prior commits, fixing the compilation failure.

I verified that bpf_jit_disasm can still disassemble bpf programs, both
with the old and new dis-asm.h API. With old binutils there's no change in
output before/after this patch. When comparing the output from old
binutils (2.35) to new bintuils with the patch (upstream snapshot) there
are a few output differences, but they are unrelated to this patch. An
example hunk is:

     f4:	mov    %r14,%rsi
     f7:	mov    %r15,%rdx
     fa:	mov    $0x2a,%ecx
  -  ff:	callq  0xffffffffea8c4988
  +  ff:	call   0xffffffffea8c4988
    104:	test   %rax,%rax
    107:	jge    0x0000000000000110
    109:	xor    %eax,%eax
  - 10b:	jmpq   0x0000000000000073
  + 10b:	jmp    0x0000000000000073
    110:	cmp    $0x16,%rax

However, I had to use an older kernel to generate the bpf_jit_enabled =
2 output, as that has been broken since 5.18 / 1022a5498f6f745c ("bpf,
x86_64: Use bpf_jit_binary_pack_alloc").

  https://lore.kernel.org/20220703030210.pmjft7qc2eajzi6c@alap3.anarazel.de

Signed-off-by: Andres Freund <andres@anarazel.de>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Ben Hutchings <benh@debian.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: bpf@vger.kernel.org
Link: http://lore.kernel.org/lkml/20220622181918.ykrs5rsnmx3og4sv@alap3.anarazel.de
Link: https://lore.kernel.org/r/20220801013834.156015-6-andres@anarazel.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/Makefile         |    5 ++++-
 tools/bpf/bpf_jit_disasm.c |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/tools/bpf/Makefile
+++ b/tools/bpf/Makefile
@@ -34,7 +34,7 @@ else
 endif
 
 FEATURE_USER = .bpf
-FEATURE_TESTS = libbfd disassembler-four-args
+FEATURE_TESTS = libbfd disassembler-four-args disassembler-init-styled
 FEATURE_DISPLAY = libbfd disassembler-four-args
 
 check_feat := 1
@@ -56,6 +56,9 @@ endif
 ifeq ($(feature-disassembler-four-args), 1)
 CFLAGS += -DDISASM_FOUR_ARGS_SIGNATURE
 endif
+ifeq ($(feature-disassembler-init-styled), 1)
+CFLAGS += -DDISASM_INIT_STYLED
+endif
 
 $(OUTPUT)%.yacc.c: $(srctree)/tools/bpf/%.y
 	$(QUIET_BISON)$(YACC) -o $@ -d $<
--- a/tools/bpf/bpf_jit_disasm.c
+++ b/tools/bpf/bpf_jit_disasm.c
@@ -28,6 +28,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <limits.h>
+#include <tools/dis-asm-compat.h>
 
 #define CMD_ACTION_SIZE_BUFFER		10
 #define CMD_ACTION_READ_ALL		3
@@ -64,7 +65,9 @@ static void get_asm_insns(uint8_t *image
 	assert(bfdf);
 	assert(bfd_check_format(bfdf, bfd_object));
 
-	init_disassemble_info(&info, stdout, (fprintf_ftype) fprintf);
+	init_disassemble_info_compat(&info, stdout,
+				     (fprintf_ftype) fprintf,
+				     fprintf_styled);
 	info.arch = bfd_get_arch(bfdf);
 	info.mach = bfd_get_mach(bfdf);
 	info.buffer = image;


