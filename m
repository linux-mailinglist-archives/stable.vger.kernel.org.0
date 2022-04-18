Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05D55051FD
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbiDRMko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240836AbiDRMjk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3E8CCF;
        Mon, 18 Apr 2022 05:31:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95323B80EC1;
        Mon, 18 Apr 2022 12:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42BEC385A1;
        Mon, 18 Apr 2022 12:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285068;
        bh=SZJF1zbsC4uu0BF6I10onqFwthdm5Qnyw+4Kau8Mzbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU9YeyogDHm8iBHNbYAhmBbpvplA/Yqi5YWYlRKnQaXBfIzZlMR4vunCPZ0OUdSjm
         QncAiAn7tzazyXUc7D5b4qN4bXZdQL0aNDLTEQcckj3HcO3bMtTJ0brslmukaFe7eW
         hTy162NH3iUGiatVce7nJQ4l2GE0/ZwwSbNg8sWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/189] perf tools: Fix misleading add event PMU debug message
Date:   Mon, 18 Apr 2022 14:11:56 +0200
Message-Id: <20220418121203.229108584@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index 51a2219df601..3bfe099d8643 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1529,7 +1529,9 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 	bool use_uncore_alias;
 	LIST_HEAD(config_terms);
 
-	if (verbose > 1) {
+	pmu = parse_state->fake_pmu ?: perf_pmu__find(name);
+
+	if (verbose > 1 && !(pmu && pmu->selectable)) {
 		fprintf(stderr, "Attempting to add event pmu '%s' with '",
 			name);
 		if (head_config) {
@@ -1542,7 +1544,6 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 		fprintf(stderr, "' that may result in non-fatal errors\n");
 	}
 
-	pmu = parse_state->fake_pmu ?: perf_pmu__find(name);
 	if (!pmu) {
 		char *err_str;
 
-- 
2.35.1



