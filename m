Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AC65B78DA
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiIMRwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233581AbiIMRwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:52:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A444BD1F;
        Tue, 13 Sep 2022 09:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF1C9614AF;
        Tue, 13 Sep 2022 14:14:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C44C433C1;
        Tue, 13 Sep 2022 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078479;
        bh=4oZ5FV3SpXOnsRCvFeQWFDTKkVKem96ATvOhCxEitUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QbsguFJTgKoWgQDLJMwpxmhrALtbNrYLwXLlRo6zHxBhKSjfA4b/GBa62pD4rsFZM
         MXWDZqbBFZzCJxgl7yvRop6NULH2hIKRNlDfgVjy1ZseqDcEemnF/3CjQgbpCzlVik
         bm59lBwuB3MPgpX+s99TAjUuCFgxabk5WT4KCHe4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 155/192] perf record: Fix synthesis failure warnings
Date:   Tue, 13 Sep 2022 16:04:21 +0200
Message-Id: <20220913140417.747857041@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

[ Upstream commit faf59ec8c3c3708c64ff76b50e6f757c6b4a1054 ]

Some calls to synthesis functions set err < 0 but only warn about the
failure and continue.  However they do not set err back to zero, relying
on subsequent code to do that.

That changed with the introduction of option --synth. When --synth=no
subsequent functions that set err back to zero are not called.

Fix by setting err = 0 in those cases.

Example:

 Before:

   $ perf record --no-bpf-event --synth=all -o /tmp/huh uname
   Couldn't synthesize bpf events.
   Linux
   [ perf record: Woken up 1 times to write data ]
   [ perf record: Captured and wrote 0.014 MB /tmp/huh (7 samples) ]
   $ perf record --no-bpf-event --synth=no -o /tmp/huh uname
   Couldn't synthesize bpf events.

 After:

   $ perf record --no-bpf-event --synth=no -o /tmp/huh uname
   Couldn't synthesize bpf events.
   Linux
   [ perf record: Woken up 1 times to write data ]
   [ perf record: Captured and wrote 0.014 MB /tmp/huh (7 samples) ]

Fixes: 41b740b6e8a994e5 ("perf record: Add --synth option")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220907162458.72817-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 9a71f0330137e..68c878b4e5e4c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -1892,14 +1892,18 @@ static int record__synthesize(struct record *rec, bool tail)
 
 	err = perf_event__synthesize_bpf_events(session, process_synthesized_event,
 						machine, opts);
-	if (err < 0)
+	if (err < 0) {
 		pr_warning("Couldn't synthesize bpf events.\n");
+		err = 0;
+	}
 
 	if (rec->opts.synth & PERF_SYNTH_CGROUP) {
 		err = perf_event__synthesize_cgroups(tool, process_synthesized_event,
 						     machine);
-		if (err < 0)
+		if (err < 0) {
 			pr_warning("Couldn't synthesize cgroup events.\n");
+			err = 0;
+		}
 	}
 
 	if (rec->opts.nr_threads_synthesize > 1) {
-- 
2.35.1



