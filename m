Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE34126D5A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728241AbfLSSje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:39:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbfLSSje (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:39:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E402220716;
        Thu, 19 Dec 2019 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780773;
        bh=UJD928C7anYrORACAu6Oao0G9JR8oRn8ffJSvKjKt3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJBuLZMBeK4bejroaSDA+2OOm7nrfrISG27JG6x4OStMzi0QkDoKcmJO986gN6iqp
         K47+h4C95KRrCze9l/qTCtz3AQseOD64uWKAqih3rflUYIbUPGxl8rVIYE5L3DNFyC
         EpjS0Z6XOi/dC/Ib0His69tF16YPiXPgf4gvKg+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.4 109/162] cgroup: pids: use atomic64_t for pids->limit
Date:   Thu, 19 Dec 2019 19:33:37 +0100
Message-Id: <20191219183214.393367665@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
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
 kernel/cgroup_pids.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/kernel/cgroup_pids.c
+++ b/kernel/cgroup_pids.c
@@ -48,7 +48,7 @@ struct pids_cgroup {
 	 * %PIDS_MAX = (%PID_MAX_LIMIT + 1).
 	 */
 	atomic64_t			counter;
-	int64_t				limit;
+	atomic64_t			limit;
 };
 
 static struct pids_cgroup *css_pids(struct cgroup_subsys_state *css)
@@ -70,8 +70,8 @@ pids_css_alloc(struct cgroup_subsys_stat
 	if (!pids)
 		return ERR_PTR(-ENOMEM);
 
-	pids->limit = PIDS_MAX;
 	atomic64_set(&pids->counter, 0);
+	atomic64_set(&pids->limit, PIDS_MAX);
 	return &pids->css;
 }
 
@@ -142,13 +142,14 @@ static int pids_try_charge(struct pids_c
 
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
 
@@ -262,7 +263,7 @@ set_limit:
 	 * Limit updates don't need to be mutex'd, since it isn't
 	 * critical that any racing fork()s follow the new limit.
 	 */
-	pids->limit = limit;
+	atomic64_set(&pids->limit, limit);
 	return nbytes;
 }
 
@@ -270,7 +271,7 @@ static int pids_max_show(struct seq_file
 {
 	struct cgroup_subsys_state *css = seq_css(sf);
 	struct pids_cgroup *pids = css_pids(css);
-	int64_t limit = pids->limit;
+	int64_t limit = atomic64_read(&pids->limit);
 
 	if (limit >= PIDS_MAX)
 		seq_printf(sf, "%s\n", PIDS_MAX_STR);


