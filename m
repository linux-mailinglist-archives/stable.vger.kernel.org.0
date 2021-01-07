Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78B42ED2A5
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbhAGOfb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:35:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:47262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729565AbhAGOdV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45D322311E;
        Thu,  7 Jan 2021 14:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029960;
        bh=07H55USeSn93ZqRjF/TaBFzUhTUO066N9IvQn5RjYao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTRVVoaiFbNhyWwYigNla7sBicVY9pO/uxaiqojZkhvLGBaFxgNkppaVHoPm20BPR
         NLH5U+svwdderIE/Zzas1Vvq4mtGFrnUU+kDicXArL0HtB0zcSt2qNGdzoeyK9vxem
         NlH2i1gOZX0Vt9CT2Cx8gCgdZODY6B9q9+7NVZFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/13] rwsem: Implement down_read_interruptible
Date:   Thu,  7 Jan 2021 15:33:30 +0100
Message-Id: <20210107143051.459159924@linuxfoundation.org>
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

[ Upstream commit 31784cff7ee073b34d6eddabb95e3be2880a425c ]

In preparation for converting exec_update_mutex to a rwsem so that
multiple readers can execute in parallel and not deadlock, add
down_read_interruptible.  This is needed for perf_event_open to be
converted (with no semantic changes) from working on a mutex to
wroking on a rwsem.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/87k0tybqfy.fsf@x220.int.ebiederm.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rwsem.h  |  1 +
 kernel/locking/rwsem.c | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index c91ac00d1ff8c..8a3606372abc8 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -125,6 +125,7 @@ static inline int rwsem_is_contended(struct rw_semaphore *sem)
  * lock for reading
  */
 extern void down_read(struct rw_semaphore *sem);
+extern int __must_check down_read_interruptible(struct rw_semaphore *sem);
 extern int __must_check down_read_killable(struct rw_semaphore *sem);
 
 /*
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 2ce13f9585779..a5eb87f2c5816 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1348,6 +1348,18 @@ inline void __down_read(struct rw_semaphore *sem)
 	}
 }
 
+static inline int __down_read_interruptible(struct rw_semaphore *sem)
+{
+	if (!rwsem_read_trylock(sem)) {
+		if (IS_ERR(rwsem_down_read_slowpath(sem, TASK_INTERRUPTIBLE)))
+			return -EINTR;
+		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
+	} else {
+		rwsem_set_reader_owned(sem);
+	}
+	return 0;
+}
+
 static inline int __down_read_killable(struct rw_semaphore *sem)
 {
 	if (!rwsem_read_trylock(sem)) {
@@ -1498,6 +1510,20 @@ void __sched down_read(struct rw_semaphore *sem)
 }
 EXPORT_SYMBOL(down_read);
 
+int __sched down_read_interruptible(struct rw_semaphore *sem)
+{
+	might_sleep();
+	rwsem_acquire_read(&sem->dep_map, 0, 0, _RET_IP_);
+
+	if (LOCK_CONTENDED_RETURN(sem, __down_read_trylock, __down_read_interruptible)) {
+		rwsem_release(&sem->dep_map, _RET_IP_);
+		return -EINTR;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(down_read_interruptible);
+
 int __sched down_read_killable(struct rw_semaphore *sem)
 {
 	might_sleep();
-- 
2.27.0



