Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25D7699E20
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391359AbfHVRWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389922AbfHVRWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:22:33 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 130E2233FC;
        Thu, 22 Aug 2019 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494551;
        bh=wFXr6o0CMvZOfkyvKcHNIhG35KGlq6I6IwnLPxhXtP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOYlCnP4fHPi7XBDrZyPspUkQWjJu0Nnsfij8CB1EUyXsgmYoiJslqZ3POGn56eYL
         ixtGG71iqaOh2TAi0Ofz8AhdN7OCeUsMg4PWSdWQU0CU+QI6mO+aDJ/j+ibfnR6oqm
         INCusfTaDjnU+phR73vuh44FnunrHZUIwjFD/BE8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.4 06/78] perf db-export: Fix thread__exec_comm()
Date:   Thu, 22 Aug 2019 10:18:10 -0700
Message-Id: <20190822171832.229259797@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171832.012773482@linuxfoundation.org>
References: <20190822171832.012773482@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 3de7ae0b2a1d86dbb23d0cb135150534fdb2e836 upstream.

Threads synthesized from /proc have comms with a start time of zero, and
not marked as "exec". Currently, there can be 2 such comms. The first is
created by processing a synthesized fork event and is set to the
parent's comm string, and the second by processing a synthesized comm
event set to the thread's current comm string.

In the absence of an "exec" comm, thread__exec_comm() picks the last
(oldest) comm, which, in the case above, is the parent's comm string.
For a main thread, that is very probably wrong. Use the second-to-last
in that case.

This affects only db-export because it is the only user of
thread__exec_comm().

Example:

  $ sudo perf record -a -o pt-a-sleep-1 -e intel_pt//u -- sleep 1
  $ sudo chown ahunter pt-a-sleep-1

Before:

  $ perf script -i pt-a-sleep-1 --itrace=bep -s tools/perf/scripts/python/export-to-sqlite.py pt-a-sleep-1.db branches calls
  $ sqlite3 -header -column pt-a-sleep-1.db 'select * from comm_threads_view'
  comm_id     command     thread_id   pid         tid
  ----------  ----------  ----------  ----------  ----------
  1           swapper     1           0           0
  2           rcu_sched   2           10          10
  3           kthreadd    3           78          78
  5           sudo        4           15180       15180
  5           sudo        5           15180       15182
  7           kworker/4:  6           10335       10335
  8           kthreadd    7           55          55
  10          systemd     8           865         865
  10          systemd     9           865         875
  13          perf        10          15181       15181
  15          sleep       10          15181       15181
  16          kworker/3:  11          14179       14179
  17          kthreadd    12          29376       29376
  19          systemd     13          746         746
  21          systemd     14          401         401
  23          systemd     15          879         879
  23          systemd     16          879         945
  25          kthreadd    17          556         556
  27          kworker/u1  18          14136       14136
  28          kworker/u1  19          15021       15021
  29          kthreadd    20          509         509
  31          systemd     21          836         836
  31          systemd     22          836         967
  33          systemd     23          1148        1148
  33          systemd     24          1148        1163
  35          kworker/2:  25          17988       17988
  36          kworker/0:  26          13478       13478

After:

  $ perf script -i pt-a-sleep-1 --itrace=bep -s tools/perf/scripts/python/export-to-sqlite.py pt-a-sleep-1b.db branches calls
  $ sqlite3 -header -column pt-a-sleep-1b.db 'select * from comm_threads_view'
  comm_id     command     thread_id   pid         tid
  ----------  ----------  ----------  ----------  ----------
  1           swapper     1           0           0
  2           rcu_sched   2           10          10
  3           kswapd0     3           78          78
  4           perf        4           15180       15180
  4           perf        5           15180       15182
  6           kworker/4:  6           10335       10335
  7           kcompactd0  7           55          55
  8           accounts-d  8           865         865
  8           accounts-d  9           865         875
  10          perf        10          15181       15181
  12          sleep       10          15181       15181
  13          kworker/3:  11          14179       14179
  14          kworker/1:  12          29376       29376
  15          haveged     13          746         746
  16          systemd-jo  14          401         401
  17          NetworkMan  15          879         879
  17          NetworkMan  16          879         945
  19          irq/131-iw  17          556         556
  20          kworker/u1  18          14136       14136
  21          kworker/u1  19          15021       15021
  22          kworker/u1  20          509         509
  23          thermald    21          836         836
  23          thermald    22          836         967
  25          unity-sett  23          1148        1148
  25          unity-sett  24          1148        1163
  27          kworker/2:  25          17988       17988
  28          kworker/0:  26          13478       13478

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 65de51f93ebf ("perf tools: Identify which comms are from exec")
Link: http://lkml.kernel.org/r/20190808064823.14846-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/thread.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -110,14 +110,24 @@ struct comm *thread__comm(const struct t
 
 struct comm *thread__exec_comm(const struct thread *thread)
 {
-	struct comm *comm, *last = NULL;
+	struct comm *comm, *last = NULL, *second_last = NULL;
 
 	list_for_each_entry(comm, &thread->comm_list, list) {
 		if (comm->exec)
 			return comm;
+		second_last = last;
 		last = comm;
 	}
 
+	/*
+	 * 'last' with no start time might be the parent's comm of a synthesized
+	 * thread (created by processing a synthesized fork event). For a main
+	 * thread, that is very probably wrong. Prefer a later comm to avoid
+	 * that case.
+	 */
+	if (second_last && !last->start && thread->pid_ == thread->tid)
+		return second_last;
+
 	return last;
 }
 


