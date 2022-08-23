Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0848359D9B4
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345291AbiHWKAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345397AbiHWJ6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:58:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0E8A1D6D;
        Tue, 23 Aug 2022 01:48:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8BABDCE1B53;
        Tue, 23 Aug 2022 08:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E49C433D7;
        Tue, 23 Aug 2022 08:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244481;
        bh=nd5+KB9Lr171c9+sykLDGdxdvhZMEc6ArTh1VfBEg5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gQ+lIUdQyWqBqaVSRdiODBTW0I9K8KBPpIZ2dB0diJMcyybHiUjEElaDG3KzInE+v
         2B6FrojRfOhkwIJVLkHXhW8fDgnzgso/8/hanQ+0LI00pH5k7yg3cyBQD1hmHegqpC
         MzXUfYIyS3bDXH1IuVRR8KSFXrJbSpcXB9fEmP4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 100/244] perf parse-events: Fix segfault when event parser gets an error
Date:   Tue, 23 Aug 2022 10:24:19 +0200
Message-Id: <20220823080102.374205156@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -196,9 +196,12 @@ static int tp_event_has_id(const char *d
 void parse_events__handle_error(struct parse_events_error *err, int idx,
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
@@ -224,6 +227,11 @@ void parse_events__handle_error(struct p
 		break;
 	}
 	err->num_errors++;
+	return;
+
+out_free:
+	free(str);
+	free(help);
 }
 
 struct tracepoint_path *tracepoint_id_to_path(u64 config)


