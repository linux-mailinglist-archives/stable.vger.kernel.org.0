Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 807AC7F491
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404662AbfHBJbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:31:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404656AbfHBJbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:31:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A4C221783;
        Fri,  2 Aug 2019 09:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738272;
        bh=IvQTKsAHQBW1ffWs3lHtklXfvczBLirdNW2sGj4IkGs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLkCY6lQj38l38/eA6zkmVF2mM20W6d9uFyfHp7X7fLIvi9ZHPKnN3M1py8rtwWR3
         J3if43bouP8+rVQqc0jR4Ri/Q93wLyo5DQX/mTM2A1EqAmMRDMh9tx2Iv3bqlEByTW
         nAWyNErDT1cjBscPsdOOotAPXyZqDYWfVLhav9Uw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 031/158] rcu: Force inlining of rcu_read_lock()
Date:   Fri,  2 Aug 2019 11:27:32 +0200
Message-Id: <20190802092210.058371912@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
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



