Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED15D95F4
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 17:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405805AbfJPPud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 11:50:33 -0400
Received: from mx2a.mailbox.org ([80.241.60.219]:62675 "EHLO mx2a.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfJPPud (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 11:50:33 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2a.mailbox.org (Postfix) with ESMTPS id A0AB7A1997;
        Wed, 16 Oct 2019 17:50:31 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter02.heinlein-hosting.de (spamfilter02.heinlein-hosting.de [80.241.56.116]) (amavisd-new, port 10030)
        with ESMTP id OKudKxDHTA-Z; Wed, 16 Oct 2019 17:50:28 +0200 (CEST)
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>, stable@vger.kernel.org
Subject: [PATCH v2] cgroup: pids: use atomic64_t for pids->limit
Date:   Thu, 17 Oct 2019 02:50:01 +1100
Message-Id: <20191016155001.13651-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Because pids->limit can be changed concurrently (but we don't want to
take a lock because it would be needlessly expensive), use atomic64_ts
instead.

Fixes: commit 49b786ea146f ("cgroup: implement the PIDs subsystem")
Cc: stable@vger.kernel.org # v4.3+
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
v2:
  * Switch to atomic64_t instead of using {READ,WRITE}_ONCE().
v1: <https://lore.kernel.org/lkml/20191012010539.6131-1-cyphar@cyphar.com/>

 kernel/cgroup/pids.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index 8e513a573fe9..138059eb730d 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -45,7 +45,7 @@ struct pids_cgroup {
 	 * %PIDS_MAX = (%PID_MAX_LIMIT + 1).
 	 */
 	atomic64_t			counter;
-	int64_t				limit;
+	atomic64_t			limit;
 
 	/* Handle for "pids.events" */
 	struct cgroup_file		events_file;
@@ -73,8 +73,8 @@ pids_css_alloc(struct cgroup_subsys_state *parent)
 	if (!pids)
 		return ERR_PTR(-ENOMEM);
 
-	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
+	atomic64_set(&pids->limit, PIDS_MAX);
 	atomic64_set(&pids->events_limit, 0);
 	return &pids->css;
 }
@@ -146,13 +146,14 @@ static int pids_try_charge(struct pids_cgroup *pids, int num)
 
 	for (p = pids; parent_pids(p); p = parent_pids(p)) {
 		int64_t new = atomic64_add_return(num, &p->counter);
+		int64_t limit = atomic64_read(&p->limit);
 
 		/*
 		 * Since new is capped to the maximum number of pid_t, if
 		 * p->limit is %PIDS_MAX then we know that this test will never
 		 * fail.
 		 */
-		if (new > p->limit)
+		if (new > limit)
 			goto revert;
 	}
 
@@ -277,7 +278,7 @@ static ssize_t pids_max_write(struct kernfs_open_file *of, char *buf,
 	 * Limit updates don't need to be mutex'd, since it isn't
 	 * critical that any racing fork()s follow the new limit.
 	 */
-	pids->limit = limit;
+	atomic64_set(&pids->limit, limit);
 	return nbytes;
 }
 
@@ -285,7 +286,7 @@ static int pids_max_show(struct seq_file *sf, void *v)
 {
 	struct cgroup_subsys_state *css = seq_css(sf);
 	struct pids_cgroup *pids = css_pids(css);
-	int64_t limit = pids->limit;
+	int64_t limit = atomic64_read(&pids->limit);
 
 	if (limit >= PIDS_MAX)
 		seq_printf(sf, "%s\n", PIDS_MAX_STR);
-- 
2.23.0

