Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DECF2658217
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbiL1QdG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiL1Qcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C2F13F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:29:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ED7A61577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D23DC433D2;
        Wed, 28 Dec 2022 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244985;
        bh=5YTnHYb44Tvh0ZcmQw5FvxR0neV5vVJwQSLYSKZWTEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jerZaLN50QUZkyP6LpIqDcXK4WMfxNpNIeX0Y1ktZczlY0McS9nW8YqHSOCmHf/Y
         5TnE9As+bbQcFD1O+bGIpaoY8wzwkz9hazvW6E90NMX2iyhZnaVzfMPbzSlIUg4Rb8
         Y1szS1MD6tt6b6XxmMXVB0eY7vz0334qHG95bWss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ajay Kaher <akaher@vmware.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Jiri Olsa <jolsa@kernel.org>, Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsab@vmware.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0773/1146] perf symbol: correction while adjusting symbol
Date:   Wed, 28 Dec 2022 15:38:32 +0100
Message-Id: <20221228144351.145469659@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay Kaher <akaher@vmware.com>

[ Upstream commit 6f520ce17920b3cdfbd2479b3ccf27f9706219d0 ]

perf doesn't provide proper symbol information for specially crafted
.debug files.

Sometimes .debug file may not have similar program header as runtime
ELF file. For example if we generate .debug file using objcopy
--only-keep-debug resulting file will not contain .text, .data and
other runtime sections. That means corresponding program headers will
have zero FileSiz and modified Offset.

Example: program header of text section of libxxx.so:

Type           Offset             VirtAddr           PhysAddr
               FileSiz            MemSiz              Flags  Align
LOAD        0x00000000003d3000 0x00000000003d3000 0x00000000003d3000
            0x000000000055ae80 0x000000000055ae80  R E    0x1000

Same program header after executing:
objcopy --only-keep-debug libxxx.so libxxx.so.debug

LOAD        0x0000000000001000 0x00000000003d3000 0x00000000003d3000
            0x0000000000000000 0x000000000055ae80  R E    0x1000

Offset and FileSiz have been changed.

Following formula will not provide correct value, if program header
taken from .debug file (syms_ss):

    sym.st_value -= phdr.p_vaddr - phdr.p_offset;

Correct program header information is located inside runtime ELF
file (runtime_ss).

Fixes: 2d86612aacb7805f ("perf symbol: Correct address for bss symbols")
Signed-off-by: Ajay Kaher <akaher@vmware.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Makhalov <amakhalov@vmware.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srivatsa S. Bhat <srivatsab@vmware.com>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Vasavi Sirnapalli <vsirnapalli@vmware.com>
Link: http://lore.kernel.org/lkml/1669198696-50547-1-git-send-email-akaher@vmware.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 647b7dff8ef3..80345695b136 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1303,7 +1303,7 @@ dso__load_sym_internal(struct dso *dso, struct map *map, struct symsrc *syms_ss,
 			   (!used_opd && syms_ss->adjust_symbols)) {
 			GElf_Phdr phdr;
 
-			if (elf_read_program_header(syms_ss->elf,
+			if (elf_read_program_header(runtime_ss->elf,
 						    (u64)sym.st_value, &phdr)) {
 				pr_debug4("%s: failed to find program header for "
 					   "symbol: %s st_value: %#" PRIx64 "\n",
-- 
2.35.1



