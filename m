Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8835533B948
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhCOOFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233272AbhCOOBV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB3AE64F6E;
        Mon, 15 Mar 2021 14:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816856;
        bh=l3sIDKaoBXfVT2r26H/MhkciIgEcgQWWz+VuS4H84v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ysBAxdd7rnfj2B4Yt02RNNTOLdNCvhAnxE7Wj83pVqZ5Gt0O4EAuZ7N5e/tMj+QUr
         atEzx3N5pDvLXdG4cWchU5zMHjkS3/NWRR8zFvq8uXMhzlS6ylw83Ee3AfcOXW17DM
         rLXhJ6zFu4XR3eluTyEpr3DzdRspd6xP0M6xK6Fc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/168] include/linux/sched/mm.h: use rcu_dereference in in_vfork()
Date:   Mon, 15 Mar 2021 14:56:26 +0100
Message-Id: <20210315135555.410453379@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 149fc787353f65b7e72e05e7b75d34863266c3e2 ]

Fix a sparse warning by using rcu_dereference().  Technically this is a
bug and a sufficiently aggressive compiler could reload the `real_parent'
pointer outside the protection of the rcu lock (and access freed memory),
but I think it's pretty unlikely to happen.

Link: https://lkml.kernel.org/r/20210221194207.1351703-1-willy@infradead.org
Fixes: b18dc5f291c0 ("mm, oom: skip vforked tasks from being selected")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/mm.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index a132d875d351..3a1d899019af 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -167,7 +167,8 @@ static inline bool in_vfork(struct task_struct *tsk)
 	 * another oom-unkillable task does this it should blame itself.
 	 */
 	rcu_read_lock();
-	ret = tsk->vfork_done && tsk->real_parent->mm == tsk->mm;
+	ret = tsk->vfork_done &&
+			rcu_dereference(tsk->real_parent)->mm == tsk->mm;
 	rcu_read_unlock();
 
 	return ret;
-- 
2.30.1



