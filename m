Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB6646378C
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhK3Oyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242709AbhK3Ox0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:53:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C9DC061799;
        Tue, 30 Nov 2021 06:48:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 563DCB817FA;
        Tue, 30 Nov 2021 14:48:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D02EC53FC1;
        Tue, 30 Nov 2021 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283724;
        bh=/SGEkdUTJHZ3EihUEQC5yco4rWCMnnpaOarn4sq55UQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IMetbE/ga+uNL2XimK6OVBU3wMy7gvKqAPM+bpbnjwsJr3ACm67Fhjh0dl/h/B483
         XFIU1OU8dMawwB3LH4rtY1ZnFJiJK50KlJTv7+Zs6rajqH9RqAGtS6pjRMthgYkSeg
         YKdeDLCpoA4Qh4o+hUIivGY1otaNxkpJ0l3+02ZYTSu7JGTKXVuE72hF2OyIWCsL0z
         RaDE+aSr7yOzLnRpp3roFZLFAWM2b34aPopVZa/5/XjOvDt9Z61HNHyLk3pqtSAX1T
         KavDS3278c75WJiJIAW4aq39MMP8ygdRbEieapdc4+cAbAInk3KG7+kAsiwe4+lqgU
         Rdpw/7r0YHV6Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 5.15 34/68] locking/rwsem: Optimize down_read_trylock() under highly contended case
Date:   Tue, 30 Nov 2021 09:46:30 -0500
Message-Id: <20211130144707.944580-34-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130144707.944580-1-sashal@kernel.org>
References: <20211130144707.944580-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit 14c24048841151548a3f4d9e218510c844c1b737 ]

We found that a process with 10 thousnads threads has been encountered
a regression problem from Linux-v4.14 to Linux-v5.4. It is a kind of
workload which will concurrently allocate lots of memory in different
threads sometimes. In this case, we will see the down_read_trylock()
with a high hotspot. Therefore, we suppose that rwsem has a regression
at least since Linux-v5.4. In order to easily debug this problem, we
write a simply benchmark to create the similar situation lile the
following.

  ```c++
  #include <sys/mman.h>
  #include <sys/time.h>
  #include <sys/resource.h>
  #include <sched.h>

  #include <cstdio>
  #include <cassert>
  #include <thread>
  #include <vector>
  #include <chrono>

  volatile int mutex;

  void trigger(int cpu, char* ptr, std::size_t sz)
  {
  	cpu_set_t set;
  	CPU_ZERO(&set);
  	CPU_SET(cpu, &set);
  	assert(pthread_setaffinity_np(pthread_self(), sizeof(set), &set) == 0);

  	while (mutex);

  	for (std::size_t i = 0; i < sz; i += 4096) {
  		*ptr = '\0';
  		ptr += 4096;
  	}
  }

  int main(int argc, char* argv[])
  {
  	std::size_t sz = 100;

  	if (argc > 1)
  		sz = atoi(argv[1]);

  	auto nproc = std::thread::hardware_concurrency();
  	std::vector<std::thread> thr;
  	sz <<= 30;
  	auto* ptr = mmap(nullptr, sz, PROT_READ | PROT_WRITE, MAP_ANON |
			 MAP_PRIVATE, -1, 0);
  	assert(ptr != MAP_FAILED);
  	char* cptr = static_cast<char*>(ptr);
  	auto run = sz / nproc;
  	run = (run >> 12) << 12;

  	mutex = 1;

  	for (auto i = 0U; i < nproc; ++i) {
  		thr.emplace_back(std::thread([i, cptr, run]() { trigger(i, cptr, run); }));
  		cptr += run;
  	}

  	rusage usage_start;
  	getrusage(RUSAGE_SELF, &usage_start);
  	auto start = std::chrono::system_clock::now();

  	mutex = 0;

  	for (auto& t : thr)
  		t.join();

  	rusage usage_end;
  	getrusage(RUSAGE_SELF, &usage_end);
  	auto end = std::chrono::system_clock::now();
  	timeval utime;
  	timeval stime;
  	timersub(&usage_end.ru_utime, &usage_start.ru_utime, &utime);
  	timersub(&usage_end.ru_stime, &usage_start.ru_stime, &stime);
  	printf("usr: %ld.%06ld\n", utime.tv_sec, utime.tv_usec);
  	printf("sys: %ld.%06ld\n", stime.tv_sec, stime.tv_usec);
  	printf("real: %lu\n",
  	       std::chrono::duration_cast<std::chrono::milliseconds>(end -
  	       start).count());

  	return 0;
  }
  ```

The functionality of above program is simply which creates `nproc`
threads and each of them are trying to touch memory (trigger page
fault) on different CPU. Then we will see the similar profile by
`perf top`.

  25.55%  [kernel]                  [k] down_read_trylock
  14.78%  [kernel]                  [k] handle_mm_fault
  13.45%  [kernel]                  [k] up_read
   8.61%  [kernel]                  [k] clear_page_erms
   3.89%  [kernel]                  [k] __do_page_fault

The highest hot instruction, which accounts for about 92%, in
down_read_trylock() is cmpxchg like the following.

  91.89 │      lock   cmpxchg %rdx,(%rdi)

Sice the problem is found by migrating from Linux-v4.14 to Linux-v5.4,
so we easily found that the commit ddb20d1d3aed ("locking/rwsem: Optimize
down_read_trylock()") caused the regression. The reason is that the
commit assumes the rwsem is not contended at all. But it is not always
true for mmap lock which could be contended with thousands threads.
So most threads almost need to run at least 2 times of "cmpxchg" to
acquire the lock. The overhead of atomic operation is higher than
non-atomic instructions, which caused the regression.

By using the above benchmark, the real executing time on a x86-64 system
before and after the patch were:

                  Before Patch  After Patch
   # of Threads      real          real     reduced by
   ------------     ------        ------    ----------
         1          65,373        65,206       ~0.0%
         4          15,467        15,378       ~0.5%
        40           6,214         5,528      ~11.0%

For the uncontended case, the new down_read_trylock() is the same as
before. For the contended cases, the new down_read_trylock() is faster
than before. The more contended, the more fast.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Waiman Long <longman@redhat.com>
Link: https://lore.kernel.org/r/20211118094455.9068-1-songmuchun@bytedance.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/rwsem.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 29eea50a3e678..e1b5cb8212675 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1246,17 +1246,14 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
 
-	/*
-	 * Optimize for the case when the rwsem is not locked at all.
-	 */
-	tmp = RWSEM_UNLOCKED_VALUE;
-	do {
+	tmp = atomic_long_read(&sem->count);
+	while (!(tmp & RWSEM_READ_FAILED_MASK)) {
 		if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
-					tmp + RWSEM_READER_BIAS)) {
+						    tmp + RWSEM_READER_BIAS)) {
 			rwsem_set_reader_owned(sem);
 			return 1;
 		}
-	} while (!(tmp & RWSEM_READ_FAILED_MASK));
+	}
 	return 0;
 }
 
-- 
2.33.0

