Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A7539E303
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhFGQUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:20:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:47564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhFGQSj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:18:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CB26140D;
        Mon,  7 Jun 2021 16:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082468;
        bh=9YzhF267Tu8pj6vFG09DeCGbr7/bTkJnYyNa60yUF6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkutUV02GdCNHVawysZ4rU3rb/euQJTivfRS+qBbcXDLwrwoSds/8basBGcR28qDn
         m8KU0bcnIjkbIaASlA9Lk5t/xR6D5T5WVRJEes4wkfeOiKaVDHZiueDbYNqyFFz2oG
         5bRrAsQVkuOJE4i0CtOWDN5jfebG3m3A0HJtb9nQ/Lc4wU9MhEr03QrjPajn93W84B
         oF3sFrW+Z+PSdMranNWAtKiP+7Kz8JFDA7wWrn1CcNHM5rqonlY/0WVcOITifjrbLp
         MhDLavPOwvs1cXZ3okOO0CuKqxedMGUODZC/jq+q1nRWfgJCzOEbv8FXHsmbTBYAaq
         /gYB3qJMtMWtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+34ba7ddbf3021981a228@syzkaller.appspotmail.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>, cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 14/29] gfs2: Fix use-after-free in gfs2_glock_shrink_scan
Date:   Mon,  7 Jun 2021 12:13:55 -0400
Message-Id: <20210607161410.3584036-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hillf Danton <hdanton@sina.com>

[ Upstream commit 1ab19c5de4c537ec0d9b21020395a5b5a6c059b2 ]

The GLF_LRU flag is checked under lru_lock in gfs2_glock_remove_from_lru() to
remove the glock from the lru list in __gfs2_glock_put().

On the shrink scan path, the same flag is cleared under lru_lock but because
of cond_resched_lock(&lru_lock) in gfs2_dispose_glock_lru(), progress on the
put side can be made without deleting the glock from the lru list.

Keep GLF_LRU across the race window opened by cond_resched_lock(&lru_lock) to
ensure correct behavior on both sides - clear GLF_LRU after list_del under
lru_lock.

Reported-by: syzbot <syzbot+34ba7ddbf3021981a228@syzkaller.appspotmail.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 9e1685a30bf8..01c41087f067 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1552,6 +1552,7 @@ __acquires(&lru_lock)
 	while(!list_empty(list)) {
 		gl = list_entry(list->next, struct gfs2_glock, gl_lru);
 		list_del_init(&gl->gl_lru);
+		clear_bit(GLF_LRU, &gl->gl_flags);
 		if (!spin_trylock(&gl->gl_lockref.lock)) {
 add_back_to_lru:
 			list_add(&gl->gl_lru, &lru_list);
@@ -1597,7 +1598,6 @@ static long gfs2_scan_glock_lru(int nr)
 		if (!test_bit(GLF_LOCK, &gl->gl_flags)) {
 			list_move(&gl->gl_lru, &dispose);
 			atomic_dec(&lru_count);
-			clear_bit(GLF_LRU, &gl->gl_flags);
 			freed++;
 			continue;
 		}
-- 
2.30.2

