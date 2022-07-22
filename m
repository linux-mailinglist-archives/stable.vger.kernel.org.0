Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752E657DE11
	for <lists+stable@lfdr.de>; Fri, 22 Jul 2022 11:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235439AbiGVJPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jul 2022 05:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235302AbiGVJOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jul 2022 05:14:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433A8AF956;
        Fri, 22 Jul 2022 02:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41E62B827C3;
        Fri, 22 Jul 2022 09:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56462C341DC;
        Fri, 22 Jul 2022 09:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658481071;
        bh=IMBauOzRcMqflAMWHJK1bvStaZi2h2zPr/j55SL9i+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jm0lW8mhBeSwOStvFpG523JkClQCwXe0Rf/0IefcQLS053+XTb2teVEurINldOeaH
         srdDBLGF4sw5AB9uZsZS57H6zGFgICLcthLnT6zC3+0sbhqr7e1i51Dg6VltWx7dvf
         egEBu574gx4+dq/RbqPLBOxgaRUD95Y3zf6nJfIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>, Ian Rogers <irogers@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.18 67/70] tools arch x86: Sync the msr-index.h copy with the kernel sources
Date:   Fri, 22 Jul 2022 11:08:02 +0200
Message-Id: <20220722090654.722619083@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220722090650.665513668@linuxfoundation.org>
References: <20220722090650.665513668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit 91d248c3b903b46a58cbc7e8d38d684d3e4007c2 upstream.

To pick up the changes from these csets:

  4ad3278df6fe2b08 ("x86/speculation: Disable RRSBA behavior")
  d7caac991feeef1b ("x86/cpu/amd: Add Spectral Chicken")

That cause no changes to tooling:

  $ tools/perf/trace/beauty/tracepoints/x86_msr.sh > before
  $ cp arch/x86/include/asm/msr-index.h tools/arch/x86/include/asm/msr-index.h
  $ tools/perf/trace/beauty/tracepoints/x86_msr.sh > after
  $ diff -u before after
  $

Just silences this perf build warning:

  Warning: Kernel ABI header at 'tools/arch/x86/include/asm/msr-index.h' differs from latest version at 'arch/x86/include/asm/msr-index.h'
  diff -u tools/arch/x86/include/asm/msr-index.h arch/x86/include/asm/msr-index.h

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/lkml/YtQTm9wsB3hxQWvy@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/arch/x86/include/asm/msr-index.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -93,6 +93,7 @@
 #define MSR_IA32_ARCH_CAPABILITIES	0x0000010a
 #define ARCH_CAP_RDCL_NO		BIT(0)	/* Not susceptible to Meltdown */
 #define ARCH_CAP_IBRS_ALL		BIT(1)	/* Enhanced IBRS support */
+#define ARCH_CAP_RSBA			BIT(2)	/* RET may use alternative branch predictors */
 #define ARCH_CAP_SKIP_VMENTRY_L1DFLUSH	BIT(3)	/* Skip L1D flush on vmentry */
 #define ARCH_CAP_SSB_NO			BIT(4)	/*
 						 * Not susceptible to Speculative Store Bypass
@@ -561,6 +562,9 @@
 /* Fam 17h MSRs */
 #define MSR_F17H_IRPERF			0xc00000e9
 
+#define MSR_ZEN2_SPECTRAL_CHICKEN	0xc00110e3
+#define MSR_ZEN2_SPECTRAL_CHICKEN_BIT	BIT_ULL(1)
+
 /* Fam 16h MSRs */
 #define MSR_F16H_L2I_PERF_CTL		0xc0010230
 #define MSR_F16H_L2I_PERF_CTR		0xc0010231


