Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9888C33B8B0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbhCOOEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233090AbhCOOAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7555D64F43;
        Mon, 15 Mar 2021 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816825;
        bh=SNJ/Qe2PThJM9J2GZUSP9UlgMibHiTmbZ7AGR5szfgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdFlrNuwI0+KF0Cg4LXnPV6YVSL9a/uNISAIcXTxt9OnhAb+IiEjf8tD/8sQcsO+C
         vw7eTOR02kz6FbafO+IB1j3HAoby8rYakYIfM4huPj1Tsc6+mCjr1BI0Wfy9hJMaxY
         /ZeXRDhQjwbvPy0CWrtLDr9UmBdEs8dzp1qP2dCY=
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
Subject: [PATCH 4.14 86/95] include/linux/sched/mm.h: use rcu_dereference in in_vfork()
Date:   Mon, 15 Mar 2021 14:57:56 +0100
Message-Id: <20210315135743.114340903@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135740.245494252@linuxfoundation.org>
References: <20210315135740.245494252@linuxfoundation.org>
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
index efb9e12e7f91..c16f927570b0 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -171,7 +171,8 @@ static inline bool in_vfork(struct task_struct *tsk)
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



