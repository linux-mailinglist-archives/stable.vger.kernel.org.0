Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9578C77B
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfHNCY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:24:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbfHNCYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:24:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58EEB216F4;
        Wed, 14 Aug 2019 02:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749456;
        bh=sml/q+TWg4pt2Fx4C/8hXbbtwxpBWZ1jBQwrz6SBUFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xa1WSjIGln2iaXkhWBqT9Yfu+Rq7znpPksHiMNxpguseO0jf90LXsHZwb5FmyTYqE
         bgA8kmQYhxL4b4YVqDni/Y4kcQVn6MGirDepYcgRYjIFmh7LqGw2J6cv8T6+peRVqS
         PyIc3pVeKu0HC4NUv+euJ/wXyLo07wajuxI5sKFk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jin Yao <yao.jin@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jin Yao <yao.jin@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 32/33] perf pmu-events: Fix missing "cpu_clk_unhalted.core" event
Date:   Tue, 13 Aug 2019 22:23:22 -0400
Message-Id: <20190814022323.17111-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814022323.17111-1-sashal@kernel.org>
References: <20190814022323.17111-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit 8e6e5bea2e34c61291d00cb3f47560341aa84bc3 ]

The events defined in pmu-events JSON are parsed and added into perf
tool. For fixed counters, we handle the encodings between JSON and perf
by using a static array fixed[].

But the fixed[] has missed an important event "cpu_clk_unhalted.core".

For example, on the Tremont platform,

  [root@localhost ~]# perf stat -e cpu_clk_unhalted.core -a
  event syntax error: 'cpu_clk_unhalted.core'
                       \___ parser error

With this patch, the event cpu_clk_unhalted.core can be parsed.

  [root@localhost perf]# ./perf stat -e cpu_clk_unhalted.core -a -vvv
  ------------------------------------------------------------
  perf_event_attr:
    type                             4
    size                             112
    config                           0x3c
    sample_type                      IDENTIFIER
    read_format                      TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING
    disabled                         1
    inherit                          1
    exclude_guest                    1
  ------------------------------------------------------------
...

Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Yao <yao.jin@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20190729072755.2166-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/pmu-events/jevents.c b/tools/perf/pmu-events/jevents.c
index 41611d7f9873c..016d12af68773 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -315,6 +315,7 @@ static struct fixed {
 	{ "inst_retired.any_p", "event=0xc0" },
 	{ "cpu_clk_unhalted.ref", "event=0x0,umask=0x03" },
 	{ "cpu_clk_unhalted.thread", "event=0x3c" },
+	{ "cpu_clk_unhalted.core", "event=0x3c" },
 	{ "cpu_clk_unhalted.thread_any", "event=0x3c,any=1" },
 	{ NULL, NULL},
 };
-- 
2.20.1

