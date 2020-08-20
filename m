Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D294924BAF9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbgHTMVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730211AbgHTJz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:55:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0855D22B3F;
        Thu, 20 Aug 2020 09:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917328;
        bh=4Kqy42bYRo9TCoGLVURv1kmQzUNij8zQ5wCsCx9mP54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVMdAqfnwWBnu46r8xA1IFluG4zWYseJ15ja+8spr6/XVnuLx7rxAPCHfseRxbcWb
         a5kCi6643+05uZ+yXUj3IDMuN0l094tcQT1BlwGiymXoRjfplcySCRuIaPdz98ry8e
         r8n7DCe7DV0RXHklJAjEkl6vtA8Ei57+0M/x9hd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        Thomas Hebb <tommyhebb@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Stephane Eranian <eranian@google.com>,
        Yonghong Song <yhs@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 86/92] tools build feature: Quote CC and CXX for their arguments
Date:   Thu, 20 Aug 2020 11:22:11 +0200
Message-Id: <20200820091542.111946709@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Díaz <daniel.diaz@linaro.org>

[ Upstream commit fa5c893181ed2ca2f96552f50073786d2cfce6c0 ]

When using a cross-compilation environment, such as OpenEmbedded,
the CC an CXX variables are set to something more than just a
command: there are arguments (such as --sysroot) that need to be
passed on to the compiler so that the right set of headers and
libraries are used.

For the particular case that our systems detected, CC is set to
the following:

  export CC="aarch64-linaro-linux-gcc  --sysroot=/oe/build/tmp/work/machine/perf/1.0-r9/recipe-sysroot"

Without quotes, detection is as follows:

  Auto-detecting system features:
  ...                         dwarf: [ OFF ]
  ...            dwarf_getlocations: [ OFF ]
  ...                         glibc: [ OFF ]
  ...                          gtk2: [ OFF ]
  ...                        libbfd: [ OFF ]
  ...                        libcap: [ OFF ]
  ...                        libelf: [ OFF ]
  ...                       libnuma: [ OFF ]
  ...        numa_num_possible_cpus: [ OFF ]
  ...                       libperl: [ OFF ]
  ...                     libpython: [ OFF ]
  ...                     libcrypto: [ OFF ]
  ...                     libunwind: [ OFF ]
  ...            libdw-dwarf-unwind: [ OFF ]
  ...                          zlib: [ OFF ]
  ...                          lzma: [ OFF ]
  ...                     get_cpuid: [ OFF ]
  ...                           bpf: [ OFF ]
  ...                        libaio: [ OFF ]
  ...                       libzstd: [ OFF ]
  ...        disassembler-four-args: [ OFF ]

  Makefile.config:414: *** No gnu/libc-version.h found, please install glibc-dev[el].  Stop.
  Makefile.perf:230: recipe for target 'sub-make' failed
  make[1]: *** [sub-make] Error 2
  Makefile:69: recipe for target 'all' failed
  make: *** [all] Error 2

With CC and CXX quoted, some of those features are now detected.

Fixes: e3232c2f39ac ("tools build feature: Use CC and CXX from parent")
Signed-off-by: Daniel Díaz <daniel.diaz@linaro.org>
Reviewed-by: Thomas Hebb <tommyhebb@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@chromium.org>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Yonghong Song <yhs@fb.com>
Link: http://lore.kernel.org/lkml/20200812221518.2869003-1-daniel.diaz@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 7d9d70c0b3800..7c17f17ea2cd2 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -7,7 +7,7 @@ endif
 
 feature_check = $(eval $(feature_check_code))
 define feature_check_code
-  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CC=$(CC) CXX=$(CXX) CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" CXXFLAGS="$(EXTRA_CXXFLAGS) $(FEATURE_CHECK_CXXFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C $(feature_dir) $(OUTPUT_FEATURES)test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
+  feature-$(1) := $(shell $(MAKE) OUTPUT=$(OUTPUT_FEATURES) CC="$(CC)" CXX="$(CXX)" CFLAGS="$(EXTRA_CFLAGS) $(FEATURE_CHECK_CFLAGS-$(1))" CXXFLAGS="$(EXTRA_CXXFLAGS) $(FEATURE_CHECK_CXXFLAGS-$(1))" LDFLAGS="$(LDFLAGS) $(FEATURE_CHECK_LDFLAGS-$(1))" -C $(feature_dir) $(OUTPUT_FEATURES)test-$1.bin >/dev/null 2>/dev/null && echo 1 || echo 0)
 endef
 
 feature_set = $(eval $(feature_set_code))
-- 
2.25.1



