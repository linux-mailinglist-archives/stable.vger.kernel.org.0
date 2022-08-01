Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC999586A7E
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234533AbiHAMRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234086AbiHAMQT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:16:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65A348EB4;
        Mon,  1 Aug 2022 04:58:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EF6BB80E8F;
        Mon,  1 Aug 2022 11:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C9FC433C1;
        Mon,  1 Aug 2022 11:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355129;
        bh=6LDtu3xfLD3w2Kt9zGVdzUU8HzppBADqvcuwSBLmMK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KK7nRXpzACsVzXfYbWd4WLRa6HRDvG+e9C5A8IiYA8dcgzqtb9jV9AQfD5KfK8z5F
         7FOWE2IgufX+ixhBLQ+F9YfVti1XeE7YN2m/Kg9mzZjoYDa+km70HRG3RY+CbFZ8ki
         Ke7cqSLtFSxOqHV2oowzlXggsykjUBPn57g6G1V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chang Rui <changruinj@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Leo Yan <leo.yan@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 74/88] perf symbol: Correct address for bss symbols
Date:   Mon,  1 Aug 2022 13:47:28 +0200
Message-Id: <20220801114141.409143282@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit 2d86612aacb7805f72873691a2644d7279ed0630 ]

When using 'perf mem' and 'perf c2c', an issue is observed that tool
reports the wrong offset for global data symbols.  This is a common
issue on both x86 and Arm64 platforms.

Let's see an example, for a test program, below is the disassembly for
its .bss section which is dumped with objdump:

  ...

  Disassembly of section .bss:

  0000000000004040 <completed.0>:
  	...

  0000000000004080 <buf1>:
  	...

  00000000000040c0 <buf2>:
  	...

  0000000000004100 <thread>:
  	...

First we used 'perf mem record' to run the test program and then used
'perf --debug verbose=4 mem report' to observe what's the symbol info
for 'buf1' and 'buf2' structures.

  # ./perf mem record -e ldlat-loads,ldlat-stores -- false_sharing.exe 8
  # ./perf --debug verbose=4 mem report
    ...
    dso__load_sym_internal: adjusting symbol: st_value: 0x40c0 sh_addr: 0x4040 sh_offset: 0x3028
    symbol__new: buf2 0x30a8-0x30e8
    ...
    dso__load_sym_internal: adjusting symbol: st_value: 0x4080 sh_addr: 0x4040 sh_offset: 0x3028
    symbol__new: buf1 0x3068-0x30a8
    ...

The perf tool relies on libelf to parse symbols, in executable and
shared object files, 'st_value' holds a virtual address; 'sh_addr' is
the address at which section's first byte should reside in memory, and
'sh_offset' is the byte offset from the beginning of the file to the
first byte in the section.  The perf tool uses below formula to convert
a symbol's memory address to a file address:

  file_address = st_value - sh_addr + sh_offset
                    ^
                    ` Memory address

We can see the final adjusted address ranges for buf1 and buf2 are
[0x30a8-0x30e8) and [0x3068-0x30a8) respectively, apparently this is
incorrect, in the code, the structure for 'buf1' and 'buf2' specifies
compiler attribute with 64-byte alignment.

The problem happens for 'sh_offset', libelf returns it as 0x3028 which
is not 64-byte aligned, combining with disassembly, it's likely libelf
doesn't respect the alignment for .bss section, therefore, it doesn't
return the aligned value for 'sh_offset'.

Suggested by Fangrui Song, ELF file contains program header which
contains PT_LOAD segments, the fields p_vaddr and p_offset in PT_LOAD
segments contain the execution info.  A better choice for converting
memory address to file address is using the formula:

  file_address = st_value - p_vaddr + p_offset

This patch introduces elf_read_program_header() which returns the
program header based on the passed 'st_value', then it uses the formula
above to calculate the symbol file address; and the debugging log is
updated respectively.

After applying the change:

  # ./perf --debug verbose=4 mem report
    ...
    dso__load_sym_internal: adjusting symbol: st_value: 0x40c0 p_vaddr: 0x3d28 p_offset: 0x2d28
    symbol__new: buf2 0x30c0-0x3100
    ...
    dso__load_sym_internal: adjusting symbol: st_value: 0x4080 p_vaddr: 0x3d28 p_offset: 0x2d28
    symbol__new: buf1 0x3080-0x30c0
    ...

Fixes: f17e04afaff84b5c ("perf report: Fix ELF symbol parsing")
Reported-by: Chang Rui <changruinj@gmail.com>
Suggested-by: Fangrui Song <maskray@google.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220724060013.171050-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 45 ++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index ecd377938eea..ef6ced5c5746 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -233,6 +233,33 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 	return NULL;
 }
 
+static int elf_read_program_header(Elf *elf, u64 vaddr, GElf_Phdr *phdr)
+{
+	size_t i, phdrnum;
+	u64 sz;
+
+	if (elf_getphdrnum(elf, &phdrnum))
+		return -1;
+
+	for (i = 0; i < phdrnum; i++) {
+		if (gelf_getphdr(elf, i, phdr) == NULL)
+			return -1;
+
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		sz = max(phdr->p_memsz, phdr->p_filesz);
+		if (!sz)
+			continue;
+
+		if (vaddr >= phdr->p_vaddr && (vaddr < phdr->p_vaddr + sz))
+			return 0;
+	}
+
+	/* Not found any valid program header */
+	return -1;
+}
+
 static bool want_demangle(bool is_kernel_sym)
 {
 	return is_kernel_sym ? symbol_conf.demangle_kernel : symbol_conf.demangle;
@@ -1209,6 +1236,7 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 					sym.st_value);
 			used_opd = true;
 		}
+
 		/*
 		 * When loading symbols in a data mapping, ABS symbols (which
 		 * has a value of SHN_ABS in its st_shndx) failed at
@@ -1262,11 +1290,20 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 				goto out_elf_end;
 		} else if ((used_opd && runtime_ss->adjust_symbols) ||
 			   (!used_opd && syms_ss->adjust_symbols)) {
+			GElf_Phdr phdr;
+
+			if (elf_read_program_header(syms_ss->elf,
+						    (u64)sym.st_value, &phdr)) {
+				pr_warning("%s: failed to find program header for "
+					   "symbol: %s st_value: %#" PRIx64 "\n",
+					   __func__, elf_name, (u64)sym.st_value);
+				continue;
+			}
 			pr_debug4("%s: adjusting symbol: st_value: %#" PRIx64 " "
-				  "sh_addr: %#" PRIx64 " sh_offset: %#" PRIx64 "\n", __func__,
-				  (u64)sym.st_value, (u64)shdr.sh_addr,
-				  (u64)shdr.sh_offset);
-			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+				  "p_vaddr: %#" PRIx64 " p_offset: %#" PRIx64 "\n",
+				  __func__, (u64)sym.st_value, (u64)phdr.p_vaddr,
+				  (u64)phdr.p_offset);
+			sym.st_value -= phdr.p_vaddr - phdr.p_offset;
 		}
 
 		demangled = demangle_sym(dso, kmodule, elf_name);
-- 
2.35.1



