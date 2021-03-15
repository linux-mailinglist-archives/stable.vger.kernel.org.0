Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8F433BA7E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhCOOJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231781AbhCOODw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8D9B64F02;
        Mon, 15 Mar 2021 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817031;
        bh=1cpXjPpo4Z5OBCeVk7aKUYLS5wTG3/dSdIXOKFik8Zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FFPYjRbb/dxdWXKE9eCDERImmA9FBdFQAyVcylZIZiBIJsrxlod+qyC+LkHFG34WT
         jijabTZb4gBsgLvTL/FKj74ElT1C9E/sWn7GRziKpVmxQoSck1UvX2YGlrLBLxITqx
         tNIVcyz70cbyHxrheohYLrY2QDrX/a3qVfjAAWNw=
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
Subject: [PATCH 5.11 267/306] include/linux/sched/mm.h: use rcu_dereference in in_vfork()
Date:   Mon, 15 Mar 2021 14:55:30 +0100
Message-Id: <20210315135516.668510601@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
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
index 1ae08b8462a4..90b2a0bce11c 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -140,7 +140,8 @@ static inline bool in_vfork(struct task_struct *tsk)
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



