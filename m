Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7FD7F426
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391844AbfHBJmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391837AbfHBJmQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:42:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B35A20679;
        Fri,  2 Aug 2019 09:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738936;
        bh=sA3XU0PFtbIvFHk7jnlgM6z9ZIG4SOdUT7RNSBfJy0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctAJJAPpl3IP6+MFqgmu1aeQPXsRhiYyEu9PuKf8QdYxFQPljs3JT1nLkDSnlM9xk
         dW7pG5lV8J1Ogvn30GtgU/tisIJrtav9xsSoL8iOGE06NZj6ZhyDEmhlMqvR1L99kr
         q/lq0l6Ye8KvKMcyu9p7ZN+3dUk9BjnZyeujP5L4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 038/223] rcu: Force inlining of rcu_read_lock()
Date:   Fri,  2 Aug 2019 11:34:23 +0200
Message-Id: <20190802092241.447688037@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index aa2935779e43..96037ba940ee 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -866,7 +866,7 @@ static inline void rcu_preempt_sleep_check(void)
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



