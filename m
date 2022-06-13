Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3A4548B4C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344862AbiFMKsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244569AbiFMKqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:46:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF402BB08;
        Mon, 13 Jun 2022 03:25:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B60460F13;
        Mon, 13 Jun 2022 10:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E26C3411E;
        Mon, 13 Jun 2022 10:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115948;
        bh=oApSn8bhkmu3ZHZl6cHkPXdUbNMGrllZUuT2wqqkiJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XQRF0BoSeZWnlQ+X+4covATnaBh0VE6vi41/F50VCeM6V25wxq0XmnLpRZ0WP3kf3
         2ElAn3gxVty5rpHYHlLIBvsSM9zuQmEM8fWefk9v0Lf2bCILatFJrY6uYXnEZATCRJ
         QbhKwmqPs0Smnn1h1B4+TE2n8Wn0bQmJvw+PLS9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Mario <jmario@redhat.com>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 100/218] perf c2c: Use stdio interface if slang is not supported
Date:   Mon, 13 Jun 2022 12:09:18 +0200
Message-Id: <20220613094923.584769204@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit c4040212bc97d16040712a410335f93bc94d2262 ]

If the slang lib is not installed on the system, perf c2c tool disables TUI
mode and roll back to use stdio mode;  but the flag 'c2c.use_stdio' is
missed to set true and thus it wrongly applies UI quirks in the function
ui_quirks().

This commit forces to use stdio interface if slang is not supported, and
it can avoid to apply the UI quirks and show the correct metric header.

Before:

=================================================
      Shared Cache Line Distribution Pareto
=================================================
  -------------------------------------------------------------------------------
      0        0        0       99        0        0        0      0xaaaac17d6000
  -------------------------------------------------------------------------------
    0.00%    0.00%    6.06%    0.00%    0.00%    0.00%   0x20   N/A       0      0xaaaac17c25ac         0         0        43       375    18469         2  [.] 0x00000000000025ac  memstress         memstress[25ac]   0
    0.00%    0.00%   93.94%    0.00%    0.00%    0.00%   0x29   N/A       0      0xaaaac17c3e88         0         0       173       180      135         2  [.] 0x0000000000003e88  memstress         memstress[3e88]   0

After:

=================================================
      Shared Cache Line Distribution Pareto
=================================================
  -------------------------------------------------------------------------------
      0        0        0       99        0        0        0      0xaaaac17d6000
  -------------------------------------------------------------------------------
           0.00%    0.00%    6.06%    0.00%    0.00%    0.00%                0x20   N/A       0      0xaaaac17c25ac         0         0        43       375    18469         2  [.] 0x00000000000025ac  memstress         memstress[25ac]   0
           0.00%    0.00%   93.94%    0.00%    0.00%    0.00%                0x29   N/A       0      0xaaaac17c3e88         0         0       173       180      135         2  [.] 0x0000000000003e88  memstress         memstress[3e88]   0

Fixes: 5a1a99cd2e4e1557 ("perf c2c report: Add main TUI browser")
Reported-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20220526145400.611249-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 264d458bfe2a..9cbd8b0d5b77 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2552,9 +2552,7 @@ static int perf_c2c__report(int argc, const char **argv)
 		   "the input file to process"),
 	OPT_INCR('N', "node-info", &c2c.node_info,
 		 "show extra node info in report (repeat for more info)"),
-#ifdef HAVE_SLANG_SUPPORT
 	OPT_BOOLEAN(0, "stdio", &c2c.use_stdio, "Use the stdio interface"),
-#endif
 	OPT_BOOLEAN(0, "stats", &c2c.stats_only,
 		    "Display only statistic tables (implies --stdio)"),
 	OPT_BOOLEAN(0, "full-symbols", &c2c.symbol_full,
@@ -2581,6 +2579,10 @@ static int perf_c2c__report(int argc, const char **argv)
 	if (argc)
 		usage_with_options(report_c2c_usage, options);
 
+#ifndef HAVE_SLANG_SUPPORT
+	c2c.use_stdio = true;
+#endif
+
 	if (c2c.stats_only)
 		c2c.use_stdio = true;
 
-- 
2.35.1



