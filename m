Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F152ED273
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbhAGOdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729532AbhAGOdS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 168E12336D;
        Thu,  7 Jan 2021 14:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029958;
        bh=Kga/4gP3btIfsllJyQ5qKksgwH9GjlUV7ZHTymD/SgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhHO972qlXaazF1kmOZjEgcO5AKxPyrx/MlVDdTeZcRdUCQeoSux0zawXNQ7ybS3A
         Y2v2DiT1tJ3tswEbI5KP39SXZTNOSYeCzeTC2UWxtLynyMgsM3e+DrkG03ln/eWA26
         xrvWs086gToFIzg4tyC1wvHxk/uhZENDAI4ogkRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/13] rwsem: Implement down_read_killable_nested
Date:   Thu,  7 Jan 2021 15:33:29 +0100
Message-Id: <20210107143051.339142973@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107143049.929352526@linuxfoundation.org>
References: <20210107143049.929352526@linuxfoundation.org>
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
index 00d6054687dd2..c91ac00d1ff8c 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -173,6 +173,7 @@ extern void downgrade_write(struct rw_semaphore *sem);
  * See Documentation/locking/lockdep-design.rst for more details.)
  */
 extern void down_read_nested(struct rw_semaphore *sem, int subclass);
+extern int __must_check down_read_killable_nested(struct rw_semaphore *sem, int subclass);
 extern void down_write_nested(struct rw_semaphore *sem, int subclass);
 extern int down_write_killable_nested(struct rw_semaphore *sem, int subclass);
 extern void _down_write_nest_lock(struct rw_semaphore *sem, struct lockdep_map *nest_lock);
@@ -193,6 +194,7 @@ extern void down_read_non_owner(struct rw_semaphore *sem);
 extern void up_read_non_owner(struct rw_semaphore *sem);
 #else
 # define down_read_nested(sem, subclass)		down_read(sem)
+# define down_read_killable_nested(sem, subclass)	down_read_killable(sem)
 # define down_write_nest_lock(sem, nest_lock)	down_write(sem)
 # define down_write_nested(sem, subclass)	down_write(sem)
 # define down_write_killable_nested(sem, subclass)	down_write_killable(sem)
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index baafa1dd9fcc4..2ce13f9585779 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1608,6 +1608,20 @@ void down_read_nested(struct rw_semaphore *sem, int subclass)
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



