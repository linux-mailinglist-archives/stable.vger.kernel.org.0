Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1675179891
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbfG2Thz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388795AbfG2Thz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:37:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 804DC206DD;
        Mon, 29 Jul 2019 19:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429074;
        bh=bmHI5YoGnZ4tyEW1swpCkzC8+CTt/8nwmGZt77rb7Ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbPLPAGIfIWqb9ZgqGiwqvo9yrCoUijxoabO7n68WLZCQLVCNxN6065CVsK95rSZv
         mhTrE3P/HgpFNA0m2hOn0g6egp4+e0EJ9N1UEkiPJaUPCmpCi+l5fek3BgBREXRxtQ
         wjZrG7cOkSCDyVcUo4FpdzZwJ2qb2yERPLhRsLJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Qian Cai <cai@lca.pw>, Thomas Gleixner <tglx@linutronix.de>,
        Waiman Long <longman@redhat.com>,
        Will Deacon <will.deacon@arm.com>,
        Will Deacon <will@kernel.org>, Yuyang Du <duyuyang@gmail.com>,
        frederic@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 277/293] locking/lockdep: Hide unused class variable
Date:   Mon, 29 Jul 2019 21:22:48 +0200
Message-Id: <20190729190845.513080090@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 68037aa78208f34bda4e5cd76c357f718b838cbb ]

The usage is now hidden in an #ifdef, so we need to move
the variable itself in there as well to avoid this warning:

  kernel/locking/lockdep_proc.c:203:21: error: unused variable 'class' [-Werror,-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yuyang Du <duyuyang@gmail.com>
Cc: frederic@kernel.org
Fixes: 68d41d8c94a3 ("locking/lockdep: Fix lock used or unused stats error")
Link: https://lkml.kernel.org/r/20190715092809.736834-1-arnd@arndb.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep_proc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index 71631bef0e84..8b2ef15e3552 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -224,7 +224,6 @@ static void lockdep_stats_debug_show(struct seq_file *m)
 
 static int lockdep_stats_show(struct seq_file *m, void *v)
 {
-	struct lock_class *class;
 	unsigned long nr_unused = 0, nr_uncategorized = 0,
 		      nr_irq_safe = 0, nr_irq_unsafe = 0,
 		      nr_softirq_safe = 0, nr_softirq_unsafe = 0,
@@ -235,6 +234,8 @@ static int lockdep_stats_show(struct seq_file *m, void *v)
 		      sum_forward_deps = 0;
 
 #ifdef CONFIG_PROVE_LOCKING
+	struct lock_class *class;
+
 	list_for_each_entry(class, &all_lock_classes, lock_entry) {
 
 		if (class->usage_mask == 0)
-- 
2.20.1



