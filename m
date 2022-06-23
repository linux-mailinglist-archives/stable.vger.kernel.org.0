Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DE1558431
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbiFWRk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234804AbiFWRiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:38:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC9D55A2;
        Thu, 23 Jun 2022 10:08:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FF9061408;
        Thu, 23 Jun 2022 17:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6489AC3411B;
        Thu, 23 Jun 2022 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004094;
        bh=vK0fXNqPgjwTTdxhl/hHI4TKuDJrdal4ILp4WcGmV68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i1RmfDMMBjBbdrktdJNX05S+yrwLi6ZzP8DihcXW/Cmuovmcf/m5kjkJtLicARTRP
         xg2f00KrP3+139n0HJJL9U3fq6iDLTn6KoSsU6I2NaU2yUb2xhxJoXOzDm7M/4XCMp
         Cn2Bn2OKhZ3ZtSgn7YDuZThP0xmpaOoeFgMjhQB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 179/237] random: move randomize_page() into mm where it belongs
Date:   Thu, 23 Jun 2022 18:43:33 +0200
Message-Id: <20220623164348.299923188@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 5ad7dd882e45d7fe432c32e896e2aaa0b21746ea upstream.

randomize_page is an mm function. It is documented like one. It contains
the history of one. It has the naming convention of one. It looks
just like another very similar function in mm, randomize_stack_top().
And it has always been maintained and updated by mm people. There is no
need for it to be in random.c. In the "which shape does not look like
the other ones" test, pointing to randomize_page() is correct.

So move randomize_page() into mm/util.c, right next to the similar
randomize_stack_top() function.

This commit contains no actual code changes.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |  238 ++++++++++++++++---------------------------------
 include/linux/mm.h     |    2 
 include/linux/random.h |    2 
 mm/util.c              |   33 ++++++
 4 files changed, 117 insertions(+), 158 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -52,6 +52,7 @@
 #include <linux/uuid.h>
 #include <linux/uaccess.h>
 #include <linux/siphash.h>
+#include <linux/uio.h>
 #include <crypto/chacha20.h>
 #include <crypto/blake2s.h>
 #include <asm/processor.h>
@@ -446,13 +447,13 @@ void get_random_bytes(void *buf, size_t
 }
 EXPORT_SYMBOL(get_random_bytes);
 
-static ssize_t get_random_bytes_user(void __user *ubuf, size_t len)
+static ssize_t get_random_bytes_user(struct iov_iter *iter)
 {
-	size_t block_len, left, ret = 0;
 	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
-	u8 output[CHACHA20_BLOCK_SIZE];
+	u8 block[CHACHA20_BLOCK_SIZE];
+	size_t ret = 0, copied;
 
-	if (!len)
+	if (unlikely(!iov_iter_count(iter)))
 		return 0;
 
 	/*
@@ -466,30 +467,22 @@ static ssize_t get_random_bytes_user(voi
 	 * use chacha_state after, so we can simply return those bytes to
 	 * the user directly.
 	 */
-	if (len <= CHACHA20_KEY_SIZE) {
-		ret = len - copy_to_user(ubuf, &chacha_state[4], len);
+	if (iov_iter_count(iter) <= CHACHA20_KEY_SIZE) {
+		ret = copy_to_iter(&chacha_state[4], CHACHA20_KEY_SIZE, iter);
 		goto out_zero_chacha;
 	}
 
 	for (;;) {
-		chacha20_block(chacha_state, output);
+		chacha20_block(chacha_state, block);
 		if (unlikely(chacha_state[12] == 0))
 			++chacha_state[13];
 
-		block_len = min_t(size_t, len, CHACHA20_BLOCK_SIZE);
-		left = copy_to_user(ubuf, output, block_len);
-		if (left) {
-			ret += block_len - left;
+		copied = copy_to_iter(block, sizeof(block), iter);
+		ret += copied;
+		if (!iov_iter_count(iter) || copied != sizeof(block))
 			break;
-		}
 
-		ubuf += block_len;
-		ret += block_len;
-		len -= block_len;
-		if (!len)
-			break;
-
-		BUILD_BUG_ON(PAGE_SIZE % CHACHA20_BLOCK_SIZE != 0);
+		BUILD_BUG_ON(PAGE_SIZE % sizeof(block) != 0);
 		if (ret % PAGE_SIZE == 0) {
 			if (signal_pending(current))
 				break;
@@ -497,7 +490,7 @@ static ssize_t get_random_bytes_user(voi
 		}
 	}
 
-	memzero_explicit(output, sizeof(output));
+	memzero_explicit(block, sizeof(block));
 out_zero_chacha:
 	memzero_explicit(chacha_state, sizeof(chacha_state));
 	return ret ? ret : -EFAULT;
@@ -509,96 +502,60 @@ out_zero_chacha:
  * provided by this function is okay, the function wait_for_random_bytes()
  * should be called and return 0 at least once at any point prior.
  */
-struct batched_entropy {
-	union {
-		/*
-		 * We make this 1.5x a ChaCha block, so that we get the
-		 * remaining 32 bytes from fast key erasure, plus one full
-		 * block from the detached ChaCha state. We can increase
-		 * the size of this later if needed so long as we keep the
-		 * formula of (integer_blocks + 0.5) * CHACHA20_BLOCK_SIZE.
-		 */
-		u64 entropy_u64[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u64))];
-		u32 entropy_u32[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(u32))];
-	};
-	unsigned long generation;
-	unsigned int position;
-};
-
-
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
-	.position = UINT_MAX
-};
-
-u64 get_random_u64(void)
-{
-	u64 ret;
-	unsigned long flags;
-	struct batched_entropy *batch;
-	unsigned long next_gen;
-
-	warn_unseeded_randomness();
-
-	if  (!crng_ready()) {
-		_get_random_bytes(&ret, sizeof(ret));
-		return ret;
-	}
-
-	local_irq_save(flags);
-	batch = raw_cpu_ptr(&batched_entropy_u64);
-
-	next_gen = READ_ONCE(base_crng.generation);
-	if (batch->position >= ARRAY_SIZE(batch->entropy_u64) ||
-	    next_gen != batch->generation) {
-		_get_random_bytes(batch->entropy_u64, sizeof(batch->entropy_u64));
-		batch->position = 0;
-		batch->generation = next_gen;
-	}
-
-	ret = batch->entropy_u64[batch->position];
-	batch->entropy_u64[batch->position] = 0;
-	++batch->position;
-	local_irq_restore(flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u64);
-
-static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.position = UINT_MAX
-};
-
-u32 get_random_u32(void)
-{
-	u32 ret;
-	unsigned long flags;
-	struct batched_entropy *batch;
-	unsigned long next_gen;
 
-	warn_unseeded_randomness();
+#define DEFINE_BATCHED_ENTROPY(type)						\
+struct batch_ ##type {								\
+	/*									\
+	 * We make this 1.5x a ChaCha block, so that we get the			\
+	 * remaining 32 bytes from fast key erasure, plus one full		\
+	 * block from the detached ChaCha state. We can increase		\
+	 * the size of this later if needed so long as we keep the		\
+	 * formula of (integer_blocks + 0.5) * CHACHA20_BLOCK_SIZE.		\
+	 */									\
+	type entropy[CHACHA20_BLOCK_SIZE * 3 / (2 * sizeof(type))];		\
+	unsigned long generation;						\
+	unsigned int position;							\
+};										\
+										\
+static DEFINE_PER_CPU(struct batch_ ##type, batched_entropy_ ##type) = {	\
+	.position = UINT_MAX							\
+};										\
+										\
+type get_random_ ##type(void)							\
+{										\
+	type ret;								\
+	unsigned long flags;							\
+	struct batch_ ##type *batch;						\
+	unsigned long next_gen;							\
+										\
+	warn_unseeded_randomness();						\
+										\
+	if  (!crng_ready()) {							\
+		_get_random_bytes(&ret, sizeof(ret));				\
+		return ret;							\
+	}									\
+										\
+	local_irq_save(flags);		\
+	batch = raw_cpu_ptr(&batched_entropy_##type);				\
+										\
+	next_gen = READ_ONCE(base_crng.generation);				\
+	if (batch->position >= ARRAY_SIZE(batch->entropy) ||			\
+	    next_gen != batch->generation) {					\
+		_get_random_bytes(batch->entropy, sizeof(batch->entropy));	\
+		batch->position = 0;						\
+		batch->generation = next_gen;					\
+	}									\
+										\
+	ret = batch->entropy[batch->position];					\
+	batch->entropy[batch->position] = 0;					\
+	++batch->position;							\
+	local_irq_restore(flags);		\
+	return ret;								\
+}										\
+EXPORT_SYMBOL(get_random_ ##type);
 
-	if  (!crng_ready()) {
-		_get_random_bytes(&ret, sizeof(ret));
-		return ret;
-	}
-
-	local_irq_save(flags);
-	batch = raw_cpu_ptr(&batched_entropy_u32);
-
-	next_gen = READ_ONCE(base_crng.generation);
-	if (batch->position >= ARRAY_SIZE(batch->entropy_u32) ||
-	    next_gen != batch->generation) {
-		_get_random_bytes(batch->entropy_u32, sizeof(batch->entropy_u32));
-		batch->position = 0;
-		batch->generation = next_gen;
-	}
-
-	ret = batch->entropy_u32[batch->position];
-	batch->entropy_u32[batch->position] = 0;
-	++batch->position;
-	local_irq_restore(flags);
-	return ret;
-}
-EXPORT_SYMBOL(get_random_u32);
+DEFINE_BATCHED_ENTROPY(u64)
+DEFINE_BATCHED_ENTROPY(u32)
 
 #ifdef CONFIG_SMP
 /*
@@ -619,38 +576,6 @@ int __cold random_prepare_cpu(unsigned i
 }
 #endif
 
-/**
- * randomize_page - Generate a random, page aligned address
- * @start:	The smallest acceptable address the caller will take.
- * @range:	The size of the area, starting at @start, within which the
- *		random address must fall.
- *
- * If @start + @range would overflow, @range is capped.
- *
- * NOTE: Historical use of randomize_range, which this replaces, presumed that
- * @start was already page aligned.  We now align it regardless.
- *
- * Return: A page aligned address within [start, start + range).  On error,
- * @start is returned.
- */
-unsigned long randomize_page(unsigned long start, unsigned long range)
-{
-	if (!PAGE_ALIGNED(start)) {
-		range -= PAGE_ALIGN(start) - start;
-		start = PAGE_ALIGN(start);
-	}
-
-	if (start > ULONG_MAX - range)
-		range = ULONG_MAX - start;
-
-	range >>= PAGE_SHIFT;
-
-	if (range == 0)
-		return start;
-
-	return start + (get_random_long() % range << PAGE_SHIFT);
-}
-
 /*
  * This function will use the architecture-specific hardware random
  * number generator if it is available. It is not recommended for
@@ -1292,6 +1217,10 @@ static void __cold try_to_generate_entro
 
 SYSCALL_DEFINE3(getrandom, char __user *, ubuf, size_t, len, unsigned int, flags)
 {
+	struct iov_iter iter;
+	struct iovec iov;
+	int ret;
+
 	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
 		return -EINVAL;
 
@@ -1302,19 +1231,18 @@ SYSCALL_DEFINE3(getrandom, char __user *
 	if ((flags & (GRND_INSECURE | GRND_RANDOM)) == (GRND_INSECURE | GRND_RANDOM))
 		return -EINVAL;
 
-	if (len > INT_MAX)
-		len = INT_MAX;
-
 	if (!crng_ready() && !(flags & GRND_INSECURE)) {
-		int ret;
-
 		if (flags & GRND_NONBLOCK)
 			return -EAGAIN;
 		ret = wait_for_random_bytes();
 		if (unlikely(ret))
 			return ret;
 	}
-	return get_random_bytes_user(ubuf, len);
+
+	ret = import_single_range(READ, ubuf, len, &iov, &iter);
+	if (unlikely(ret))
+		return ret;
+	return get_random_bytes_user(&iter);
 }
 
 static unsigned int random_poll(struct file *file, poll_table *wait)
@@ -1358,8 +1286,7 @@ static ssize_t random_write(struct file
 	return (ssize_t)len;
 }
 
-static ssize_t urandom_read(struct file *file, char __user *ubuf,
-			    size_t len, loff_t *ppos)
+static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
 	static int maxwarn = 10;
 
@@ -1368,23 +1295,22 @@ static ssize_t urandom_read(struct file
 			++urandom_warning.missed;
 		else if (ratelimit_disable || __ratelimit(&urandom_warning)) {
 			--maxwarn;
-			pr_notice("%s: uninitialized urandom read (%zd bytes read)\n",
-				  current->comm, len);
+			pr_notice("%s: uninitialized urandom read (%zu bytes read)\n",
+				  current->comm, iov_iter_count(iter));
 		}
 	}
 
-	return get_random_bytes_user(ubuf, len);
+	return get_random_bytes_user(iter);
 }
 
-static ssize_t random_read(struct file *file, char __user *ubuf,
-			   size_t len, loff_t *ppos)
+static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
 	int ret;
 
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;
-	return get_random_bytes_user(ubuf, len);
+	return get_random_bytes_user(iter);
 }
 
 static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
@@ -1446,7 +1372,7 @@ static int random_fasync(int fd, struct
 }
 
 const struct file_operations random_fops = {
-	.read = random_read,
+	.read_iter = random_read_iter,
 	.write = random_write,
 	.poll = random_poll,
 	.unlocked_ioctl = random_ioctl,
@@ -1455,7 +1381,7 @@ const struct file_operations random_fops
 };
 
 const struct file_operations urandom_fops = {
-	.read = urandom_read,
+	.read_iter = urandom_read_iter,
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
 	.fasync = random_fasync,
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2164,6 +2164,8 @@ extern int install_special_mapping(struc
 				   unsigned long addr, unsigned long len,
 				   unsigned long flags, struct page **pages);
 
+unsigned long randomize_page(unsigned long start, unsigned long range);
+
 extern unsigned long get_unmapped_area(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
 
 extern unsigned long mmap_region(struct file *file, unsigned long addr,
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -64,8 +64,6 @@ static inline unsigned long get_random_c
 	return get_random_long() & CANARY_MASK;
 }
 
-unsigned long randomize_page(unsigned long start, unsigned long range);
-
 int __init random_init(const char *command_line);
 bool rng_is_initialized(void);
 int wait_for_random_bytes(void);
--- a/mm/util.c
+++ b/mm/util.c
@@ -14,6 +14,7 @@
 #include <linux/hugetlb.h>
 #include <linux/vmalloc.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/random.h>
 
 #include <asm/sections.h>
 #include <linux/uaccess.h>
@@ -264,6 +265,38 @@ int vma_is_stack_for_current(struct vm_a
 	return (vma->vm_start <= KSTK_ESP(t) && vma->vm_end >= KSTK_ESP(t));
 }
 
+/**
+ * randomize_page - Generate a random, page aligned address
+ * @start:	The smallest acceptable address the caller will take.
+ * @range:	The size of the area, starting at @start, within which the
+ *		random address must fall.
+ *
+ * If @start + @range would overflow, @range is capped.
+ *
+ * NOTE: Historical use of randomize_range, which this replaces, presumed that
+ * @start was already page aligned.  We now align it regardless.
+ *
+ * Return: A page aligned address within [start, start + range).  On error,
+ * @start is returned.
+ */
+unsigned long randomize_page(unsigned long start, unsigned long range)
+{
+	if (!PAGE_ALIGNED(start)) {
+		range -= PAGE_ALIGN(start) - start;
+		start = PAGE_ALIGN(start);
+	}
+
+	if (start > ULONG_MAX - range)
+		range = ULONG_MAX - start;
+
+	range >>= PAGE_SHIFT;
+
+	if (range == 0)
+		return start;
+
+	return start + (get_random_long() % range << PAGE_SHIFT);
+}
+
 #if defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {


