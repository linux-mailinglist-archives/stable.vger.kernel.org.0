Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD41A531D16
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241931AbiEWRkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243855AbiEWRi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:38:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D893573556;
        Mon, 23 May 2022 10:32:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46AF6B81223;
        Mon, 23 May 2022 17:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676C1C3411A;
        Mon, 23 May 2022 17:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653327021;
        bh=EElDOJhrmrplxAnqdeL2YM32Vk1aHtjDVjTNQWjrJVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W3O8+z9bHWSe8SyVTKa9C0tIwZ6Ln/e4MBfAABuLjk+GY5qUkMXKeJ+UuWNeZFsm5
         xXLI4ySb6BTbexGCYGD8A3D5cRv2ERBLj30cJCy9NZdie5XdFECaFJF/1+OJi6gVar
         wD8fqO3xS519uqIX1Dse1aDCtQMe+jGNnxhiJJXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ammy Yi <ammy.yi@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 130/158] perf regs x86: Fix arch__intr_reg_mask() for the hybrid platform
Date:   Mon, 23 May 2022 19:04:47 +0200
Message-Id: <20220523165852.042521015@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 01b28e4a58152e8906eeb5f1b55a0c404c48c7c8 ]

The X86 specific arch__intr_reg_mask() is to check whether the kernel
and hardware can collect XMM registers. But it doesn't work on some
hybrid platform.

Without the patch on ADL-N:

  $ perf record -I?
  available registers: AX BX CX DX SI DI BP SP IP FLAGS CS SS R8 R9 R10
  R11 R12 R13 R14 R15

The config of the test event doesn't contain the PMU information. The
kernel may fail to initialize it on the correct hybrid PMU and return
the wrong non-supported information.

Add the PMU information into the config for the hybrid platform. The
same register set is supported among different hybrid PMUs. Checking
the first available one is good enough.

With the patch on ADL-N:

  $ perf record -I?
  available registers: AX BX CX DX SI DI BP SP IP FLAGS CS SS R8 R9 R10
  R11 R12 R13 R14 R15 XMM0 XMM1 XMM2 XMM3 XMM4 XMM5 XMM6 XMM7 XMM8 XMM9
  XMM10 XMM11 XMM12 XMM13 XMM14 XMM15

Fixes: 6466ec14aaf44ff1 ("perf regs x86: Add X86 specific arch__intr_reg_mask()")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Link: https://lore.kernel.org/r/20220518145125.1494156-1-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/perf_regs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/arch/x86/util/perf_regs.c b/tools/perf/arch/x86/util/perf_regs.c
index 207c56805c55..0ed177991ad0 100644
--- a/tools/perf/arch/x86/util/perf_regs.c
+++ b/tools/perf/arch/x86/util/perf_regs.c
@@ -9,6 +9,8 @@
 #include "../../../util/perf_regs.h"
 #include "../../../util/debug.h"
 #include "../../../util/event.h"
+#include "../../../util/pmu.h"
+#include "../../../util/pmu-hybrid.h"
 
 const struct sample_reg sample_reg_masks[] = {
 	SMPL_REG(AX, PERF_REG_X86_AX),
@@ -284,12 +286,22 @@ uint64_t arch__intr_reg_mask(void)
 		.disabled 		= 1,
 		.exclude_kernel		= 1,
 	};
+	struct perf_pmu *pmu;
 	int fd;
 	/*
 	 * In an unnamed union, init it here to build on older gcc versions
 	 */
 	attr.sample_period = 1;
 
+	if (perf_pmu__has_hybrid()) {
+		/*
+		 * The same register set is supported among different hybrid PMUs.
+		 * Only check the first available one.
+		 */
+		pmu = list_first_entry(&perf_pmu__hybrid_pmus, typeof(*pmu), hybrid_list);
+		attr.config |= (__u64)pmu->type << PERF_PMU_TYPE_SHIFT;
+	}
+
 	event_attr_init(&attr);
 
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
-- 
2.35.1



