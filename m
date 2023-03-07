Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0466AEA87
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbjCGRel (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjCGRe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:34:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB227A18A2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A322CB81995
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9C4C433EF;
        Tue,  7 Mar 2023 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210211;
        bh=KRX+EIj7U/159DChIw1KaO1QnLiFMDOVdoHwlHI0Jxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5/DGcE5hMJTQcytYFlBoOaLRGbtkUvLvSbyHb4nCVvuIrsA3Zd0kmTHR50lhfpNQ
         1lKGYN8NNRxwF3VL3Ygmu2xqaNLpahbuCXgZosmVJ41kXGbTFor3QYnfmbvrWC5zV2
         gTJqDPzPZlYKFFH+tSqz5h6VlIInaxqWEgD/vqIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kajol Jain <kjain@linux.ibm.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Caleb Biggers <caleb.biggers@intel.com>,
        Florian Fischer <florian.fischer@muhq.space>,
        Ingo Molnar <mingo@redhat.com>,
        James Clark <james.clark@arm.com>,
        Jing Zhang <renyu.zj@linux.alibaba.com>,
        Jiri Olsa <jolsa@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Kang Minchul <tegongkang@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Perry Taylor <perry.taylor@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi Bangoria <ravi.bangoria@amd.com>,
        Rob Herring <robh@kernel.org>,
        Sandipan Das <sandipan.das@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Will Deacon <will@kernel.org>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0469/1001] perf jevents: Correct bad character encoding
Date:   Tue,  7 Mar 2023 17:54:01 +0100
Message-Id: <20230307170041.744690788@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit d2e3dc829e389d686194d06f0a64adda4158faae ]

A character encoding issue added a "3D" character that breaks the
metrics test.

Fixes: 40769665b63d8c84 ("perf jevents: Parse metrics during conversion")
Reviewed-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Caleb Biggers <caleb.biggers@intel.com>
Cc: Florian Fischer <florian.fischer@muhq.space>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jing Zhang <renyu.zj@linux.alibaba.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Kang Minchul <tegongkang@gmail.com>
Cc: Kim Phillips <kim.phillips@amd.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Perry Taylor <perry.taylor@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Sandipan Das <sandipan.das@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://lore.kernel.org/r/20230126233645.200509-14-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/metric_test.py | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/pmu-events/metric_test.py b/tools/perf/pmu-events/metric_test.py
index 15315d0f716ca..6980f452df0ad 100644
--- a/tools/perf/pmu-events/metric_test.py
+++ b/tools/perf/pmu-events/metric_test.py
@@ -87,8 +87,8 @@ class TestMetricExpressions(unittest.TestCase):
     after = r'min((a + b if c > 1 else c + d), e + f)'
     self.assertEqual(ParsePerfJson(before).ToPerfJson(), after)
 
-    before =3D r'a if b else c if d else e'
-    after =3D r'(a if b else (c if d else e))'
+    before = r'a if b else c if d else e'
+    after = r'(a if b else (c if d else e))'
     self.assertEqual(ParsePerfJson(before).ToPerfJson(), after)
 
   def test_ToPython(self):
-- 
2.39.2



