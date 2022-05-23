Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1432D531CF1
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242341AbiEWRkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244013AbiEWRig (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A5D986DB;
        Mon, 23 May 2022 10:33:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E947EB8121B;
        Mon, 23 May 2022 17:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47759C385A9;
        Mon, 23 May 2022 17:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327004;
        bh=78eIVbKrFEg+O5i0kkKIJmRGiqznDYuV/M2Fuaxz640=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xcf0s5iNNSzDviA51yQfFzCKtbuXZkZtfopen475XPZiDH2qGtusubAXkRoF/HR9R
         ZmhaYUd5zIphM4hF+lpus8BJtrZUSpAk01oOb6LfHWIErzjd7VtVKSGpJ/84hMLc4W
         DmlXeg9DOLl9Z+jJqzS0XbIg4Ab57bRXDdL6n2go=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avi Kivity <avi@scylladb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 125/158] perf build: Fix check for btf__load_from_kernel_by_id() in libbpf
Date:   Mon, 23 May 2022 19:04:42 +0200
Message-Id: <20220523165851.378018376@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 0ae065a5d265bc5ada13e350015458e0c5e5c351 ]

Avi Kivity reported a problem where the __weak
btf__load_from_kernel_by_id() in tools/perf/util/bpf-event.c was being
used and it called btf__get_from_id() in tools/lib/bpf/btf.c that in
turn called back to btf__load_from_kernel_by_id(), resulting in an
endless loop.

Fix this by adding a feature test to check if
btf__load_from_kernel_by_id() is available when building perf with
LIBBPF_DYNAMIC=1, and if not then provide the fallback to the old
btf__get_from_id(), that doesn't call back to btf__load_from_kernel_by_id()
since at that time it didn't exist at all.

Tested on Fedora 35 where we have libbpf-devel 0.4.0 with LIBBPF_DYNAMIC
where we don't have btf__load_from_kernel_by_id() and thus its feature
test fail, not defining HAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID:

  $ cat /tmp/build/perf-urgent/feature/test-libbpf-btf__load_from_kernel_by_id.make.output
  test-libbpf-btf__load_from_kernel_by_id.c: In function ‘main’:
  test-libbpf-btf__load_from_kernel_by_id.c:6:16: error: implicit declaration of function ‘btf__load_from_kernel_by_id’ [-Werror=implicit-function-declaration]
      6 |         return btf__load_from_kernel_by_id(20151128, NULL);
        |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors
  $

  $ nm /tmp/build/perf-urgent/perf | grep btf__load_from_kernel_by_id
  00000000005ba180 T btf__load_from_kernel_by_id
  $

  $ objdump --disassemble=btf__load_from_kernel_by_id -S /tmp/build/perf-urgent/perf

  /tmp/build/perf-urgent/perf:     file format elf64-x86-64
  <SNIP>
  00000000005ba180 <btf__load_from_kernel_by_id>:
  #include "record.h"
  #include "util/synthetic-events.h"

  #ifndef HAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID
  struct btf *btf__load_from_kernel_by_id(__u32 id)
  {
    5ba180:	55                   	push   %rbp
    5ba181:	48 89 e5             	mov    %rsp,%rbp
    5ba184:	48 83 ec 10          	sub    $0x10,%rsp
    5ba188:	64 48 8b 04 25 28 00 	mov    %fs:0x28,%rax
    5ba18f:	00 00
    5ba191:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    5ba195:	31 c0                	xor    %eax,%eax
         struct btf *btf;
  #pragma GCC diagnostic push
  #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
         int err = btf__get_from_id(id, &btf);
    5ba197:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
    5ba19b:	e8 a0 57 e5 ff       	call   40f940 <btf__get_from_id@plt>
    5ba1a0:	89 c2                	mov    %eax,%edx
  #pragma GCC diagnostic pop

         return err ? ERR_PTR(err) : btf;
    5ba1a2:	48 98                	cltq
    5ba1a4:	85 d2                	test   %edx,%edx
    5ba1a6:	48 0f 44 45 f0       	cmove  -0x10(%rbp),%rax
  }
  <SNIP>

Fixes: 218e7b775d368f38 ("perf bpf: Provide a weak btf__load_from_kernel_by_id() for older libbpf versions")
Reported-by: Avi Kivity <avi@scylladb.com>
Link: https://lore.kernel.org/linux-perf-users/f0add43b-3de5-20c5-22c4-70aff4af959f@scylladb.com
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/linux-perf-users/YobjjFOblY4Xvwo7@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature                               | 1 +
 tools/build/feature/Makefile                               | 4 ++++
 .../feature/test-libbpf-btf__load_from_kernel_by_id.c      | 7 +++++++
 tools/perf/Makefile.config                                 | 7 +++++++
 tools/perf/util/bpf-event.c                                | 4 +++-
 5 files changed, 22 insertions(+), 1 deletion(-)
 create mode 100644 tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index ae61f464043a..c6a48d0ef9ff 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -98,6 +98,7 @@ FEATURE_TESTS_EXTRA :=                  \
          llvm-version                   \
          clang                          \
          libbpf                         \
+         libbpf-btf__load_from_kernel_by_id \
          libpfm4                        \
          libdebuginfod			\
          clang-bpf-co-re
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index de66e1cc0734..cb4a2a4fa2e4 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -57,6 +57,7 @@ FILES=                                          \
          test-lzma.bin                          \
          test-bpf.bin                           \
          test-libbpf.bin                        \
+         test-libbpf-btf__load_from_kernel_by_id.bin	\
          test-get_cpuid.bin                     \
          test-sdt.bin                           \
          test-cxx.bin                           \
@@ -287,6 +288,9 @@ $(OUTPUT)test-bpf.bin:
 $(OUTPUT)test-libbpf.bin:
 	$(BUILD) -lbpf
 
+$(OUTPUT)test-libbpf-btf__load_from_kernel_by_id.bin:
+	$(BUILD) -lbpf
+
 $(OUTPUT)test-sdt.bin:
 	$(BUILD)
 
diff --git a/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c b/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c
new file mode 100644
index 000000000000..f7c084428735
--- /dev/null
+++ b/tools/build/feature/test-libbpf-btf__load_from_kernel_by_id.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <bpf/libbpf.h>
+
+int main(void)
+{
+	return btf__load_from_kernel_by_id(20151128, NULL);
+}
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index f3bf9297bcc0..1bd64e7404b9 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -553,9 +553,16 @@ ifndef NO_LIBELF
         ifeq ($(feature-libbpf), 1)
           EXTLIBS += -lbpf
           $(call detected,CONFIG_LIBBPF_DYNAMIC)
+
+          $(call feature_check,libbpf-btf__load_from_kernel_by_id)
+          ifeq ($(feature-libbpf-btf__load_from_kernel_by_id), 1)
+            CFLAGS += -DHAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID
+          endif
         else
           dummy := $(error Error: No libbpf devel library found, please install libbpf-devel);
         endif
+      else
+	CFLAGS += -DHAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID
       endif
     endif
 
diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index a517eaa51eb3..65dfd2c70246 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -22,7 +22,8 @@
 #include "record.h"
 #include "util/synthetic-events.h"
 
-struct btf * __weak btf__load_from_kernel_by_id(__u32 id)
+#ifndef HAVE_LIBBPF_BTF__LOAD_FROM_KERNEL_BY_ID
+struct btf *btf__load_from_kernel_by_id(__u32 id)
 {
        struct btf *btf;
 #pragma GCC diagnostic push
@@ -32,6 +33,7 @@ struct btf * __weak btf__load_from_kernel_by_id(__u32 id)
 
        return err ? ERR_PTR(err) : btf;
 }
+#endif
 
 struct bpf_program * __weak
 bpf_object__next_program(const struct bpf_object *obj, struct bpf_program *prev)
-- 
2.35.1



