Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7DC3A9F37
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 17:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234692AbhFPPg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 11:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234681AbhFPPg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 11:36:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9D7C6101B;
        Wed, 16 Jun 2021 15:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623857660;
        bh=9YzhF267Tu8pj6vFG09DeCGbr7/bTkJnYyNa60yUF6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1DJ3DwMvsFGIopsicAW+xBt4uM/lh9re04iKefKs3EcQvD7eUbkhKgir7RsmDy4Bt
         O8nbXrKDnx3j8ZIpLpzutOjgYSaYYpp/ivs2jVOe2RhAj8NfJLWnhcTV/eFmGWRSCq
         65PBqtNZ9L1KDDoYpmnWcg+F70nUuuuo63TdzNmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+34ba7ddbf3021981a228@syzkaller.appspotmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/28] gfs2: Fix use-after-free in gfs2_glock_shrink_scan
Date:   Wed, 16 Jun 2021 17:33:25 +0200
Message-Id: <20210616152834.607192012@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
References: <20210616152834.149064097@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



