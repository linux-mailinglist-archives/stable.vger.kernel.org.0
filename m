Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B2C2ED2A2
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbhAGOfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:35:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729615AbhAGOdf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:33:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08A7923355;
        Thu,  7 Jan 2021 14:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610029999;
        bh=7P0SUN5X1XQqZGAdymWInV2yK3b1Gsb/yoymRxiqWw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Azw0TxFxPIMiubFeSz/NrZ0TEKawBRMxR8i0wEELf3w+ZcFaPJ5Ll8Rcn3Cl1r3+k
         CuHtrLRIJB93ZkhXRXnhJIBgN1wE8IJzIuRW/PRJ0Cs+vf6NiycbjxhLnj+riNHmtg
         Jv70RDzv1QQPTbbAzQ+h1PpBOtJT7CFD5SXg6D60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/20] rwsem: Implement down_read_interruptible
Date:   Thu,  7 Jan 2021 15:34:13 +0100
Message-Id: <20210107143054.949487277@linuxfoundation.org>
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
index 13021b08b2ed6..4c715be487171 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -123,6 +123,7 @@ static inline int rwsem_is_contended(struct rw_semaphore *sem)
  * lock for reading
  */
 extern void down_read(struct rw_semaphore *sem);
+extern int __must_check down_read_interruptible(struct rw_semaphore *sem);
 extern int __must_check down_read_killable(struct rw_semaphore *sem);
 
 /*
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 54d11cb975510..a163542d178ee 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1345,6 +1345,18 @@ static inline void __down_read(struct rw_semaphore *sem)
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
@@ -1495,6 +1507,20 @@ void __sched down_read(struct rw_semaphore *sem)
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



