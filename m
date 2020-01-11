Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E915913800B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgAKKZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:25:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbgAKKZW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:25:22 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 753BE205F4;
        Sat, 11 Jan 2020 10:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738320;
        bh=sldSkO1ZDdvT4JmhXAeCYgpRfznRSyIKMRuGQ4NGc0w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W93qfeUva1z+VeJ8sIsFi0UiF3FQVYBMh/TpO6qdMEA0tkm1kRaITYKGA2LS2zFm7
         lt8GP3K5ncciJ/+BmJE2xocLrP8Ba0+d2dA7z0mTJxhibstqEAcHuOYO+9qdyDC6K2
         uQtINfrRhTtb1rUW1E2YmnAvIX+oUlXfd04OZYEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kajol Jain <kjain@linux.ibm.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Anju T Sudhakar <anju@linux.vnet.ibm.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Madhavan Srinivasan <maddy@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/165] perf metricgroup: Fix printing event names of metric group with multiple events
Date:   Sat, 11 Jan 2020 10:49:35 +0100
Message-Id: <20200111094925.944708753@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit eb573e746b9d4f0921dcb2449be3df41dae3caea ]

Commit f01642e4912b ("perf metricgroup: Support multiple events for
metricgroup") introduced support for multiple events in a metric group.
But with the current upstream, metric events names are not printed
properly

In power9 platform:

command:# ./perf stat --metric-only -M translation -C 0 -I 1000 sleep 2
     1.000208486
     2.000368863
     2.001400558

Similarly in skylake platform:

command:./perf stat --metric-only -M Power -I 1000
     1.000579994
     2.002189493

With current upstream version, issue is with event name comparison logic
in find_evsel_group(). Current logic is to compare events belonging to a
metric group to the events in perf_evlist.  Since the break statement is
missing in the loop used for comparison between metric group and
perf_evlist events, the loop continues to execute even after getting a
pattern match, and end up in discarding the matches.

Incase of single metric event belongs to metric group, its working fine,
because in case of single event once it compare all events it reaches to
end of perf_evlist.

Example for single metric event in power9 platform:

command:# ./perf stat --metric-only  -M branches_per_inst -I 1000 sleep 1
     1.000094653                  0.2
     1.001337059                  0.0

This patch fixes the issue by making sure once we found all events
belongs to that metric event matched in find_evsel_group(), we
successfully break from that loop by adding corresponding condition.

With this patch:
In power9 platform:

command:# ./perf stat --metric-only -M translation -C 0 -I 1000 sleep 2
result:#
            time  derat_4k_miss_rate_percent  derat_4k_miss_ratio derat_miss_ratio derat_64k_miss_rate_percent  derat_64k_miss_ratio dslb_miss_rate_percent islb_miss_rate_percent
     1.000135672                         0.0                  0.3              1.0                         0.0                   0.2                    0.0                    0.0
     2.000380617                         0.0                  0.0              0.0                         0.0                   0.0                    0.0                    0.0

command:# ./perf stat --metric-only -M Power -I 1000

Similarly in skylake platform:
result:#
            time    Turbo_Utilization    C3_Core_Residency  C6_Core_Residency  C7_Core_Residency    C2_Pkg_Residency  C3_Pkg_Residency     C6_Pkg_Residency   C7_Pkg_Residency
     1.000563580                  0.3                  0.0                2.6               44.2                21.9               0.0                  0.0               0.0
     2.002235027                  0.4                  0.0                2.7               43.0                20.7               0.0                  0.0               0.0

Committer testing:

  Before:

  [root@seventh ~]# perf stat --metric-only -M Power -I 1000
  #           time
       1.000383223
       2.001168182
       3.001968545
       4.002741200
       5.003442022
  ^C     5.777687244

  [root@seventh ~]#

  After the patch:

  [root@seventh ~]# perf stat --metric-only -M Power -I 1000
  #           time    Turbo_Utilization    C3_Core_Residency    C6_Core_Residency    C7_Core_Residency     C2_Pkg_Residency     C3_Pkg_Residency     C6_Pkg_Residency     C7_Pkg_Residency
       1.000406577                  0.4                  0.1                  1.4                 97.0                  0.0                  0.0                  0.0                  0.0
       2.001481572                  0.3                  0.0                  0.6                 97.9                  0.0                  0.0                  0.0                  0.0
       3.002332585                  0.2                  0.0                  1.0                 97.5                  0.0                  0.0                  0.0                  0.0
       4.003196624                  0.2                  0.0                  0.3                 98.6                  0.0                  0.0                  0.0                  0.0
       5.004063851                  0.3                  0.0                  0.7                 97.7                  0.0                  0.0                  0.0                  0.0
  ^C     5.471260276                  0.2                  0.0                  0.5                 49.3                  0.0                  0.0                  0.0                  0.0

  [root@seventh ~]#
  [root@seventh ~]# dmesg | grep -i skylake
  [    0.187807] Performance Events: PEBS fmt3+, Skylake events, 32-deep LBR, full-width counters, Intel PMU driver.
  [root@seventh ~]#

Fixes: f01642e4912b ("perf metricgroup: Support multiple events for metricgroup")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Reviewed-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anju T Sudhakar <anju@linux.vnet.ibm.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20191120084059.24458-1-kjain@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/metricgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index a7c0424dbda3..940a6e7a6854 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -103,8 +103,11 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 		if (!strcmp(ev->name, ids[i])) {
 			if (!metric_events[i])
 				metric_events[i] = ev;
+			i++;
+			if (i == idnum)
+				break;
 		} else {
-			if (++i == idnum) {
+			if (i + 1 == idnum) {
 				/* Discard the whole match and start again */
 				i = 0;
 				memset(metric_events, 0,
@@ -124,7 +127,7 @@ static struct evsel *find_evsel_group(struct evlist *perf_evlist,
 		}
 	}
 
-	if (i != idnum - 1) {
+	if (i != idnum) {
 		/* Not whole match */
 		return NULL;
 	}
-- 
2.20.1



