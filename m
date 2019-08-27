Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 647139E111
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729665AbfH0IJF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730129AbfH0IFG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:05:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54B70206BF;
        Tue, 27 Aug 2019 08:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893105;
        bh=9XZ+Be4/yLcj+Tj426tFwAI0b4HEgWmZTt9ohu5MdwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfWi8MAW25IHN7A03ub1bbQ93IdwuquPuY+KaWpDM+QWTTJLHgSIpGIigO6MtqdiY
         dcDV0fOmmsBgYAnk4BJmlMriT9y6ZzIT6De9jLGbfK/eCLSnEtDUXkvkeGvIjHQUGl
         q8Icy1fe+uprQHAQyRwlKSppXajDyYmSV3Bt0ij0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jin Yao <yao.jin@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 105/162] perf pmu-events: Fix missing "cpu_clk_unhalted.core" event
Date:   Tue, 27 Aug 2019 09:50:33 +0200
Message-Id: <20190827072741.961103900@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 58f77fd0f59fe..ed5423d8a95fd 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -450,6 +450,7 @@ static struct fixed {
 	{ "inst_retired.any_p", "event=0xc0" },
 	{ "cpu_clk_unhalted.ref", "event=0x0,umask=0x03" },
 	{ "cpu_clk_unhalted.thread", "event=0x3c" },
+	{ "cpu_clk_unhalted.core", "event=0x3c" },
 	{ "cpu_clk_unhalted.thread_any", "event=0x3c,any=1" },
 	{ NULL, NULL},
 };
-- 
2.20.1



