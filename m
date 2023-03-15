Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D476F6BB1E9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbjCOMbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjCOMbS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C97265C5C;
        Wed, 15 Mar 2023 05:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1F9261ABD;
        Wed, 15 Mar 2023 12:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE49EC433D2;
        Wed, 15 Mar 2023 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883421;
        bh=9GwR4noRDdKjE1WA+NeI4fLcyCRUhvsv9P/QRhUzgW0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+MSAOvF0+vtjBtv92XlJe14erKWltMNQcpqk0cN8U8eALOs4bO7glXDQHt+lpw7C
         RE8m2VO71RBFcOW0HXtQVwSCI3gKxJRSF/9Q2hzB91eK7GiuHuI7Gqj63lH2nCvndn
         LFSf+aaZQhWTH1riCMYMRZQnb04copVQpJhkxIMM=
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
Subject: [PATCH 5.15 136/145] tools perf: Fix compilation error with new binutils
Date:   Wed, 15 Mar 2023 13:13:22 +0100
Message-Id: <20230315115743.410504194@linuxfoundation.org>
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

commit 83aa0120487e8bc3f231e72c460add783f71f17c upstream.

binutils changed the signature of init_disassemble_info(), which now causes
compilation failures for tools/perf/util/annotate.c, e.g. on debian
unstable.

Relevant binutils commit:

  https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=60a3da00bd5407f07

Wire up the feature test and switch to init_disassemble_info_compat(),
which were introduced in prior commits, fixing the compilation failure.

I verified that perf can still disassemble bpf programs by using bpftrace
under load, recording a perf trace, and then annotating the bpf "function"
with and without the changes. With old binutils there's no change in output
before/after this patch. When comparing the output from old binutils (2.35)
to new bintuils with the patch (upstream snapshot) there are a few output
differences, but they are unrelated to this patch. An example hunk is:

       1.15 :   55:mov    %rbp,%rdx
       0.00 :   58:add    $0xfffffffffffffff8,%rdx
       0.00 :   5c:xor    %ecx,%ecx
  -    1.03 :   5e:callq  0xffffffffe12aca3c
  +    1.03 :   5e:call   0xffffffffe12aca3c
       0.00 :   63:xor    %eax,%eax
  -    2.18 :   65:leaveq
  -    2.82 :   66:retq
  +    2.18 :   65:leave
  +    2.82 :   66:ret

Signed-off-by: Andres Freund <andres@anarazel.de>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Ben Hutchings <benh@debian.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: bpf@vger.kernel.org
Link: http://lore.kernel.org/lkml/20220622181918.ykrs5rsnmx3og4sv@alap3.anarazel.de
Link: https://lore.kernel.org/r/20220801013834.156015-5-andres@anarazel.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/Makefile.config |    8 ++++++++
 tools/perf/util/annotate.c |    7 ++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -296,6 +296,7 @@ FEATURE_CHECK_LDFLAGS-libpython := $(PYT
 FEATURE_CHECK_LDFLAGS-libaio = -lrt
 
 FEATURE_CHECK_LDFLAGS-disassembler-four-args = -lbfd -lopcodes -ldl
+FEATURE_CHECK_LDFLAGS-disassembler-init-styled = -lbfd -lopcodes -ldl
 
 CORE_CFLAGS += -fno-omit-frame-pointer
 CORE_CFLAGS += -ggdb3
@@ -872,13 +873,16 @@ ifndef NO_LIBBFD
     ifeq ($(feature-libbfd-liberty), 1)
       EXTLIBS += -lbfd -lopcodes -liberty
       FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -ldl
+      FEATURE_CHECK_LDFLAGS-disassembler-init-styled += -liberty -ldl
     else
       ifeq ($(feature-libbfd-liberty-z), 1)
         EXTLIBS += -lbfd -lopcodes -liberty -lz
         FEATURE_CHECK_LDFLAGS-disassembler-four-args += -liberty -lz -ldl
+        FEATURE_CHECK_LDFLAGS-disassembler-init-styled += -liberty -lz -ldl
       endif
     endif
     $(call feature_check,disassembler-four-args)
+    $(call feature_check,disassembler-init-styled)
   endif
 
   ifeq ($(feature-libbfd-buildid), 1)
@@ -992,6 +996,10 @@ ifeq ($(feature-disassembler-four-args),
     CFLAGS += -DDISASM_FOUR_ARGS_SIGNATURE
 endif
 
+ifeq ($(feature-disassembler-init-styled), 1)
+    CFLAGS += -DDISASM_INIT_STYLED
+endif
+
 ifeq (${IS_64_BIT}, 1)
   ifndef NO_PERF_READ_VDSO32
     $(call feature_check,compile-32)
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1694,6 +1694,7 @@ fallback:
 #include <bpf/btf.h>
 #include <bpf/libbpf.h>
 #include <linux/btf.h>
+#include <tools/dis-asm-compat.h>
 
 static int symbol__disassemble_bpf(struct symbol *sym,
 				   struct annotate_args *args)
@@ -1736,9 +1737,9 @@ static int symbol__disassemble_bpf(struc
 		ret = errno;
 		goto out;
 	}
-	init_disassemble_info(&info, s,
-			      (fprintf_ftype) fprintf);
-
+	init_disassemble_info_compat(&info, s,
+				     (fprintf_ftype) fprintf,
+				     fprintf_styled);
 	info.arch = bfd_get_arch(bfdf);
 	info.mach = bfd_get_mach(bfdf);
 


