Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9517969424
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403982AbfGOOrZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392154AbfGOOrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:47:21 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17296217F4;
        Mon, 15 Jul 2019 14:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563202040;
        bh=56azNwCvYBtyInd81c/jF2pAQmMyoZ+3vK1UrtbwvAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nCgdP2MChA4oXMAUDLm3LE9on99npkCjIZtBK/RvGwcG1tYvw1sxWTewzergjCy32
         UAB0euyvVE9jQ6R/clppKYOKzPZbELewVDqQPDBl6iWx+MgtnslDxl87cem1GAnMtU
         Dj+9c61d5i3iBfiCHj/loqDCT0mqjxRAlz/66r9I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Waiman Long <longman@redhat.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 30/53] rcu: Force inlining of rcu_read_lock()
Date:   Mon, 15 Jul 2019 10:45:12 -0400
Message-Id: <20190715144535.11636-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715144535.11636-1-sashal@kernel.org>
References: <20190715144535.11636-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 6da9f775175e516fc7229ceaa9b54f8f56aa7924 ]

When debugging options are turned on, the rcu_read_lock() function
might not be inlined. This results in lockdep's print_lock() function
printing "rcu_read_lock+0x0/0x70" instead of rcu_read_lock()'s caller.
For example:

[   10.579995] =============================
[   10.584033] WARNING: suspicious RCU usage
[   10.588074] 4.18.0.memcg_v2+ #1 Not tainted
[   10.593162] -----------------------------
[   10.597203] include/linux/rcupdate.h:281 Illegal context switch in
RCU read-side critical section!
[   10.606220]
[   10.606220] other info that might help us debug this:
[   10.606220]
[   10.614280]
[   10.614280] rcu_scheduler_active = 2, debug_locks = 1
[   10.620853] 3 locks held by systemd/1:
[   10.624632]  #0: (____ptrval____) (&type->i_mutex_dir_key#5){.+.+}, at: lookup_slow+0x42/0x70
[   10.633232]  #1: (____ptrval____) (rcu_read_lock){....}, at: rcu_read_lock+0x0/0x70
[   10.640954]  #2: (____ptrval____) (rcu_read_lock){....}, at: rcu_read_lock+0x0/0x70

These "rcu_read_lock+0x0/0x70" strings are not providing any useful
information.  This commit therefore forces inlining of the rcu_read_lock()
function so that rcu_read_lock()'s caller is instead shown.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index addd03641e1a..0a93e9d1708e 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -852,7 +852,7 @@ static inline void rcu_preempt_sleep_check(void)
  * read-side critical sections may be preempted and they may also block, but
  * only when acquiring spinlocks that are subject to priority inheritance.
  */
-static inline void rcu_read_lock(void)
+static __always_inline void rcu_read_lock(void)
 {
 	__rcu_read_lock();
 	__acquire(RCU);
-- 
2.20.1

