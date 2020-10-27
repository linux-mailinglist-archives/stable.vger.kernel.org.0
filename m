Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6EA829B6F4
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798445AbgJ0P2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:36778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797172AbgJ0PWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:22:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48AED2064B;
        Tue, 27 Oct 2020 15:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812120;
        bh=ueLpwSj42/IMBAfeAnVYV+9171aWEf9zxyjuHGwJu94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OF4sG9rjRqO3VmmmSpqeSaXq1+b0udaG/rxdSPQ7DorL+aaNcYNHGG78N0uBSFbiz
         4JkoIFWzNYIabToUVBXEqpjVdmU6PBtfWsndrgCGj0r0En4szq0AUFJLx6UYiRIi45
         /hBy1iVR7asWPfh/k6xK3aw8iWaMLn0OcB/cDDG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Subject: [PATCH 5.9 099/757] seqlock: Unbreak lockdep
Date:   Tue, 27 Oct 2020 14:45:49 +0100
Message-Id: <20201027135455.193405732@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: peterz@infradead.org <peterz@infradead.org>

[ Upstream commit 267580db047ef428a70bef8287ca62c5a450c139 ]

seqcount_LOCKNAME_init() needs to be a macro due to the lockdep
annotation in seqcount_init(). Since a macro cannot define another
macro, we need to effectively revert commit: e4e9ab3f9f91 ("seqlock:
Fold seqcount_LOCKNAME_init() definition").

Fixes: e4e9ab3f9f91 ("seqlock: Fold seqcount_LOCKNAME_init() definition")
Reported-by: Qian Cai <cai@redhat.com>
Debugged-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Qian Cai <cai@redhat.com>
Link: https://lkml.kernel.org/r/20200915143028.GB2674@hirez.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seqlock.h | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 962d9768945f0..7b99e3dba2065 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -154,6 +154,19 @@ static inline void seqcount_lockdep_reader_access(const seqcount_t *s)
  * @lock:	Pointer to the associated LOCKTYPE
  */
 
+#define seqcount_LOCKNAME_init(s, _lock, lockname)			\
+	do {								\
+		seqcount_##lockname##_t *____s = (s);			\
+		seqcount_init(&____s->seqcount);			\
+		__SEQ_LOCK(____s->lock = (_lock));			\
+	} while (0)
+
+#define seqcount_raw_spinlock_init(s, lock)	seqcount_LOCKNAME_init(s, lock, raw_spinlock)
+#define seqcount_spinlock_init(s, lock)		seqcount_LOCKNAME_init(s, lock, spinlock)
+#define seqcount_rwlock_init(s, lock)		seqcount_LOCKNAME_init(s, lock, rwlock);
+#define seqcount_mutex_init(s, lock)		seqcount_LOCKNAME_init(s, lock, mutex);
+#define seqcount_ww_mutex_init(s, lock)		seqcount_LOCKNAME_init(s, lock, ww_mutex);
+
 /*
  * SEQCOUNT_LOCKTYPE() - Instantiate seqcount_LOCKNAME_t and helpers
  * @locktype:		actual typename
@@ -167,13 +180,6 @@ typedef struct seqcount_##lockname {					\
 	__SEQ_LOCK(locktype	*lock);					\
 } seqcount_##lockname##_t;						\
 									\
-static __always_inline void						\
-seqcount_##lockname##_init(seqcount_##lockname##_t *s, locktype *lock)	\
-{									\
-	seqcount_init(&s->seqcount);					\
-	__SEQ_LOCK(s->lock = lock);					\
-}									\
-									\
 static __always_inline seqcount_t *					\
 __seqcount_##lockname##_ptr(seqcount_##lockname##_t *s)			\
 {									\
@@ -228,13 +234,12 @@ SEQCOUNT_LOCKTYPE(struct ww_mutex,	ww_mutex,	true,	&s->lock->base)
 	__SEQ_LOCK(.lock	= (assoc_lock))				\
 }
 
-#define SEQCNT_SPINLOCK_ZERO(name, lock)	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 #define SEQCNT_RAW_SPINLOCK_ZERO(name, lock)	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
+#define SEQCNT_SPINLOCK_ZERO(name, lock)	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 #define SEQCNT_RWLOCK_ZERO(name, lock)		SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 #define SEQCNT_MUTEX_ZERO(name, lock)		SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 #define SEQCNT_WW_MUTEX_ZERO(name, lock) 	SEQCOUNT_LOCKTYPE_ZERO(name, lock)
 
-
 #define __seqprop_case(s, lockname, prop)				\
 	seqcount_##lockname##_t: __seqcount_##lockname##_##prop((void *)(s))
 
-- 
2.25.1



