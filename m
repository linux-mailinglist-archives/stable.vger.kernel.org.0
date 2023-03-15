Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4741B6BB1F2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjCOMbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbjCOMbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A604886144;
        Wed, 15 Mar 2023 05:30:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29E62B81DF6;
        Wed, 15 Mar 2023 12:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A01C433D2;
        Wed, 15 Mar 2023 12:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883442;
        bh=JTwlGXXkFOq5K2G1uJ2aGUWLFwpwAb9ftSSVR6mgz2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOt2+3duUApAFjcoUUkZootC4n+s1pD2mRTwGkCtRf4LASLSq8L0wHVOgfvHq5Byr
         VDTQe9EmltzUNBJQUo4FLMwCmxS2GwWO0q0GNaCYC5t2Bsht619RX3nmK+sCAXt1Yy
         7T07ajK7dlrCL72Mn3wfBCk3DApexGAeiq98Lvoo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andres Freund <andres@anarazel.de>,
        Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ben Hutchings <benh@debian.org>, Jiri Olsa <jolsa@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 5.15 138/145] tools bpftool: Fix compilation error with new binutils
Date:   Wed, 15 Mar 2023 13:13:24 +0100
Message-Id: <20230315115743.468829685@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andres Freund <andres@anarazel.de>

commit 600b7b26c07a070d0153daa76b3806c1e52c9e00 upstream.

binutils changed the signature of init_disassemble_info(), which now causes
compilation to fail for tools/bpf/bpftool/jit_disasm.c, e.g. on debian
unstable.

Relevant binutils commit:

  https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=60a3da00bd5407f07

Wire up the feature test and switch to init_disassemble_info_compat(),
which were introduced in prior commits, fixing the compilation failure.

I verified that bpftool can still disassemble bpf programs, both with an
old and new dis-asm.h API. There are no output changes for plain and json
formats. When comparing the output from old binutils (2.35)
to new bintuils with the patch (upstream snapshot) there are a few output
differences, but they are unrelated to this patch. An example hunk is:

     2f:	pop    %r14
     31:	pop    %r13
     33:	pop    %rbx
  -  34:	leaveq
  -  35:	retq
  +  34:	leave
  +  35:	ret

Signed-off-by: Andres Freund <andres@anarazel.de>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Ben Hutchings <benh@debian.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: bpf@vger.kernel.org
Link: http://lore.kernel.org/lkml/20220622181918.ykrs5rsnmx3og4sv@alap3.anarazel.de
Link: https://lore.kernel.org/r/20220801013834.156015-8-andres@anarazel.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/bpf/bpftool/Makefile     |    5 +++-
 tools/bpf/bpftool/jit_disasm.c |   42 +++++++++++++++++++++++++++++++++--------
 2 files changed, 38 insertions(+), 9 deletions(-)

--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -76,7 +76,7 @@ INSTALL ?= install
 RM ?= rm -f
 
 FEATURE_USER = .bpftool
-FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib libcap \
+FEATURE_TESTS = libbfd disassembler-four-args disassembler-init-styled reallocarray zlib libcap \
 	clang-bpf-co-re
 FEATURE_DISPLAY = libbfd disassembler-four-args zlib libcap \
 	clang-bpf-co-re
@@ -111,6 +111,9 @@ ifeq ($(feature-libcap), 1)
 CFLAGS += -DUSE_LIBCAP
 LIBS += -lcap
 endif
+ifeq ($(feature-disassembler-init-styled), 1)
+    CFLAGS += -DDISASM_INIT_STYLED
+endif
 
 include $(wildcard $(OUTPUT)*.d)
 
--- a/tools/bpf/bpftool/jit_disasm.c
+++ b/tools/bpf/bpftool/jit_disasm.c
@@ -24,6 +24,7 @@
 #include <sys/stat.h>
 #include <limits.h>
 #include <bpf/libbpf.h>
+#include <tools/dis-asm-compat.h>
 
 #include "json_writer.h"
 #include "main.h"
@@ -39,15 +40,12 @@ static void get_exec_path(char *tpath, s
 }
 
 static int oper_count;
-static int fprintf_json(void *out, const char *fmt, ...)
+static int printf_json(void *out, const char *fmt, va_list ap)
 {
-	va_list ap;
 	char *s;
 	int err;
 
-	va_start(ap, fmt);
 	err = vasprintf(&s, fmt, ap);
-	va_end(ap);
 	if (err < 0)
 		return -1;
 
@@ -73,6 +71,32 @@ static int fprintf_json(void *out, const
 	return 0;
 }
 
+static int fprintf_json(void *out, const char *fmt, ...)
+{
+	va_list ap;
+	int r;
+
+	va_start(ap, fmt);
+	r = printf_json(out, fmt, ap);
+	va_end(ap);
+
+	return r;
+}
+
+static int fprintf_json_styled(void *out,
+			       enum disassembler_style style __maybe_unused,
+			       const char *fmt, ...)
+{
+	va_list ap;
+	int r;
+
+	va_start(ap, fmt);
+	r = printf_json(out, fmt, ap);
+	va_end(ap);
+
+	return r;
+}
+
 void disasm_print_insn(unsigned char *image, ssize_t len, int opcodes,
 		       const char *arch, const char *disassembler_options,
 		       const struct btf *btf,
@@ -99,11 +123,13 @@ void disasm_print_insn(unsigned char *im
 	assert(bfd_check_format(bfdf, bfd_object));
 
 	if (json_output)
-		init_disassemble_info(&info, stdout,
-				      (fprintf_ftype) fprintf_json);
+		init_disassemble_info_compat(&info, stdout,
+					     (fprintf_ftype) fprintf_json,
+					     fprintf_json_styled);
 	else
-		init_disassemble_info(&info, stdout,
-				      (fprintf_ftype) fprintf);
+		init_disassemble_info_compat(&info, stdout,
+					     (fprintf_ftype) fprintf,
+					     fprintf_styled);
 
 	/* Update architecture info for offload. */
 	if (arch) {


