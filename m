Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBF46BB1E4
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbjCOMbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232643AbjCOMbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:31:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F7C10429;
        Wed, 15 Mar 2023 05:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9590C61D3E;
        Wed, 15 Mar 2023 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8224AC433EF;
        Wed, 15 Mar 2023 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883416;
        bh=Qg+PFJ0nwM/TuAdSfd5lfARRtcdUVf6B93PGm3/dEjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgozbtRdewhlt1/KazZzHyaqhKp8Ho1jyebQbd26ldUxZcy9QRkWgbrHlZdTQv5bR
         oYY5FUVVP+Z1VgFqCJw5LP4Q1E9cWU2/5x26t9bg+nDOweTEA56q1PXcBJMjEic9zX
         UMK109oAwYmEcwPpHoUV3XBZC1foG6mI1UYAsWsk=
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
Subject: [PATCH 5.15 134/145] tools build: Add feature test for init_disassemble_info API changes
Date:   Wed, 15 Mar 2023 13:13:20 +0100
Message-Id: <20230315115743.352986008@linuxfoundation.org>
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

commit cfd59ca91467056bb2c36907b2fa67b8e1af9952 upstream.

binutils changed the signature of init_disassemble_info(), which now causes
compilation failures for tools/{perf,bpf}, e.g. on debian unstable.

Relevant binutils commit:

  https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=60a3da00bd5407f07

This commit adds a feature test to detect the new signature.  Subsequent
commits will use it to fix the build failures.

Signed-off-by: Andres Freund <andres@anarazel.de>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Ben Hutchings <benh@debian.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: bpf@vger.kernel.org
Link: http://lore.kernel.org/lkml/20220622181918.ykrs5rsnmx3og4sv@alap3.anarazel.de
Link: https://lore.kernel.org/r/20220801013834.156015-2-andres@anarazel.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/Makefile.feature                        |    1 +
 tools/build/feature/Makefile                        |    4 ++++
 tools/build/feature/test-all.c                      |    4 ++++
 tools/build/feature/test-disassembler-init-styled.c |   13 +++++++++++++
 4 files changed, 22 insertions(+)
 create mode 100644 tools/build/feature/test-disassembler-init-styled.c

--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -69,6 +69,7 @@ FEATURE_TESTS_BASIC :=
         libaio				\
         libzstd				\
         disassembler-four-args		\
+        disassembler-init-styled	\
         file-handle
 
 # FEATURE_TESTS_BASIC + FEATURE_TESTS_EXTRA is the complete list
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -18,6 +18,7 @@ FILES=
          test-libbfd.bin                        \
          test-libbfd-buildid.bin		\
          test-disassembler-four-args.bin        \
+         test-disassembler-init-styled.bin	\
          test-reallocarray.bin			\
          test-libbfd-liberty.bin                \
          test-libbfd-liberty-z.bin              \
@@ -239,6 +240,9 @@ $(OUTPUT)test-libbfd-buildid.bin:
 $(OUTPUT)test-disassembler-four-args.bin:
 	$(BUILD) -DPACKAGE='"perf"' -lbfd -lopcodes
 
+$(OUTPUT)test-disassembler-init-styled.bin:
+	$(BUILD) -DPACKAGE='"perf"' -lbfd -lopcodes
+
 $(OUTPUT)test-reallocarray.bin:
 	$(BUILD)
 
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -166,6 +166,10 @@
 # include "test-disassembler-four-args.c"
 #undef main
 
+#define main main_test_disassembler_init_styled
+# include "test-disassembler-init-styled.c"
+#undef main
+
 #define main main_test_libzstd
 # include "test-libzstd.c"
 #undef main
--- /dev/null
+++ b/tools/build/feature/test-disassembler-init-styled.c
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdio.h>
+#include <dis-asm.h>
+
+int main(void)
+{
+	struct disassemble_info info;
+
+	init_disassemble_info(&info, stdout,
+			      NULL, NULL);
+
+	return 0;
+}


