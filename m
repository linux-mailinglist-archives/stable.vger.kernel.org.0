Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16A05CABD4
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbfJCQAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbfJCQAr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:00:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E00E721D81;
        Thu,  3 Oct 2019 16:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118446;
        bh=CknWvKtX5BmSgd+yGV+0i6mZncWjE5nHtScPrEPnwYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vesGmSXDxf1VoIZHbnm/cZD6SqA6G/4jKgd0JAOOFfRCBM403/lGE6jYvgqs8Y34k
         mcREor9TkOdyOoSD9b9r57/N9QG8MST6qacVs1eg4RQNIw3H0fYtDVt0FmTK3Tc1Ly
         lUzoOfTmytSk8yrhS9PHa0KTzRe6vo5vJluobv30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com,
        Waiman Long <longman@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 015/129] locking/lockdep: Add debug_locks check in __lock_downgrade()
Date:   Thu,  3 Oct 2019 17:52:18 +0200
Message-Id: <20191003154325.692683799@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154318.081116689@linuxfoundation.org>
References: <20191003154318.081116689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 513e1073d52e55b8024b4f238a48de7587c64ccf ]

Tetsuo Handa had reported he saw an incorrect "downgrading a read lock"
warning right after a previous lockdep warning. It is likely that the
previous warning turned off lock debugging causing the lockdep to have
inconsistency states leading to the lock downgrade warning.

Fix that by add a check for debug_locks at the beginning of
__lock_downgrade().

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Reported-by: syzbot+53383ae265fb161ef488@syzkaller.appspotmail.com
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Link: https://lkml.kernel.org/r/1547093005-26085-1-git-send-email-longman@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 4b27aaffdf352..d7f425698a4a1 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3446,6 +3446,9 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 	unsigned int depth;
 	int i;
 
+	if (unlikely(!debug_locks))
+		return 0;
+
 	depth = curr->lockdep_depth;
 	/*
 	 * This function is about (re)setting the class of a held lock,
-- 
2.20.1



