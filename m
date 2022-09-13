Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9362A5B7357
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbiIMPMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:12:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiIMPKx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E617821D;
        Tue, 13 Sep 2022 07:32:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D826614A8;
        Tue, 13 Sep 2022 14:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D91C433C1;
        Tue, 13 Sep 2022 14:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078898;
        bh=aVUuVMh2ZLmIwX+5ejz94R5HzVm9nu/nwMUZ/Qmoexo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAMJhnIdxm4V5u/uuKGCcAUjX5iGuHrmOVe3TylEZDmNllQ3lTDC7ZioQiPhMFoy/
         uToir2jL38qPQRNmWVjxf+PDHclv1Tvee8SGgOcW9zgIp9ptS7TvT5vrImWeiB2LhK
         X+EBKKrx6WkD3pFcni63dZ+eMF/P2QmhFj36fu3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 099/121] perf script: Fix Cannot print iregs field for hybrid systems
Date:   Tue, 13 Sep 2022 16:04:50 +0200
Message-Id: <20220913140401.607238757@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

[ Upstream commit 82b2425fad2dd47204b3da589b679220f8aacc0e ]

Commit b91e5492f9d7ca89 ("perf record: Add a dummy event on hybrid
systems to collect metadata records") adds a dummy event on hybrid
systems to fix the symbol "unknown" issue when the workload is created
in a P-core but runs on an E-core. The added dummy event will cause
"perf script -F iregs" to fail. Dummy events do not have "iregs"
attribute set, so when we do evsel__check_attr, the "iregs" attribute
check will fail, so the issue happened.

The following commit [1] has fixed a similar issue by skipping the attr
check for the dummy event because it does not have any samples anyway. It
works okay for the normal mode, but the issue still happened when running
the test in the pipe mode. In the pipe mode, it calls process_attr() which
still checks the attr for the dummy event. This commit fixed the issue by
skipping the attr check for the dummy event in the API evsel__check_attr,
Otherwise, we have to patch everywhere when evsel__check_attr() is called.

Before:

  #./perf record -o - --intr-regs=di,r8,dx,cx -e br_inst_retired.near_call:p -c 1000 --per-thread true 2>/dev/null|./perf script -F iregs |head -5
  Samples for 'dummy:HG' event do not have IREGS attribute set. Cannot print 'iregs' field.
  0x120 [0x90]: failed to process type: 64
  #

After:

  # ./perf record -o - --intr-regs=di,r8,dx,cx -e br_inst_retired.near_call:p -c 1000 --per-thread true 2>/dev/null|./perf script -F iregs |head -5
  ABI:2    CX:0x55b8efa87000    DX:0x55b8efa7e000    DI:0xffffba5e625efbb0    R8:0xffff90e51f8ae100
  ABI:2    CX:0x7f1dae1e4000    DX:0xd0    DI:0xffff90e18c675ac0    R8:0x71
  ABI:2    CX:0xcc0    DX:0x1    DI:0xffff90e199880240    R8:0x0
  ABI:2    CX:0xffff90e180dd7500    DX:0xffff90e180dd7500    DI:0xffff90e180043500    R8:0x1
  ABI:2    CX:0x50    DX:0xffff90e18c583bd0    DI:0xffff90e1998803c0    R8:0x58
  #

[1]https://lore.kernel.org/lkml/20220831124041.219925-1-jolsa@kernel.org/

Fixes: b91e5492f9d7ca89 ("perf record: Add a dummy event on hybrid systems to collect metadata records")
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220908070030.3455164-1-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index cb3d81adf5ca8..c6c40191933d4 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -435,6 +435,9 @@ static int evsel__check_attr(struct evsel *evsel, struct perf_session *session)
 	struct perf_event_attr *attr = &evsel->core.attr;
 	bool allow_user_set;
 
+	if (evsel__is_dummy_event(evsel))
+		return 0;
+
 	if (perf_header__has_feat(&session->header, HEADER_STAT))
 		return 0;
 
-- 
2.35.1



