Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE175050AD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238895AbiDRM1L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbiDRM0c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:26:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC27D12760;
        Mon, 18 Apr 2022 05:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5561F60F0A;
        Mon, 18 Apr 2022 12:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E62BC385A1;
        Mon, 18 Apr 2022 12:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284440;
        bh=WQwPEHSCem5xKkdX+CUKjM6gepLC47qMUwijbu0hyO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lnixXNmPhPQo7NDLjQtujQHhWHyDEolAvkJHEINt2ZeYtZbA2QSBT6T8LgPhWmRHt
         A3AGtVGzlyct0z/kHOS6fNoHx4wsTJILMbWxcTQoYhSHmve7PoXe4I+DajIN/jR+7+
         NR1RYRX/LVFUsmB31Th45SrjnxNulTH04mvCB81c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 116/219] perf tools: Fix misleading add event PMU debug message
Date:   Mon, 18 Apr 2022 14:11:25 +0200
Message-Id: <20220418121210.146768167@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit f034fc50d3c7d9385c20d505ab4cf56b8fd18ac7 ]

Fix incorrect debug message:

   Attempting to add event pmu 'intel_pt' with '' that may result in
   non-fatal errors

which always appears with perf record -vv and intel_pt e.g.

    perf record -vv -e intel_pt//u uname

The message is incorrect because there will never be non-fatal errors.

Suppress the message if the PMU is 'selectable' i.e. meant to be
selected directly as an event.

Fixes: 4ac22b484d4c79e8 ("perf parse-events: Make add PMU verbose output clearer")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lore.kernel.org/lkml/20220411061758.2458417-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 24997925ae00..dd84fed698a3 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1523,7 +1523,9 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 	bool use_uncore_alias;
 	LIST_HEAD(config_terms);
 
-	if (verbose > 1) {
+	pmu = parse_state->fake_pmu ?: perf_pmu__find(name);
+
+	if (verbose > 1 && !(pmu && pmu->selectable)) {
 		fprintf(stderr, "Attempting to add event pmu '%s' with '",
 			name);
 		if (head_config) {
@@ -1536,7 +1538,6 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 		fprintf(stderr, "' that may result in non-fatal errors\n");
 	}
 
-	pmu = parse_state->fake_pmu ?: perf_pmu__find(name);
 	if (!pmu) {
 		char *err_str;
 
-- 
2.35.1



