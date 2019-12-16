Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0601216B1
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbfLPSL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:11:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbfLPSL4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:11:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CFD0206E0;
        Mon, 16 Dec 2019 18:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519915;
        bh=/e3NT3D/oOcYk73D5vg3cZsVrFVEhzX+Py48eq6U8rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2DW1/VnlDCZaMqeqcnMaMqXNrqW2t99c8lQOROZI0gxHC0jOcV0LpYIbbuTVpns+i
         +PwsLrKBKVoHuLdpIjGG5S0Fan96thSGdeB6bzyMdMRZMn+S1G7cpDkbFN93cOefKF
         3xGGcNJsYi16T+YHYNozKzHHPfh7FStv4pI00t90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.3 081/180] cgroup: pids: use atomic64_t for pids->limit
Date:   Mon, 16 Dec 2019 18:48:41 +0100
Message-Id: <20191216174831.366662424@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksa Sarai <cyphar@cyphar.com>

commit a713af394cf382a30dd28a1015cbe572f1b9ca75 upstream.

Because pids->limit can be changed concurrently (but we don't want to
take a lock because it would be needlessly expensive), use atomic64_ts
instead.

Fixes: commit 49b786ea146f ("cgroup: implement the PIDs subsystem")
Cc: stable@vger.kernel.org # v4.3+
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/pids.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

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
@@ -73,8 +73,8 @@ pids_css_alloc(struct cgroup_subsys_stat
 	if (!pids)
 		return ERR_PTR(-ENOMEM);
 
-	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
+	atomic64_set(&pids->limit, PIDS_MAX);
 	atomic64_set(&pids->events_limit, 0);
 	return &pids->css;
 }
@@ -146,13 +146,14 @@ static int pids_try_charge(struct pids_c
 
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
 
@@ -277,7 +278,7 @@ set_limit:
 	 * Limit updates don't need to be mutex'd, since it isn't
 	 * critical that any racing fork()s follow the new limit.
 	 */
-	pids->limit = limit;
+	atomic64_set(&pids->limit, limit);
 	return nbytes;
 }
 
@@ -285,7 +286,7 @@ static int pids_max_show(struct seq_file
 {
 	struct cgroup_subsys_state *css = seq_css(sf);
 	struct pids_cgroup *pids = css_pids(css);
-	int64_t limit = pids->limit;
+	int64_t limit = atomic64_read(&pids->limit);
 
 	if (limit >= PIDS_MAX)
 		seq_printf(sf, "%s\n", PIDS_MAX_STR);


