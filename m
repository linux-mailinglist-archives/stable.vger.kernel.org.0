Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8F137993B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 23:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhEJViJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 17:38:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230165AbhEJViJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 17:38:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05AE060FE7;
        Mon, 10 May 2021 21:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682623;
        bh=kmHz3dnx+tZGwdCDQydqEpQ0ThMTu4BeAVnfxhla6iM=;
        h=Date:From:To:Cc:Subject:From;
        b=DzIS2oVdhBzDKGQGVCVIT0SdFcHFaB4n8WLtRxo15NGT11iTRHUJSF1ngGEpMsHH9
         GMW53XkLxbmW5ZhIJj59HdxPhtGnbceRki4S5Ax708mDhfFdZpMHf4prBF1Ww4QVzN
         cPrBDK7QtsaVZGE9tsc6uH+DzO/zp8wN1s5wsZXHdDveHfVVeoWrtx0j4xG2Ul7vfP
         JY3xKNPcv3By1EwVXNkyOz/kmDXGSMOLd/oCrKtgaS+H8uOBLh+RYKeoYBP6Hj3nwC
         FzZXS/pDZJbZi0X52Lpw4c3q40iURwDzZxErVUTSdiSilrwUxJbFfQEXN9C21XECVa
         u53QdTtKCOiVw==
Date:   Mon, 10 May 2021 14:36:58 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jian Cai <jiancai@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        clang-built-linux@googlegroups.com, stable@vger.kernel.org
Subject: Backport of 1139aeb1c521 for all supported stable branches
Message-ID: <YJmneuxxFWIrqyWN@archlinux-ax161>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="fLKwDDoTK2blPOcV"
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--fLKwDDoTK2blPOcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg and Sasha,

Please find attached backports of commit 1139aeb1c521 ("smp: Fix
smp_call_function_single_async prototype") upstream, which resolves a
serious looking clang warning seen across several different builds. It
has been build tested with gcc and clang for x86_64 defconfig and
allmodconfig.

Please let me know if there are any problems.

Cheers,
Nathan

--fLKwDDoTK2blPOcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1139aeb1c521-4.14.patch"

From 13d0c736b29a5364eec1a7ec21e31f291dec9939 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 5 May 2021 23:12:42 +0200
Subject: [PATCH 4.14] smp: Fix smp_call_function_single_async prototype

commit 1139aeb1c521eb4a050920ce6c64c36c4f2a3ab7 upstream.

As of commit 966a967116e6 ("smp: Avoid using two cache lines for struct
call_single_data"), the smp code prefers 32-byte aligned call_single_data
objects for performance reasons, but the block layer includes an instance
of this structure in the main 'struct request' that is more senstive
to size than to performance here, see 4ccafe032005 ("block: unalign
call_single_data in struct request").

The result is a violation of the calling conventions that clang correctly
points out:

block/blk-mq.c:630:39: warning: passing 8-byte aligned argument to 32-byte aligned parameter 2 of 'smp_call_function_single_async' may result in an unaligned pointer access [-Walign-mismatch]
                smp_call_function_single_async(cpu, &rq->csd);

It does seem that the usage of the call_single_data without cache line
alignment should still be allowed by the smp code, so just change the
function prototype so it accepts both, but leave the default alignment
unchanged for the other users. This seems better to me than adding
a local hack to shut up an otherwise correct warning in the caller.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lkml.kernel.org/r/20210505211300.3174456-1-arnd@kernel.org
[nc: Fix conflicts]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/linux/smp.h |  2 +-
 kernel/smp.c        | 10 +++++-----
 kernel/up.c         |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 9fb239e12b82..6bb7f07bc1dd 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -53,7 +53,7 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd);
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/smp.c b/kernel/smp.c
index c94dd85c8d41..f9d95d59b7ed 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -103,12 +103,12 @@ void __init call_function_init(void)
  * previous function call. For multi-cpu calls its even more interesting
  * as we'll have to ensure no other cpu is observing our csd.
  */
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	smp_cond_load_acquire(&csd->flags, !(VAL & CSD_FLAG_LOCK));
 }
 
-static __always_inline void csd_lock(call_single_data_t *csd)
+static __always_inline void csd_lock(struct __call_single_data *csd)
 {
 	csd_lock_wait(csd);
 	csd->flags |= CSD_FLAG_LOCK;
@@ -121,7 +121,7 @@ static __always_inline void csd_lock(call_single_data_t *csd)
 	smp_wmb();
 }
 
-static __always_inline void csd_unlock(call_single_data_t *csd)
+static __always_inline void csd_unlock(struct __call_single_data *csd)
 {
 	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
@@ -138,7 +138,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(call_single_data_t, csd_data);
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static int generic_exec_single(int cpu, call_single_data_t *csd,
+static int generic_exec_single(int cpu, struct __call_single_data *csd,
 			       smp_call_func_t func, void *info)
 {
 	if (cpu == smp_processor_id()) {
@@ -323,7 +323,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * NOTE: Be careful, there is unfortunately no current debugging facility to
  * validate the correctness of this serialization.
  */
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	int err = 0;
 
diff --git a/kernel/up.c b/kernel/up.c
index 42c46bf3e0a5..2080f75e0e65 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -23,7 +23,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	unsigned long flags;
 

base-commit: 7d7d1c0ab3eb7c8d8f63a126535018007823b207
-- 
2.31.1.527.g2d677e5b15


--fLKwDDoTK2blPOcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1139aeb1c521-4.19.patch"

From b996825ca37f3104a7ff70f8ec707cf3003f8cce Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 5 May 2021 23:12:42 +0200
Subject: [PATCH 4.19] smp: Fix smp_call_function_single_async prototype

commit 1139aeb1c521eb4a050920ce6c64c36c4f2a3ab7 upstream.

As of commit 966a967116e6 ("smp: Avoid using two cache lines for struct
call_single_data"), the smp code prefers 32-byte aligned call_single_data
objects for performance reasons, but the block layer includes an instance
of this structure in the main 'struct request' that is more senstive
to size than to performance here, see 4ccafe032005 ("block: unalign
call_single_data in struct request").

The result is a violation of the calling conventions that clang correctly
points out:

block/blk-mq.c:630:39: warning: passing 8-byte aligned argument to 32-byte aligned parameter 2 of 'smp_call_function_single_async' may result in an unaligned pointer access [-Walign-mismatch]
                smp_call_function_single_async(cpu, &rq->csd);

It does seem that the usage of the call_single_data without cache line
alignment should still be allowed by the smp code, so just change the
function prototype so it accepts both, but leave the default alignment
unchanged for the other users. This seems better to me than adding
a local hack to shut up an otherwise correct warning in the caller.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lkml.kernel.org/r/20210505211300.3174456-1-arnd@kernel.org
[nc: Fix conflicts]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/linux/smp.h |  2 +-
 kernel/smp.c        | 10 +++++-----
 kernel/up.c         |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 9fb239e12b82..6bb7f07bc1dd 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -53,7 +53,7 @@ void on_each_cpu_cond(bool (*cond_func)(int cpu, void *info),
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd);
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/smp.c b/kernel/smp.c
index 084c8b3a2681..00d208ef07c7 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -103,12 +103,12 @@ void __init call_function_init(void)
  * previous function call. For multi-cpu calls its even more interesting
  * as we'll have to ensure no other cpu is observing our csd.
  */
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	smp_cond_load_acquire(&csd->flags, !(VAL & CSD_FLAG_LOCK));
 }
 
-static __always_inline void csd_lock(call_single_data_t *csd)
+static __always_inline void csd_lock(struct __call_single_data *csd)
 {
 	csd_lock_wait(csd);
 	csd->flags |= CSD_FLAG_LOCK;
@@ -121,7 +121,7 @@ static __always_inline void csd_lock(call_single_data_t *csd)
 	smp_wmb();
 }
 
-static __always_inline void csd_unlock(call_single_data_t *csd)
+static __always_inline void csd_unlock(struct __call_single_data *csd)
 {
 	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
@@ -138,7 +138,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(call_single_data_t, csd_data);
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static int generic_exec_single(int cpu, call_single_data_t *csd,
+static int generic_exec_single(int cpu, struct __call_single_data *csd,
 			       smp_call_func_t func, void *info)
 {
 	if (cpu == smp_processor_id()) {
@@ -323,7 +323,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * NOTE: Be careful, there is unfortunately no current debugging facility to
  * validate the correctness of this serialization.
  */
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	int err = 0;
 
diff --git a/kernel/up.c b/kernel/up.c
index 42c46bf3e0a5..2080f75e0e65 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -23,7 +23,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	unsigned long flags;
 

base-commit: 3c8c23092588a23bf1856a64f58c37f477a413be
-- 
2.31.1.527.g2d677e5b15


--fLKwDDoTK2blPOcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1139aeb1c521-5.4.patch"

From 127fde6df531e95e79ffa77b13818bd809a97a82 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 5 May 2021 23:12:42 +0200
Subject: [PATCH 5.4] smp: Fix smp_call_function_single_async prototype

commit 1139aeb1c521eb4a050920ce6c64c36c4f2a3ab7 upstream.

As of commit 966a967116e6 ("smp: Avoid using two cache lines for struct
call_single_data"), the smp code prefers 32-byte aligned call_single_data
objects for performance reasons, but the block layer includes an instance
of this structure in the main 'struct request' that is more senstive
to size than to performance here, see 4ccafe032005 ("block: unalign
call_single_data in struct request").

The result is a violation of the calling conventions that clang correctly
points out:

block/blk-mq.c:630:39: warning: passing 8-byte aligned argument to 32-byte aligned parameter 2 of 'smp_call_function_single_async' may result in an unaligned pointer access [-Walign-mismatch]
                smp_call_function_single_async(cpu, &rq->csd);

It does seem that the usage of the call_single_data without cache line
alignment should still be allowed by the smp code, so just change the
function prototype so it accepts both, but leave the default alignment
unchanged for the other users. This seems better to me than adding
a local hack to shut up an otherwise correct warning in the caller.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lkml.kernel.org/r/20210505211300.3174456-1-arnd@kernel.org
[nc: Fix conflicts]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/linux/smp.h |  2 +-
 kernel/smp.c        | 10 +++++-----
 kernel/up.c         |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 6fc856c9eda5..36a9da719110 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -57,7 +57,7 @@ void on_each_cpu_cond_mask(bool (*cond_func)(int cpu, void *info),
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags, const struct cpumask *mask);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd);
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/smp.c b/kernel/smp.c
index 7dbcb402c2fc..3a390932f8b2 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -104,12 +104,12 @@ void __init call_function_init(void)
  * previous function call. For multi-cpu calls its even more interesting
  * as we'll have to ensure no other cpu is observing our csd.
  */
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	smp_cond_load_acquire(&csd->flags, !(VAL & CSD_FLAG_LOCK));
 }
 
-static __always_inline void csd_lock(call_single_data_t *csd)
+static __always_inline void csd_lock(struct __call_single_data *csd)
 {
 	csd_lock_wait(csd);
 	csd->flags |= CSD_FLAG_LOCK;
@@ -122,7 +122,7 @@ static __always_inline void csd_lock(call_single_data_t *csd)
 	smp_wmb();
 }
 
-static __always_inline void csd_unlock(call_single_data_t *csd)
+static __always_inline void csd_unlock(struct __call_single_data *csd)
 {
 	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
@@ -139,7 +139,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(call_single_data_t, csd_data);
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static int generic_exec_single(int cpu, call_single_data_t *csd,
+static int generic_exec_single(int cpu, struct __call_single_data *csd,
 			       smp_call_func_t func, void *info)
 {
 	if (cpu == smp_processor_id()) {
@@ -332,7 +332,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * NOTE: Be careful, there is unfortunately no current debugging facility to
  * validate the correctness of this serialization.
  */
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	int err = 0;
 
diff --git a/kernel/up.c b/kernel/up.c
index 862b460ab97a..8e8551c8b285 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -24,7 +24,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	unsigned long flags;
 

base-commit: b5dbcd05792a4bad2c9bb3c4658c854e72c444b7
-- 
2.31.1.527.g2d677e5b15


--fLKwDDoTK2blPOcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1139aeb1c521-5.10.patch"

From 22ffbe67cfd260ab78bec93ad02901932c286d5c Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 5 May 2021 23:12:42 +0200
Subject: [PATCH 5.10] smp: Fix smp_call_function_single_async prototype

commit 1139aeb1c521eb4a050920ce6c64c36c4f2a3ab7 upstream.

As of commit 966a967116e6 ("smp: Avoid using two cache lines for struct
call_single_data"), the smp code prefers 32-byte aligned call_single_data
objects for performance reasons, but the block layer includes an instance
of this structure in the main 'struct request' that is more senstive
to size than to performance here, see 4ccafe032005 ("block: unalign
call_single_data in struct request").

The result is a violation of the calling conventions that clang correctly
points out:

block/blk-mq.c:630:39: warning: passing 8-byte aligned argument to 32-byte aligned parameter 2 of 'smp_call_function_single_async' may result in an unaligned pointer access [-Walign-mismatch]
                smp_call_function_single_async(cpu, &rq->csd);

It does seem that the usage of the call_single_data without cache line
alignment should still be allowed by the smp code, so just change the
function prototype so it accepts both, but leave the default alignment
unchanged for the other users. This seems better to me than adding
a local hack to shut up an otherwise correct warning in the caller.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lkml.kernel.org/r/20210505211300.3174456-1-arnd@kernel.org
[nc: Fix conflicts, modify rq_csd_init]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/linux/smp.h |  2 +-
 kernel/sched/core.c |  2 +-
 kernel/smp.c        | 20 ++++++++++----------
 kernel/up.c         |  2 +-
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 9f13966d3d92..04f44e0aa2e0 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -74,7 +74,7 @@ void on_each_cpu_cond(smp_cond_func_t cond_func, smp_call_func_t func,
 void on_each_cpu_cond_mask(smp_cond_func_t cond_func, smp_call_func_t func,
 			   void *info, bool wait, const struct cpumask *mask);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd);
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3a150445e0cb..3c3554d9ee50 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -321,7 +321,7 @@ void update_rq_clock(struct rq *rq)
 }
 
 static inline void
-rq_csd_init(struct rq *rq, call_single_data_t *csd, smp_call_func_t func)
+rq_csd_init(struct rq *rq, struct __call_single_data *csd, smp_call_func_t func)
 {
 	csd->flags = 0;
 	csd->func = func;
diff --git a/kernel/smp.c b/kernel/smp.c
index 25240fb2df94..f73a597c8e4c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -110,7 +110,7 @@ static DEFINE_PER_CPU(void *, cur_csd_info);
 static atomic_t csd_bug_count = ATOMIC_INIT(0);
 
 /* Record current CSD work for current CPU, NULL to erase. */
-static void csd_lock_record(call_single_data_t *csd)
+static void csd_lock_record(struct __call_single_data *csd)
 {
 	if (!csd) {
 		smp_mb(); /* NULL cur_csd after unlock. */
@@ -125,7 +125,7 @@ static void csd_lock_record(call_single_data_t *csd)
 		  /* Or before unlock, as the case may be. */
 }
 
-static __always_inline int csd_lock_wait_getcpu(call_single_data_t *csd)
+static __always_inline int csd_lock_wait_getcpu(struct __call_single_data *csd)
 {
 	unsigned int csd_type;
 
@@ -140,7 +140,7 @@ static __always_inline int csd_lock_wait_getcpu(call_single_data_t *csd)
  * the CSD_TYPE_SYNC/ASYNC types provide the destination CPU,
  * so waiting on other types gets much less information.
  */
-static __always_inline bool csd_lock_wait_toolong(call_single_data_t *csd, u64 ts0, u64 *ts1, int *bug_id)
+static __always_inline bool csd_lock_wait_toolong(struct __call_single_data *csd, u64 ts0, u64 *ts1, int *bug_id)
 {
 	int cpu = -1;
 	int cpux;
@@ -204,7 +204,7 @@ static __always_inline bool csd_lock_wait_toolong(call_single_data_t *csd, u64 t
  * previous function call. For multi-cpu calls its even more interesting
  * as we'll have to ensure no other cpu is observing our csd.
  */
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	int bug_id = 0;
 	u64 ts0, ts1;
@@ -219,17 +219,17 @@ static __always_inline void csd_lock_wait(call_single_data_t *csd)
 }
 
 #else
-static void csd_lock_record(call_single_data_t *csd)
+static void csd_lock_record(struct __call_single_data *csd)
 {
 }
 
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	smp_cond_load_acquire(&csd->flags, !(VAL & CSD_FLAG_LOCK));
 }
 #endif
 
-static __always_inline void csd_lock(call_single_data_t *csd)
+static __always_inline void csd_lock(struct __call_single_data *csd)
 {
 	csd_lock_wait(csd);
 	csd->flags |= CSD_FLAG_LOCK;
@@ -242,7 +242,7 @@ static __always_inline void csd_lock(call_single_data_t *csd)
 	smp_wmb();
 }
 
-static __always_inline void csd_unlock(call_single_data_t *csd)
+static __always_inline void csd_unlock(struct __call_single_data *csd)
 {
 	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
@@ -276,7 +276,7 @@ void __smp_call_single_queue(int cpu, struct llist_node *node)
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static int generic_exec_single(int cpu, call_single_data_t *csd)
+static int generic_exec_single(int cpu, struct __call_single_data *csd)
 {
 	if (cpu == smp_processor_id()) {
 		smp_call_func_t func = csd->func;
@@ -542,7 +542,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * NOTE: Be careful, there is unfortunately no current debugging facility to
  * validate the correctness of this serialization.
  */
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	int err = 0;
 
diff --git a/kernel/up.c b/kernel/up.c
index c6f323dcd45b..4edd5493eba2 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -25,7 +25,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	unsigned long flags;
 

base-commit: f53a3a4808625f876aebc5a0bfb354480bbf0c21
-- 
2.31.1.527.g2d677e5b15


--fLKwDDoTK2blPOcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1139aeb1c521-5.11.patch"

From b49fcd6c8198e8c6c18712a7cac4ad1400593159 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 5 May 2021 23:12:42 +0200
Subject: [PATCH 5.11] smp: Fix smp_call_function_single_async prototype

commit 1139aeb1c521eb4a050920ce6c64c36c4f2a3ab7 upstream.

As of commit 966a967116e6 ("smp: Avoid using two cache lines for struct
call_single_data"), the smp code prefers 32-byte aligned call_single_data
objects for performance reasons, but the block layer includes an instance
of this structure in the main 'struct request' that is more senstive
to size than to performance here, see 4ccafe032005 ("block: unalign
call_single_data in struct request").

The result is a violation of the calling conventions that clang correctly
points out:

block/blk-mq.c:630:39: warning: passing 8-byte aligned argument to 32-byte aligned parameter 2 of 'smp_call_function_single_async' may result in an unaligned pointer access [-Walign-mismatch]
                smp_call_function_single_async(cpu, &rq->csd);

It does seem that the usage of the call_single_data without cache line
alignment should still be allowed by the smp code, so just change the
function prototype so it accepts both, but leave the default alignment
unchanged for the other users. This seems better to me than adding
a local hack to shut up an otherwise correct warning in the caller.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lkml.kernel.org/r/20210505211300.3174456-1-arnd@kernel.org
[nc: Fix conflicts]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/linux/smp.h |  2 +-
 kernel/smp.c        | 20 ++++++++++----------
 kernel/up.c         |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 70c6f6284dcf..238a3f97a415 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -73,7 +73,7 @@ void on_each_cpu_cond(smp_cond_func_t cond_func, smp_call_func_t func,
 void on_each_cpu_cond_mask(smp_cond_func_t cond_func, smp_call_func_t func,
 			   void *info, bool wait, const struct cpumask *mask);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd);
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/smp.c b/kernel/smp.c
index aeb0adfa0606..c678589fbb76 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -110,7 +110,7 @@ static DEFINE_PER_CPU(void *, cur_csd_info);
 static atomic_t csd_bug_count = ATOMIC_INIT(0);
 
 /* Record current CSD work for current CPU, NULL to erase. */
-static void csd_lock_record(call_single_data_t *csd)
+static void csd_lock_record(struct __call_single_data *csd)
 {
 	if (!csd) {
 		smp_mb(); /* NULL cur_csd after unlock. */
@@ -125,7 +125,7 @@ static void csd_lock_record(call_single_data_t *csd)
 		  /* Or before unlock, as the case may be. */
 }
 
-static __always_inline int csd_lock_wait_getcpu(call_single_data_t *csd)
+static __always_inline int csd_lock_wait_getcpu(struct __call_single_data *csd)
 {
 	unsigned int csd_type;
 
@@ -140,7 +140,7 @@ static __always_inline int csd_lock_wait_getcpu(call_single_data_t *csd)
  * the CSD_TYPE_SYNC/ASYNC types provide the destination CPU,
  * so waiting on other types gets much less information.
  */
-static __always_inline bool csd_lock_wait_toolong(call_single_data_t *csd, u64 ts0, u64 *ts1, int *bug_id)
+static __always_inline bool csd_lock_wait_toolong(struct __call_single_data *csd, u64 ts0, u64 *ts1, int *bug_id)
 {
 	int cpu = -1;
 	int cpux;
@@ -204,7 +204,7 @@ static __always_inline bool csd_lock_wait_toolong(call_single_data_t *csd, u64 t
  * previous function call. For multi-cpu calls its even more interesting
  * as we'll have to ensure no other cpu is observing our csd.
  */
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	int bug_id = 0;
 	u64 ts0, ts1;
@@ -219,17 +219,17 @@ static __always_inline void csd_lock_wait(call_single_data_t *csd)
 }
 
 #else
-static void csd_lock_record(call_single_data_t *csd)
+static void csd_lock_record(struct __call_single_data *csd)
 {
 }
 
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	smp_cond_load_acquire(&csd->node.u_flags, !(VAL & CSD_FLAG_LOCK));
 }
 #endif
 
-static __always_inline void csd_lock(call_single_data_t *csd)
+static __always_inline void csd_lock(struct __call_single_data *csd)
 {
 	csd_lock_wait(csd);
 	csd->node.u_flags |= CSD_FLAG_LOCK;
@@ -242,7 +242,7 @@ static __always_inline void csd_lock(call_single_data_t *csd)
 	smp_wmb();
 }
 
-static __always_inline void csd_unlock(call_single_data_t *csd)
+static __always_inline void csd_unlock(struct __call_single_data *csd)
 {
 	WARN_ON(!(csd->node.u_flags & CSD_FLAG_LOCK));
 
@@ -276,7 +276,7 @@ void __smp_call_single_queue(int cpu, struct llist_node *node)
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static int generic_exec_single(int cpu, call_single_data_t *csd)
+static int generic_exec_single(int cpu, struct __call_single_data *csd)
 {
 	if (cpu == smp_processor_id()) {
 		smp_call_func_t func = csd->func;
@@ -542,7 +542,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * NOTE: Be careful, there is unfortunately no current debugging facility to
  * validate the correctness of this serialization.
  */
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	int err = 0;
 
diff --git a/kernel/up.c b/kernel/up.c
index c6f323dcd45b..4edd5493eba2 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -25,7 +25,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	unsigned long flags;
 

base-commit: 44a3370d47be9adf7532431a6d69583bb350ee57
-- 
2.31.1.527.g2d677e5b15


--fLKwDDoTK2blPOcV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1139aeb1c521-5.12.patch"

From 0032c9cbd15817bad8cee70e6d6441e4b0f9c638 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 5 May 2021 23:12:42 +0200
Subject: [PATCH 5.12] smp: Fix smp_call_function_single_async prototype

commit 1139aeb1c521eb4a050920ce6c64c36c4f2a3ab7 upstream.

As of commit 966a967116e6 ("smp: Avoid using two cache lines for struct
call_single_data"), the smp code prefers 32-byte aligned call_single_data
objects for performance reasons, but the block layer includes an instance
of this structure in the main 'struct request' that is more senstive
to size than to performance here, see 4ccafe032005 ("block: unalign
call_single_data in struct request").

The result is a violation of the calling conventions that clang correctly
points out:

block/blk-mq.c:630:39: warning: passing 8-byte aligned argument to 32-byte aligned parameter 2 of 'smp_call_function_single_async' may result in an unaligned pointer access [-Walign-mismatch]
                smp_call_function_single_async(cpu, &rq->csd);

It does seem that the usage of the call_single_data without cache line
alignment should still be allowed by the smp code, so just change the
function prototype so it accepts both, but leave the default alignment
unchanged for the other users. This seems better to me than adding
a local hack to shut up an otherwise correct warning in the caller.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Jens Axboe <axboe@kernel.dk>
Link: https://lkml.kernel.org/r/20210505211300.3174456-1-arnd@kernel.org
[nc: Fix conflicts]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 include/linux/smp.h |  2 +-
 kernel/smp.c        | 20 ++++++++++----------
 kernel/up.c         |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/smp.h b/include/linux/smp.h
index 70c6f6284dcf..238a3f97a415 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -73,7 +73,7 @@ void on_each_cpu_cond(smp_cond_func_t cond_func, smp_call_func_t func,
 void on_each_cpu_cond_mask(smp_cond_func_t cond_func, smp_call_func_t func,
 			   void *info, bool wait, const struct cpumask *mask);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd);
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/smp.c b/kernel/smp.c
index aeb0adfa0606..c678589fbb76 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -110,7 +110,7 @@ static DEFINE_PER_CPU(void *, cur_csd_info);
 static atomic_t csd_bug_count = ATOMIC_INIT(0);
 
 /* Record current CSD work for current CPU, NULL to erase. */
-static void csd_lock_record(call_single_data_t *csd)
+static void csd_lock_record(struct __call_single_data *csd)
 {
 	if (!csd) {
 		smp_mb(); /* NULL cur_csd after unlock. */
@@ -125,7 +125,7 @@ static void csd_lock_record(call_single_data_t *csd)
 		  /* Or before unlock, as the case may be. */
 }
 
-static __always_inline int csd_lock_wait_getcpu(call_single_data_t *csd)
+static __always_inline int csd_lock_wait_getcpu(struct __call_single_data *csd)
 {
 	unsigned int csd_type;
 
@@ -140,7 +140,7 @@ static __always_inline int csd_lock_wait_getcpu(call_single_data_t *csd)
  * the CSD_TYPE_SYNC/ASYNC types provide the destination CPU,
  * so waiting on other types gets much less information.
  */
-static __always_inline bool csd_lock_wait_toolong(call_single_data_t *csd, u64 ts0, u64 *ts1, int *bug_id)
+static __always_inline bool csd_lock_wait_toolong(struct __call_single_data *csd, u64 ts0, u64 *ts1, int *bug_id)
 {
 	int cpu = -1;
 	int cpux;
@@ -204,7 +204,7 @@ static __always_inline bool csd_lock_wait_toolong(call_single_data_t *csd, u64 t
  * previous function call. For multi-cpu calls its even more interesting
  * as we'll have to ensure no other cpu is observing our csd.
  */
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	int bug_id = 0;
 	u64 ts0, ts1;
@@ -219,17 +219,17 @@ static __always_inline void csd_lock_wait(call_single_data_t *csd)
 }
 
 #else
-static void csd_lock_record(call_single_data_t *csd)
+static void csd_lock_record(struct __call_single_data *csd)
 {
 }
 
-static __always_inline void csd_lock_wait(call_single_data_t *csd)
+static __always_inline void csd_lock_wait(struct __call_single_data *csd)
 {
 	smp_cond_load_acquire(&csd->node.u_flags, !(VAL & CSD_FLAG_LOCK));
 }
 #endif
 
-static __always_inline void csd_lock(call_single_data_t *csd)
+static __always_inline void csd_lock(struct __call_single_data *csd)
 {
 	csd_lock_wait(csd);
 	csd->node.u_flags |= CSD_FLAG_LOCK;
@@ -242,7 +242,7 @@ static __always_inline void csd_lock(call_single_data_t *csd)
 	smp_wmb();
 }
 
-static __always_inline void csd_unlock(call_single_data_t *csd)
+static __always_inline void csd_unlock(struct __call_single_data *csd)
 {
 	WARN_ON(!(csd->node.u_flags & CSD_FLAG_LOCK));
 
@@ -276,7 +276,7 @@ void __smp_call_single_queue(int cpu, struct llist_node *node)
  * for execution on the given CPU. data must already have
  * ->func, ->info, and ->flags set.
  */
-static int generic_exec_single(int cpu, call_single_data_t *csd)
+static int generic_exec_single(int cpu, struct __call_single_data *csd)
 {
 	if (cpu == smp_processor_id()) {
 		smp_call_func_t func = csd->func;
@@ -542,7 +542,7 @@ EXPORT_SYMBOL(smp_call_function_single);
  * NOTE: Be careful, there is unfortunately no current debugging facility to
  * validate the correctness of this serialization.
  */
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	int err = 0;
 
diff --git a/kernel/up.c b/kernel/up.c
index c6f323dcd45b..4edd5493eba2 100644
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -25,7 +25,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	unsigned long flags;
 

base-commit: 96e86bea450b3a00af5dc7ba5382f1b241e4306a
-- 
2.31.1.527.g2d677e5b15


--fLKwDDoTK2blPOcV--
