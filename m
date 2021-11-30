Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E275463817
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238167AbhK3O6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:58:06 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:59398 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242919AbhK3Ozm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 09:55:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6FFA2CE1A77;
        Tue, 30 Nov 2021 14:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C213CC8D181;
        Tue, 30 Nov 2021 14:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638283939;
        bh=aqAdvlUTOR29RIp2RE3KkJqOtWERDu+QZeYICdVxYTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuStobeXgQnApNl33ETJr+KOG1XoNCQNAbJcl4heUUJ/NKOCSVTUSXQ9XqfSkYD+Q
         XkznDr4blyBg8hwDsocOwzmnug41U+6plc1vRVBoRQXe7qH4OZl9w7FgdAZo+pH0qd
         eFo1oGEQHJ8G6J5eRN/wDN/ZM9A5hKG0GL7nlE55RrJDzIaGsBZ+9J1HnG4rLI5/Ee
         hhUB3g0DqUEENfkYVXkSzj6nZI84bC3SxbbK9mRRJKjTd0s7UsPDbp4vPtSwu5CsuG
         V8HCjFXPYnrKBKHiKbKRZS4ZMoxFIOLsa5CnQqJKXplwHiKAsMi78lc2xo+n1YMJrL
         pCtZJaLCJ7DSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Muchun Song <songmuchun@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Waiman Long <longman@redhat.com>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        will@kernel.org
Subject: [PATCH AUTOSEL 5.4 11/25] locking/rwsem: Optimize down_read_trylock() under highly contended case
Date:   Tue, 30 Nov 2021 09:51:41 -0500
Message-Id: <20211130145156.946083-11-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130145156.946083-1-sashal@kernel.org>
References: <20211130145156.946083-1-sashal@kernel.org>
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
index 5d54ff3179b80..db7b294b51dfe 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -1378,17 +1378,14 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
 
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

