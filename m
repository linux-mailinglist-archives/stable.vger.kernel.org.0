Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58F7D2E3DE8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437935AbgL1OVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502547AbgL1OVV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2774206D4;
        Mon, 28 Dec 2020 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165266;
        bh=dmCA1ZTHiAWZ1xMo2G0cukPuVJeRhepqlpgejjsNbws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iUx9wbQfcnaLouHrOwi3aOYpZMrGn547WpK79XMfMbjQNtLurBpBgAeZ1Y12m10yA
         Ij3X1sDZpEISlAAX4fKZHSMi9WQtmObk+urCm4u00tQEz+3aYsXli1qsF8owjM/x7X
         H/E0Dee2afvSqq4koHJ/uMDNHp5f8K+cmv6I+SOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kajol Jain <kjain@linux.ibm.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 444/717] perf test: Fix metric parsing test
Date:   Mon, 28 Dec 2020 13:47:22 +0100
Message-Id: <20201228125042.243540131@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit b2ce5dbc15819ea4bef47dbd368239cb1e965158 ]

Commit e1c92a7fbbc5 ("perf tests: Add another metric parsing test") add
another test for metric parsing. The test goes through all metrics
compiled for arch within pmu events and try to parse them.

Right now this test is failing in powerpc machine.

Result in power9 platform:

  [command]# ./perf test 10
  10: PMU events                                                      :
  10.1: PMU event table sanity                                        : Ok
  10.2: PMU event map aliases                                         : Ok
  10.3: Parsing of PMU event table metrics                            : Skip (some metrics failed)
  10.4: Parsing of PMU event table metrics with fake PMUs             : FAILED!

Issue is we are passing different runtime parameter value in
"expr__find_other" and "expr__parse" function which is called from
function `metric_parse_fake`.  And because of this parsing of hv-24x7
metrics is failing.

  [command]# ./perf test 10 -vv
  .....
  hv_24x7/pm_mcs01_128b_rd_disp_port01,chip=1/ not found
  expr__parse failed
  test child finished with -1
  ---- end ----
  PMU events subtest 4: FAILED!

This patch fix this issue and change runtime parameter value to '0' in
expr__parse function.

Result in power9 platform after this patch:

  [command]# ./perf test 10
  10: PMU events                                                      :
  10.1: PMU event table sanity                                        : Ok
  10.2: PMU event map aliases                                         : Ok
  10.3: Parsing of PMU event table metrics                            : Skip (some metrics failed)
  10.4: Parsing of PMU event table metrics with fake PMUs             : Ok

Fixes: e1c92a7fbbc5 ("perf tests: Add another metric parsing test")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Acked-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Link: http://lore.kernel.org/lkml/20201119152411.46041-1-kjain@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/pmu-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/pmu-events.c b/tools/perf/tests/pmu-events.c
index d3517a74d95e3..31f987bb7ebba 100644
--- a/tools/perf/tests/pmu-events.c
+++ b/tools/perf/tests/pmu-events.c
@@ -561,7 +561,7 @@ static int metric_parse_fake(const char *str)
 		}
 	}
 
-	if (expr__parse(&result, &ctx, str, 1))
+	if (expr__parse(&result, &ctx, str, 0))
 		pr_err("expr__parse failed\n");
 	else
 		ret = 0;
-- 
2.27.0



