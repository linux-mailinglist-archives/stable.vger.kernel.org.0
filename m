Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4C42ED27C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729605AbhAGOdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729600AbhAGOdc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C188B22EBF;
        Thu,  7 Jan 2021 14:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029997;
        bh=wtAM82iXgMoyxDh/Ji0NKnDig34WfzmB6eoRobblbSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aT1c2j+I+1tjh/RQ3Tc9gLzmMG4cMi1zNjhLcoRlgN2nQcCDhOCaZul0R4I+SKmoP
         wfuDQcnqg4f8KMUpTOps9ViUesx7ulEiOd6jOhY4zrkojckbD62+/zawCzm+G6txna
         7Air+P/3/g0qUEEAhwf6/zEVVN5YFrkYq50B06QQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/20] rwsem: Implement down_read_killable_nested
Date:   Thu,  7 Jan 2021 15:34:12 +0100
Message-Id: <20210107143054.781425623@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
References: <20210107143052.392839477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 0f9368b5bf6db0c04afc5454b1be79022a681615 ]

In preparation for converting exec_update_mutex to a rwsem so that
multiple readers can execute in parallel and not deadlock, add
down_read_killable_nested.  This is needed so that kcmp_lock
can be converted from working on a mutexes to working on rw_semaphores.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/87o8jabqh3.fsf@x220.int.ebiederm.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rwsem.h  |  2 ++
 kernel/locking/rwsem.c | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 25e3fde856178..13021b08b2ed6 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -171,6 +171,7 @@ extern void downgrade_write(struct rw_semaphore *sem);
  * See Documentation/locking/lockdep-design.rst for more details.)
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
+extern int __must_check down_read_killable_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
 extern int down_write_killable_nested(struct rw_semaphore *sem, int subclass);
 extern void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest_lock);
@@ -191,6 +192,7 @@ extern void down_read_non_owner(struct rw_semaphore *sem);
 extern void up_read_non_owner(struct rw_semaphore *sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
+# define down_read_killable_nested(sem, subclass)	down_read_killable(sem)
 # define down_write_nest_lock(sem, nest_lock)	down_write(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
 # define down_write_killable_nested(sem, subclass)	down_write_killable(sem)
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index f11b9bd3431d2..54d11cb975510 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1605,6 +1605,20 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
 }
 EXPORT_SYMBOL(down_read_nested);
 
+int down_read_killable_nested(struct rw_semaphore *sem, int subclass)
+{
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, subclass, 0, _RET_IP_);
+
+	if (LOCK_CONTENDED_RETURN(sem, __down_read_trylock, __down_read_killable)) {
+		rwsem_release(&sem->dep_map, _RET_IP_);
+		return -EINTR;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(down_read_killable_nested);
+
 void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest)
 {
 	might_sleep();
-- 
2.27.0



