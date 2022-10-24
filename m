Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133BE60A3C0
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiJXMAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJXL6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:58:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10DE2B1A6;
        Mon, 24 Oct 2022 04:47:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B855DCE12CF;
        Mon, 24 Oct 2022 11:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B294AC433C1;
        Mon, 24 Oct 2022 11:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611928;
        bh=UE6C/YunwoRMuPQGwLI+pqaEFufW26X4AEXY60j0vS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EgEHscsoJSqI9zC9vJTC9uD3a1jKtL7xIwyQuR9/8YoQv2vgz9pwKxVkAN1AK7zOs
         qrNBOk966QC0v0sfxzwbKoh/nqrFPS7+uO+C9qGTJoT8iOf7gLP6hxK4gx82TJEiNf
         UScXv6VbzaYZ3Pb6iB8Gbgm7TBWIWCaBdwrpUyQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.9 153/159] perf intel-pt: Fix segfault in intel_pt_print_info() with uClibc
Date:   Mon, 24 Oct 2022 13:31:47 +0200
Message-Id: <20221024112955.006882965@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
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
@@ -2124,6 +2124,7 @@ static const char * const intel_pt_info_
 	[INTEL_PT_SNAPSHOT_MODE]	= "  Snapshot mode       %"PRId64"\n",
 	[INTEL_PT_PER_CPU_MMAPS]	= "  Per-cpu maps        %"PRId64"\n",
 	[INTEL_PT_MTC_BIT]		= "  MTC bit             %#"PRIx64"\n",
+	[INTEL_PT_MTC_FREQ_BITS]	= "  MTC freq bits       %#"PRIx64"\n",
 	[INTEL_PT_TSC_CTC_N]		= "  TSC:CTC numerator   %"PRIu64"\n",
 	[INTEL_PT_TSC_CTC_D]		= "  TSC:CTC denominator %"PRIu64"\n",
 	[INTEL_PT_CYC_BIT]		= "  CYC bit             %#"PRIx64"\n",
@@ -2138,8 +2139,12 @@ static void intel_pt_print_info(u64 *arr
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


