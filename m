Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833602B5FD6
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbgKQM7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728696AbgKQM5j (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD35B2465E;
        Tue, 17 Nov 2020 12:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617858;
        bh=7BDpM/U1QXTcbiuS9/tXGhu9pULRxRWqkXsYrCCU214=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mE1eJ6jNdMNwsieVsaaccmnWRSCbhJjwJalLqkmR1XG7MAM1qZ6bv4cHugzhsaKmP
         Pq5grGL7dPsYwIgb70tsabNvRWsCT1UtWUB1ArncCOnLvi+lGF578Yg59Mb/XYGSVG
         iatx6ecVZscPt6pEIWFx+OvAhaV186+MdCTylW94=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Boqun Feng <boqun.feng@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 08/11] lockdep: Avoid to modify chain keys in validate_chain()
Date:   Tue, 17 Nov 2020 07:57:22 -0500
Message-Id: <20201117125725.599833-8-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125725.599833-1-sashal@kernel.org>
References: <20201117125725.599833-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit d61fc96a37603384cd531622c1e89de1096b5123 ]

Chris Wilson reported a problem spotted by check_chain_key(): a chain
key got changed in validate_chain() because we modify the ->read in
validate_chain() to skip checks for dependency adding, and ->read is
taken into calculation for chain key since commit f611e8cf98ec
("lockdep: Take read/write status in consideration when generate
chainkey").

Fix this by avoiding to modify ->read in validate_chain() based on two
facts: a) since we now support recursive read lock detection, there is
no need to skip checks for dependency adding for recursive readers, b)
since we have a), there is only one case left (nest_lock) where we want
to skip checks in validate_chain(), we simply remove the modification
for ->read and rely on the return value of check_deadlock() to skip the
dependency adding.

Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20201102053743.450459-1-boqun.feng@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index bca0f7f71cde4..7f29d9ae6fcfa 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2382,7 +2382,9 @@ print_deadlock_bug(struct task_struct *curr, struct held_lock *prev,
  * (Note that this has to be done separately, because the graph cannot
  * detect such classes of deadlocks.)
  *
- * Returns: 0 on deadlock detected, 1 on OK, 2 on recursive read
+ * Returns: 0 on deadlock detected, 1 on OK, 2 if another lock with the same
+ * lock class is held but nest_lock is also held, i.e. we rely on the
+ * nest_lock to avoid the deadlock.
  */
 static int
 check_deadlock(struct task_struct *curr, struct held_lock *next)
@@ -2405,7 +2407,7 @@ check_deadlock(struct task_struct *curr, struct held_lock *next)
 		 * lock class (i.e. read_lock(lock)+read_lock(lock)):
 		 */
 		if ((next->read == 2) && prev->read)
-			return 2;
+			continue;
 
 		/*
 		 * We're holding the nest_lock, which serializes this lock's
@@ -2961,16 +2963,13 @@ static int validate_chain(struct task_struct *curr,
 
 		if (!ret)
 			return 0;
-		/*
-		 * Mark recursive read, as we jump over it when
-		 * building dependencies (just like we jump over
-		 * trylock entries):
-		 */
-		if (ret == 2)
-			hlock->read = 2;
 		/*
 		 * Add dependency only if this lock is not the head
-		 * of the chain, and if it's not a secondary read-lock:
+		 * of the chain, and if the new lock introduces no more
+		 * lock dependency (because we already hold a lock with the
+		 * same lock class) nor deadlock (because the nest_lock
+		 * serializes nesting locks), see the comments for
+		 * check_deadlock().
 		 */
 		if (!chain_head && ret != 2) {
 			if (!check_prevs_add(curr, hlock))
-- 
2.27.0

