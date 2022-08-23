Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB6359DC6F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbiHWLh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242768AbiHWLe5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:34:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D32B76974;
        Tue, 23 Aug 2022 02:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB24661315;
        Tue, 23 Aug 2022 09:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731FDC433C1;
        Tue, 23 Aug 2022 09:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246839;
        bh=DD/TPmxjClLLHXvhqrQr0eZDvLR1h1JpUl8RC6U2CGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHoQlrMS1bvGzKYPrhK76e0X2kyNHI2uzcTht9ya3+v3LwNDY67dvuwm/HHihLhIi
         b+zJU4XaLGT3qLQCR0zG/3md5OSn7lSssk+Z4C2zDAiQYOQeCQ2rLqBlnXABVn/X8g
         VbWKPQgubv3wux2v/s41SA6AsJcPBOjYsJ02H0yg=
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
Subject: [PATCH 5.4 237/389] perf symbol: Fail to read phdr workaround
Date:   Tue, 23 Aug 2022 10:25:15 +0200
Message-Id: <20220823080125.471356503@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index 0b185b1090ff..a04a7dfb8ec0 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1159,16 +1159,29 @@ int dso__load_sym(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 
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



