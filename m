Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E8E54071F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347622AbiFGRme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347691AbiFGRl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:41:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1264B12817C;
        Tue,  7 Jun 2022 10:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4243D61521;
        Tue,  7 Jun 2022 17:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E501C34119;
        Tue,  7 Jun 2022 17:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623227;
        bh=zUGWNpkSuhTUd8ndrp/NfGoBpdvKTMcgOzrrhZ4XplM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OsPSaeLqwCDYac0GA7QT/4mUE+macst8ZtM20UKxaf77zQW1mXpghnNh+oeQdXtd1
         /Y3ZJ9UCdtUEpQekat7soTjelDir6lWgrxXUxMww7sLymOhIO0PIuk28EOsYkQdWvk
         EnRiFyLGowIQV+PQag8AVCUhmvMAqic6iYLOhC6M=
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
Subject: [PATCH 5.10 342/452] perf c2c: Use stdio interface if slang is not supported
Date:   Tue,  7 Jun 2022 19:03:19 +0200
Message-Id: <20220607164918.748727861@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
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
index d5bea5d3cd51..7f7111d4b3ad 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -2694,9 +2694,7 @@ static int perf_c2c__report(int argc, const char **argv)
 		   "the input file to process"),
 	OPT_INCR('N', "node-info", &c2c.node_info,
 		 "show extra node info in report (repeat for more info)"),
-#ifdef HAVE_SLANG_SUPPORT
 	OPT_BOOLEAN(0, "stdio", &c2c.use_stdio, "Use the stdio interface"),
-#endif
 	OPT_BOOLEAN(0, "stats", &c2c.stats_only,
 		    "Display only statistic tables (implies --stdio)"),
 	OPT_BOOLEAN(0, "full-symbols", &c2c.symbol_full,
@@ -2725,6 +2723,10 @@ static int perf_c2c__report(int argc, const char **argv)
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



