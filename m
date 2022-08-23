Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885E659D508
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346442AbiHWIkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345873AbiHWIjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:39:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3977F14016;
        Tue, 23 Aug 2022 01:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46C40B81C48;
        Tue, 23 Aug 2022 08:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CBFC4314D;
        Tue, 23 Aug 2022 08:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242660;
        bh=lzzDnu9ep7+cqxHP4yyCabn1tT37/GrAU7qmCUqISIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2LkzkHXrGXZxBXQb68qY4KuUBx5v04Ruih/UQyZL3bCysHYSw90++Apz97MWtBBn
         nh1vmW7dyFKrkkTMRO3/v51JFZ/3EYH5CLbW9a/lD13IOWfAEWLEgdkh4BjCimOjV0
         7XWsSrmBzq3vkOmo8hDhRFu/QtImWfrhscJVNShg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.19 157/365] perf parse-events: Fix segfault when event parser gets an error
Date:   Tue, 23 Aug 2022 10:00:58 +0200
Message-Id: <20220823080124.797045620@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 2e828582b81f5bc76a4fe8e7812df259ab208302 upstream.

parse_events() is often called with parse_events_error set to NULL.
Make parse_events_error__handle() not segfault in that case.

A subsequent patch changes to avoid passing NULL in the first place.

Fixes: 43eb05d066795bdf ("perf tests: Support 'Track with sched_switch' test for hybrid")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220809080702.6921-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/parse-events.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2391,9 +2391,12 @@ void parse_events_error__exit(struct par
 void parse_events_error__handle(struct parse_events_error *err, int idx,
 				char *str, char *help)
 {
-	if (WARN(!str, "WARNING: failed to provide error string\n")) {
-		free(help);
-		return;
+	if (WARN(!str, "WARNING: failed to provide error string\n"))
+		goto out_free;
+	if (!err) {
+		/* Assume caller does not want message printed */
+		pr_debug("event syntax error: %s\n", str);
+		goto out_free;
 	}
 	switch (err->num_errors) {
 	case 0:
@@ -2419,6 +2422,11 @@ void parse_events_error__handle(struct p
 		break;
 	}
 	err->num_errors++;
+	return;
+
+out_free:
+	free(str);
+	free(help);
 }
 
 #define MAX_WIDTH 1000


