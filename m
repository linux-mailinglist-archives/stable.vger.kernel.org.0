Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B19D38A4AA
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbhETKHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:07:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232100AbhETKFb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:05:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A257D6193B;
        Thu, 20 May 2021 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503679;
        bh=qURO246+2vAK3TsFBzpTuXJeHrY/IQ9PWRX/GYoR+bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRGT+tF02Pfszt/RDfI9hGBeNoFZXNyjaJfb2AjB4L5GnPLQyHHXJP3WR8nE2dsgP
         u1vktXqRkSJoD0Ripw5vphPDuP8F7xwROe+bB4GhG2K0DIQwOJl9HByrZc6Oq3lZSu
         o6VuG6DZXI6RqQIc3nPZucoU+CcbW4SxgCEYMENU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 4.19 296/425] smp: Fix smp_call_function_single_async prototype
Date:   Thu, 20 May 2021 11:21:05 +0200
Message-Id: <20210520092141.176698236@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/smp.h |    2 +-
 kernel/smp.c        |   10 +++++-----
 kernel/up.c         |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -53,7 +53,7 @@ void on_each_cpu_cond(bool (*cond_func)(
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd);
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
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
@@ -121,7 +121,7 @@ static __always_inline void csd_lock(cal
 	smp_wmb();
 }
 
-static __always_inline void csd_unlock(call_single_data_t *csd)
+static __always_inline void csd_unlock(struct __call_single_data *csd)
 {
 	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
@@ -138,7 +138,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(cal
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
 
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -23,7 +23,7 @@ int smp_call_function_single(int cpu, vo
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	unsigned long flags;
 


