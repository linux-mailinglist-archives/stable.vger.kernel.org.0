Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50235412AEA
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234433AbhIUCDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbhIUBwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 21:52:47 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70B4C0363F7
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 16:25:47 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 70-20020a370b49000000b003d2f5f0dcc6so155673834qkl.9
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 16:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pguml3paj2LeB5heWrEsmrwhMCMlKDyRkBgZeHcvxlM=;
        b=QZvWuxoHRNl58kiylK3SiDmPeerQVYX1bUDQBZvz+VKz1OMGl/VnuqM0ABNzQDb6Ks
         /8L5utuNlUXChpYBFhNF2j+HVg1mUtaSM1C++icVmp55GCqaiFMAekzxaXp7yLULEBqL
         B2M3VblthoUdv+c424XdVu3PIbqROYvkP6q636u4C/xksk7EMrpPw9C629VarSo0IUgj
         bWWo3JG1sp5xNKkdMuAr9md9rg4qE/dxFKhz5Si/8nKiCl82o2FbENB0TMZLhDtZZBD8
         bjh175RLHfVQLJIWq9UxDARd2i3adArN3u2WB+UH6d3D2QhVW5wM6mD6Cm5Gc74zLwbI
         Zclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pguml3paj2LeB5heWrEsmrwhMCMlKDyRkBgZeHcvxlM=;
        b=ASox+Wwj/2c8XinA6VYXQSMkchxua9txixrhifnGaVr8AhZpkOOt2UgKBqcxcsAB36
         rsTy/ZDcTSOILjrsA78BMPOauP/wU9i1vDlIMi3Sv9V1pEVwdjGhKFD5DGqsZbFHNrTl
         uhi5qPVk3FifTOFh7bf7CvfU+opi8EQ63PbNsZtwerGndPnzk8zqU2Ds32ZGvt1Bnu+F
         ue9+AO+A5+stx0F12bckNdaY4RJWiKiu+08A8AkQy5nAHbDJ83PTKpxeTVR7KSz4qKlW
         ghlZ//o7nRoq7jDkTvuCjARI/97V0FyhU7JtYWWbueHmUVkbz/GFmh58IWaOfsgJ0kiG
         bm4g==
X-Gm-Message-State: AOAM5312qpVx8rJtBN7oKWw6+UhjGK8uIOJVQyajHdf7R4pSGnxHEU7m
        DzUKhTWZXbB86Jzr3jmqt7XjC3PtkW2hahDifRg=
X-Google-Smtp-Source: ABdhPJynuijKVoLP4/VxFshGz4xzdVcUOFIM1JQUgfFc54WcKcKHkKbKBrxx0Jq/2ZeuvyKmn4VSCDiGwarRap9I62E=
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:5f32:153:b2ea:296d])
 (user=ndesaulniers job=sendgmr) by 2002:a25:1388:: with SMTP id
 130mr33364420ybt.58.1632180346968; Mon, 20 Sep 2021 16:25:46 -0700 (PDT)
Date:   Mon, 20 Sep 2021 16:25:33 -0700
Message-Id: <20210920232533.4092046-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH] nbd: use shifts rather than multiplies
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, nbd@other.debian.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fad7cd3310db ("nbd: add the check to prevent overflow in
__nbd_ioctl()") raised an issue from the fallback helpers added in
commit f0907827a8a9 ("compiler.h: enable builtin overflow checkers and
add fallback code")

ERROR: modpost: "__divdi3" [drivers/block/nbd.ko] undefined!

As Stephen Rothwell notes:
  The added check_mul_overflow() call is being passed 64 bit values.
  COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW is not set for this build (see
  include/linux/overflow.h).

Specifically, the helpers for checking whether the results of a
multiplication overflowed (__unsigned_mul_overflow,
__signed_add_overflow) use the division operator when
!COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW.  This is problematic for 64b
operands on 32b hosts.

This was fixed upstream by
commit 76ae847497bc ("Documentation: raise minimum supported version of
GCC to 5.1")
which is not suitable to be backported to stable.

Further, __builtin_mul_overflow() would emit a libcall to a
compiler-rt-only symbol when compiling with clang < 14 for 32b targets.

ld.lld: error: undefined symbol: __mulodi4

In order to keep stable buildable with GCC 4.9 and clang < 14, modify
struct nbd_config to instead track the number of bits of the block size;
reconstructing the block size using runtime checked shifts that are not
problematic for those compilers and in a ways that can be backported to
stable.

In nbd_set_size, we do validate that the value of blksize must be a
power of two (POT) and is in the range of [512, PAGE_SIZE] (both
inclusive).

This does modify the debugfs interface.

Cc: stable@vger.kernel.org
Cc: Arnd Bergmann <arnd@kernel.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Link: https://github.com/ClangBuiltLinux/linux/issues/1438
Link: https://lore.kernel.org/all/20210909182525.372ee687@canb.auug.org.au/
Link: https://lore.kernel.org/stable/CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com/
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Kees Cook <keescook@chromium.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
This patch is kind of a v3 for solving this problem.
v2: https://lore.kernel.org/stable/20210914002318.2298583-1-ndesaulniers@google.com/
v1: https://lore.kernel.org/stable/20210913203201.1844253-1-ndesaulniers@google.com/
But is quite different in approach. Instead of trying to fix up the
overflow routines in stable, we amend the code in nbd.c as per Linus
(against mainline) with fixes from Kees to use the named overflow
checker.

 drivers/block/nbd.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5170a630778d..1183f7872b71 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -97,13 +97,18 @@ struct nbd_config {
 
 	atomic_t recv_threads;
 	wait_queue_head_t recv_wq;
-	loff_t blksize;
+	unsigned int blksize_bits;
 	loff_t bytesize;
 #if IS_ENABLED(CONFIG_DEBUG_FS)
 	struct dentry *dbg_dir;
 #endif
 };
 
+static inline unsigned int nbd_blksize(struct nbd_config *config)
+{
+	return 1u << config->blksize_bits;
+}
+
 struct nbd_device {
 	struct blk_mq_tag_set tag_set;
 
@@ -146,7 +151,7 @@ static struct dentry *nbd_dbg_dir;
 
 #define NBD_MAGIC 0x68797548
 
-#define NBD_DEF_BLKSIZE 1024
+#define NBD_DEF_BLKSIZE_BITS 10
 
 static unsigned int nbds_max = 16;
 static int max_part = 16;
@@ -317,12 +322,12 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
 		loff_t blksize)
 {
 	if (!blksize)
-		blksize = NBD_DEF_BLKSIZE;
+		blksize = 1u << NBD_DEF_BLKSIZE_BITS;
 	if (blksize < 512 || blksize > PAGE_SIZE || !is_power_of_2(blksize))
 		return -EINVAL;
 
 	nbd->config->bytesize = bytesize;
-	nbd->config->blksize = blksize;
+	nbd->config->blksize_bits = __ffs(blksize);
 
 	if (!nbd->task_recv)
 		return 0;
@@ -1337,7 +1342,7 @@ static int nbd_start_device(struct nbd_device *nbd)
 		args->index = i;
 		queue_work(nbd->recv_workq, &args->work);
 	}
-	return nbd_set_size(nbd, config->bytesize, config->blksize);
+	return nbd_set_size(nbd, config->bytesize, nbd_blksize(config));
 }
 
 static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *bdev)
@@ -1406,11 +1411,11 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 	case NBD_SET_BLKSIZE:
 		return nbd_set_size(nbd, config->bytesize, arg);
 	case NBD_SET_SIZE:
-		return nbd_set_size(nbd, arg, config->blksize);
+		return nbd_set_size(nbd, arg, nbd_blksize(config));
 	case NBD_SET_SIZE_BLOCKS:
-		if (check_mul_overflow((loff_t)arg, config->blksize, &bytesize))
+		if (check_shl_overflow(arg, config->blksize_bits, &bytesize))
 			return -EINVAL;
-		return nbd_set_size(nbd, bytesize, config->blksize);
+		return nbd_set_size(nbd, bytesize, nbd_blksize(config));
 	case NBD_SET_TIMEOUT:
 		nbd_set_cmd_timeout(nbd, arg);
 		return 0;
@@ -1476,7 +1481,7 @@ static struct nbd_config *nbd_alloc_config(void)
 	atomic_set(&config->recv_threads, 0);
 	init_waitqueue_head(&config->recv_wq);
 	init_waitqueue_head(&config->conn_wait);
-	config->blksize = NBD_DEF_BLKSIZE;
+	config->blksize_bits = NBD_DEF_BLKSIZE_BITS;
 	atomic_set(&config->live_connections, 0);
 	try_module_get(THIS_MODULE);
 	return config;
@@ -1604,7 +1609,7 @@ static int nbd_dev_dbg_init(struct nbd_device *nbd)
 	debugfs_create_file("tasks", 0444, dir, nbd, &nbd_dbg_tasks_fops);
 	debugfs_create_u64("size_bytes", 0444, dir, &config->bytesize);
 	debugfs_create_u32("timeout", 0444, dir, &nbd->tag_set.timeout);
-	debugfs_create_u64("blocksize", 0444, dir, &config->blksize);
+	debugfs_create_u32("blocksize_bits", 0444, dir, &config->blksize_bits);
 	debugfs_create_file("flags", 0444, dir, nbd, &nbd_dbg_flags_fops);
 
 	return 0;
@@ -1826,7 +1831,7 @@ nbd_device_policy[NBD_DEVICE_ATTR_MAX + 1] = {
 static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
 {
 	struct nbd_config *config = nbd->config;
-	u64 bsize = config->blksize;
+	u64 bsize = nbd_blksize(config);
 	u64 bytes = config->bytesize;
 
 	if (info->attrs[NBD_ATTR_SIZE_BYTES])
@@ -1835,7 +1840,7 @@ static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
 	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES])
 		bsize = nla_get_u64(info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]);
 
-	if (bytes != config->bytesize || bsize != config->blksize)
+	if (bytes != config->bytesize || bsize != nbd_blksize(config))
 		return nbd_set_size(nbd, bytes, bsize);
 	return 0;
 }

base-commit: 4c17ca27923c16fd73bbb9ad033c7d749c3bcfcc
-- 
2.33.0.464.g1972c5931b-goog

