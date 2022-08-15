Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380BE594DC0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbiHPAsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350278AbiHPAqx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:46:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2B1B6012;
        Mon, 15 Aug 2022 13:45:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D10E461241;
        Mon, 15 Aug 2022 20:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919DFC433D6;
        Mon, 15 Aug 2022 20:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596333;
        bh=cHKoEz5AhZTMwvjljV+QjpUj/NxRWBitpdzVNprFsqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdkY7WM6UxUPIcgFdnTYEXpI1JuayaIk3O1KIwh1y934QoSnnXpfsky0OdOhOg+lf
         LO/OATHYfFVZeLKBQAYWij/kyGcJLLZlE5cc/0xHVgaU0djg2s7vC+6p46+WcbH5og
         t7ii3WPu4M9T5R2BjIB/mayEWwVqlAmF6CEEi2GE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1013/1157] perf symbol: Fail to read phdr workaround
Date:   Mon, 15 Aug 2022 20:06:09 +0200
Message-Id: <20220815180520.389615024@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_HEX autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 6d518ac7be6223811ab947897273b1bbef846180 ]

The perf jvmti agent doesn't create program headers, in this case
fallback on section headers as happened previously.

Committer notes:

To test this, from a public post by Ian:

1) download a Java workload dacapo-9.12-MR1-bach.jar from
https://sourceforge.net/projects/dacapobench/

2) build perf such as "make -C tools/perf O=/tmp/perf NO_LIBBFD=1" it
should detect Java and create /tmp/perf/libperf-jvmti.so

3) run perf with the jvmti agent:

  perf record -k 1 java -agentpath:/tmp/perf/libperf-jvmti.so -jar dacapo-9.12-MR1-bach.jar -n 10 fop

4) run perf inject:

  perf inject -i perf.data -o perf-injected.data -j

5) run perf report

  perf report -i perf-injected.data | grep org.apache.fop

With this patch reverted I see lots of symbols like:

     0.00%  java             jitted-388040-4656.so  [.] org.apache.fop.fo.FObj.bind(org.apache.fop.fo.PropertyList)

With the patch (2d86612aacb7805f ("perf symbol: Correct address for bss
symbols")) I see lots of:

  dso__load_sym_internal: failed to find program header for symbol:
  Lorg/apache/fop/fo/FObj;bind(Lorg/apache/fop/fo/PropertyList;)V
  st_value: 0x40

Fixes: 2d86612aacb7805f ("perf symbol: Correct address for bss symbols")
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20220731164923.691193-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index b3be5b1d9dbb..75bec32d4f57 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1305,16 +1305,29 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 
 			if (elf_read_program_header(syms_ss->elf,
 						    (u64)sym.st_value, &phdr)) {
-				pr_warning("%s: failed to find program header for "
+				pr_debug4("%s: failed to find program header for "
 					   "symbol: %s st_value: %#" PRIx64 "\n",
 					   __func__, elf_name, (u64)sym.st_value);
-				continue;
+				pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
+					"sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n",
+					__func__, (u64)sym.st_value, (u64)shdr.sh_addr,
+					(u64)shdr.sh_offset);
+				/*
+				 * Fail to find program header, let's rollback
+				 * to use shdr.sh_addr and shdr.sh_offset to
+				 * calibrate symbol's file address, though this
+				 * is not necessary for normal C ELF file, we
+				 * still need to handle java JIT symbols in this
+				 * case.
+				 */
+				sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+			} else {
+				pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
+					"p_vaddr: %#" PRIx64 " p_offset: %#" PRIx64 "\n",
+					__func__, (u64)sym.st_value, (u64)phdr.p_vaddr,
+					(u64)phdr.p_offset);
+				sym.st_value -= phdr.p_vaddr - phdr.p_offset;
 			}
-			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
-				  "p_vaddr: %#" PRIx64 " p_offset: %#" PRIx64 "\n",
-				  __func__, (u64)sym.st_value, (u64)phdr.p_vaddr,
-				  (u64)phdr.p_offset);
-			sym.st_value -= phdr.p_vaddr - phdr.p_offset;
 		}
 
 		demangled = demangle_sym(dso, kmodule, elf_name);
-- 
2.35.1



