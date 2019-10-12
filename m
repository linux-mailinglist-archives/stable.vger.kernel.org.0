Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1BBD4BAC
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 03:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfJLBGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 21:06:17 -0400
Received: from mx2a.mailbox.org ([80.241.60.219]:57995 "EHLO mx2a.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726863AbfJLBGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 21:06:17 -0400
Received: from smtp2.mailbox.org (smtp2.mailbox.org [80.241.60.241])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2a.mailbox.org (Postfix) with ESMTPS id B4EABA1585;
        Sat, 12 Oct 2019 03:06:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id HpnuEwOz63oE; Sat, 12 Oct 2019 03:06:11 +0200 (CEST)
From:   Aleksa Sarai <cyphar@cyphar.com>
To:     Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>, stable@vger.kernel.org
Subject: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit operations
Date:   Sat, 12 Oct 2019 12:05:39 +1100
Message-Id: <20191012010539.6131-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Because pids->limit can be changed concurrently (but we don't want to
take a lock because it would be needlessly expensive), use the
appropriate memory barriers.

Fixes: commit 49b786ea146f ("cgroup: implement the PIDs subsystem")
Cc: stable@vger.kernel.org # v4.3+
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 kernel/cgroup/pids.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/pids.c b/kernel/cgroup/pids.c
index 8e513a573fe9..a726e4a20177 100644
--- a/kernel/cgroup/pids.c
+++ b/kernel/cgroup/pids.c
@@ -152,7 +152,7 @@ static int pids_try_charge(struct pids_cgroup *pids, int num)
 		 * p->limit is %PIDS_MAX then we know that this test will never
 		 * fail.
 		 */
-		if (new > p->limit)
+		if (new > READ_ONCE(p->limit))
 			goto revert;
 	}
 
@@ -277,7 +277,7 @@ static ssize_t pids_max_write(struct kernfs_open_file *of, char *buf,
 	 * Limit updates don't need to be mutex'd, since it isn't
 	 * critical that any racing fork()s follow the new limit.
 	 */
-	pids->limit = limit;
+	WRITE_ONCE(pids->limit, limit);
 	return nbytes;
 }
 
@@ -285,7 +285,7 @@ static int pids_max_show(struct seq_file *sf, void *v)
 {
 	struct cgroup_subsys_state *css = seq_css(sf);
 	struct pids_cgroup *pids = css_pids(css);
-	int64_t limit = pids->limit;
+	int64_t limit = READ_ONCE(pids->limit);
 
 	if (limit >= PIDS_MAX)
 		seq_printf(sf, "%s\n", PIDS_MAX_STR);
-- 
2.23.0

