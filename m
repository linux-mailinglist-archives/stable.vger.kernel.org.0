Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D41604022
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234266AbiJSJnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbiJSJl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDDCF5CDF;
        Wed, 19 Oct 2022 02:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CF1F6181A;
        Wed, 19 Oct 2022 09:15:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E78AC433D6;
        Wed, 19 Oct 2022 09:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170929;
        bh=Cjo4WF83Lp3JlA7ZtBZMDCxCi1/3fmTXVCVb5izr2JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ntG3Rq4fVdxT3EoUt/YBoAgTFK0pX70lZBDomp3Qkd5XElD0SdVPQ7SUphQWGsHN4
         rzi+iBfcYGONEvi9cc7iQlVWq3i1WXx0WGObTsqPFmImlrUQSDBL29Ndf8M4gTvDxI
         9SR/TvXkVY4JYOikOwm9ouphNuanbMRU2KymSMx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.0 840/862] perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc
Date:   Wed, 19 Oct 2022 10:35:27 +0200
Message-Id: <20221019083327.001758539@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -4033,6 +4033,7 @@ static const char * const intel_pt_info_
 	[INTEL_PT_SNAPSHOT_MODE]	= "  Snapshot mode       %"PRId64"\n",
 	[INTEL_PT_PER_CPU_MMAPS]	= "  Per-cpu maps        %"PRId64"\n",
 	[INTEL_PT_MTC_BIT]		= "  MTC bit             %#"PRIx64"\n",
+	[INTEL_PT_MTC_FREQ_BITS]	= "  MTC freq bits       %#"PRIx64"\n",
 	[INTEL_PT_TSC_CTC_N]		= "  TSC:CTC numerator   %"PRIu64"\n",
 	[INTEL_PT_TSC_CTC_D]		= "  TSC:CTC denominator %"PRIu64"\n",
 	[INTEL_PT_CYC_BIT]		= "  CYC bit             %#"PRIx64"\n",
@@ -4047,8 +4048,12 @@ static void intel_pt_print_info(__u64 *a
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


