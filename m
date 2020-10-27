Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA72529B975
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1782683AbgJ0Ptb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:49:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801316AbgJ0Pjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBCA022283;
        Tue, 27 Oct 2020 15:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813180;
        bh=Btd7IWAeJ0U6EIXgwPXbgAZarnyDjbuPsfPp8MOowdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1X5WfCzpSFoiXYS3z9UQspsHGydxl4z3bsf3bmb+XuLWlcQJYMnq+S0KXY+PDWUB3
         R4dWzoLxxI+SJOcCoEJAHi9I1h7WKBAkApfKIY6uqUn7eVZwRqXALamNZDRx2fBMPI
         htvWUtO9Qk3Xeak08b5nxUqpH1aS+NQ36pcqRhZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jin Yao <yao.jin@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 464/757] perf stat: Skip duration_time in setup_system_wide
Date:   Tue, 27 Oct 2020 14:51:54 +0100
Message-Id: <20201027135512.280195510@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

[ Upstream commit 002a3d690f95804bdef6b70b26154103518e13d9 ]

Some metrics (such as DRAM_BW_Use) consists of uncore events and
duration_time. For uncore events, counter->core.system_wide is true. But
for duration_time, counter->core.system_wide is false so
target.system_wide is set to false.

Then 'enable_on_exec' is set in perf_event_attr of uncore event.  Kernel
will return error when trying to open the uncore event.

This patch skips the duration_time in setup_system_wide then
target.system_wide will be set to true for the evlist of uncore events +
duration_time.

Before (tested on skylake desktop):

  # perf stat -M DRAM_BW_Use -- sleep 1
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (arb/event=0x84,umask=0x1/).
  /bin/dmesg | grep -i perf may provide additional information.

After:

  # perf stat -M DRAM_BW_Use -- sleep 1

   Performance counter stats for 'system wide':

                169      arb/event=0x84,umask=0x1/ #     0.00 DRAM_BW_Use
             40,427      arb/event=0x81,umask=0x1/
      1,000,902,197 ns   duration_time

        1.000902197 seconds time elapsed

Fixes: e3ba76deef23064f ("perf tools: Force uncore events to system wide monitoring")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Yao <yao.jin@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200922015004.30114-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index fddc97cac9841..eef64b1411a4a 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2063,8 +2063,10 @@ static void setup_system_wide(int forks)
 		struct evsel *counter;
 
 		evlist__for_each_entry(evsel_list, counter) {
-			if (!counter->core.system_wide)
+			if (!counter->core.system_wide &&
+			    strcmp(counter->name, "duration_time")) {
 				return;
+			}
 		}
 
 		if (evsel_list->core.nr_entries)
-- 
2.25.1



