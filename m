Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594F83B6436
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 17:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235275AbhF1PGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 11:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:38868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236769AbhF1PCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 11:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30E3B61CD3;
        Mon, 28 Jun 2021 14:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891383;
        bh=F5O9Api5/iELcugHSMjGXBouRRs5jTzjdVT1RMVHu9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFjevwwfm3dXphmPVLTwslnS8e1K1jF++i9AJS0BSsNGkSNgl3Q0As+epJxyOLDLy
         WjYxdFsHVtIiOqcjyMl28hEqKS2t7Bo4rY3ipeoGgzIhTssqR1tKGxULlY0o/0YJ0A
         /quiEbeexu6QsL0CvNDx71ysB+Sth80DtC/SVJcwC+fLDXnsiyqLOjjP50fRHLD7er
         RfSQRTPjG8CrhCYLwtT4NChBG2y5KbCQQc5oVSFXQe0S1hfQIk/5JgKa6PgI/qSp25
         M8Oig6IBatKLQsEs89+nrFPi1acVUUfCoM3uYxj89LcsEuleNvLCuLIwd6Ck1fOxzT
         cJkg3xWeKrxRw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hillf Danton <hdanton@sina.com>,
        syzbot <syzbot+34ba7ddbf3021981a228@syzkaller.appspotmail.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 06/57] gfs2: Fix use-after-free in gfs2_glock_shrink_scan
Date:   Mon, 28 Jun 2021 10:42:05 -0400
Message-Id: <20210628144256.34524-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628144256.34524-1-sashal@kernel.org>
References: <20210628144256.34524-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.274-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.274-rc1
X-KernelTest-Deadline: 2021-06-30T14:42+00:00
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
index 8e8695eb652a..f115ce93dfb4 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1342,6 +1342,7 @@ __acquires(&lru_lock)
 	while(!list_empty(list)) {
 		gl = list_entry(list->next, struct gfs2_glock, gl_lru);
 		list_del_init(&gl->gl_lru);
+		clear_bit(GLF_LRU, &gl->gl_flags);
 		if (!spin_trylock(&gl->gl_lockref.lock)) {
 add_back_to_lru:
 			list_add(&gl->gl_lru, &lru_list);
@@ -1388,7 +1389,6 @@ static long gfs2_scan_glock_lru(int nr)
 		if (!test_bit(GLF_LOCK, &gl->gl_flags)) {
 			list_move(&gl->gl_lru, &dispose);
 			atomic_dec(&lru_count);
-			clear_bit(GLF_LRU, &gl->gl_flags);
 			freed++;
 			continue;
 		}
-- 
2.30.2

