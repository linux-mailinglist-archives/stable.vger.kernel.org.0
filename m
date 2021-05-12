Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF5837C287
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhELPLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:11:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233420AbhELPJX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:09:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 626F16144B;
        Wed, 12 May 2021 15:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831735;
        bh=1Ovjz6viYjYjWr7dNtzeN9TavdwQ+Cji3hGQ8jOWmB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MFEmPK+VMxPfUbaEOvcZ5/loWZHPzvAOrVRATFBEBd42FrAraHFkra0+8+fkFdGgw
         aGegjWv3kd202Qq3rw1EEYcXmkMM1e/foB3U31Npc9K8089EGL7/9DJBzLRKJGoAh/
         Na3qBLRC5INFMEKd9ATguRGyVwvXIBKwcAMBRuXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 240/244] smp: Fix smp_call_function_single_async prototype
Date:   Wed, 12 May 2021 16:50:11 +0200
Message-Id: <20210512144750.678746102@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
@@ -57,7 +57,7 @@ void on_each_cpu_cond_mask(bool (*cond_f
 		smp_call_func_t func, void *info, bool wait,
 		gfp_t gfp_flags, const struct cpumask *mask);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd);
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd);
 
 #ifdef CONFIG_SMP
 
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
@@ -122,7 +122,7 @@ static __always_inline void csd_lock(cal
 	smp_wmb();
 }
 
-static __always_inline void csd_unlock(call_single_data_t *csd)
+static __always_inline void csd_unlock(struct __call_single_data *csd)
 {
 	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
@@ -139,7 +139,7 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(cal
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
 
--- a/kernel/up.c
+++ b/kernel/up.c
@@ -24,7 +24,7 @@ int smp_call_function_single(int cpu, vo
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
-int smp_call_function_single_async(int cpu, call_single_data_t *csd)
+int smp_call_function_single_async(int cpu, struct __call_single_data *csd)
 {
 	unsigned long flags;
 


