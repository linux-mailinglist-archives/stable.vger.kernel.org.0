Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C6EB60AA2D
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiJXNba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiJXN3X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:29:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD70B1E1;
        Mon, 24 Oct 2022 05:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2C43612B2;
        Mon, 24 Oct 2022 12:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8809C433D6;
        Mon, 24 Oct 2022 12:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614741;
        bh=3ierzcmJ1iX1qGa2HEvurAr4/bygL9us4GsEWEsJVYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ytOJA4XCR08vCIZE8iuE87Jzpa7qvjusJ9bbYiulEJD3SrJAv4Tvsq/Hl0x+0qTfg
         QnVvc/qeZjwMQdXTo9i8nWhdPdVV/q+Uwnsd1Tab0m6cLp6i8uC48abtnUjv4jEh1N
         LpzYETF4UjCdVxms0Sw9pwLs/6r3jaHugwvjGVFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 376/390] perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc
Date:   Mon, 24 Oct 2022 13:32:53 +0200
Message-Id: <20221024113039.005803311@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 5a3d47071f0ced0431ef82a5fb6bd077ed9493db upstream.

uClibc segfaulted because NULL was passed as the format to fprintf().

That happened because one of the format strings was missing and
intel_pt_print_info() didn't check that before calling fprintf().

Add the missing format string, and check format is not NULL before calling
fprintf().

Fixes: 11fa7cb86b56d361 ("perf tools: Pass Intel PT information for decoding MTC and CYC")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221012082259.22394-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -3279,6 +3279,7 @@ static const char * const intel_pt_info_
 	[INTEL_PT_SNAPSHOT_MODE]	= "  Snapshot mode       %"PRId64"\n",
 	[INTEL_PT_PER_CPU_MMAPS]	= "  Per-cpu maps        %"PRId64"\n",
 	[INTEL_PT_MTC_BIT]		= "  MTC bit             %#"PRIx64"\n",
+	[INTEL_PT_MTC_FREQ_BITS]	= "  MTC freq bits       %#"PRIx64"\n",
 	[INTEL_PT_TSC_CTC_N]		= "  TSC:CTC numerator   %"PRIu64"\n",
 	[INTEL_PT_TSC_CTC_D]		= "  TSC:CTC denominator %"PRIu64"\n",
 	[INTEL_PT_CYC_BIT]		= "  CYC bit             %#"PRIx64"\n",
@@ -3293,8 +3294,12 @@ static void intel_pt_print_info(__u64 *a
 	if (!dump_trace)
 		return;
 
-	for (i = start; i <= finish; i++)
-		fprintf(stdout, intel_pt_info_fmts[i], arr[i]);
+	for (i = start; i <= finish; i++) {
+		const char *fmt = intel_pt_info_fmts[i];
+
+		if (fmt)
+			fprintf(stdout, fmt, arr[i]);
+	}
 }
 
 static void intel_pt_print_info_str(const char *name, const char *str)


