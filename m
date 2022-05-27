Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6DAA5361A4
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352762AbiE0MHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 08:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353497AbiE0MGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 08:06:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D841649B0;
        Fri, 27 May 2022 04:54:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B76561D9F;
        Fri, 27 May 2022 11:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895F3C385A9;
        Fri, 27 May 2022 11:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652485;
        bh=76oionJbUWHK6noOc6OvKBCGTvYI7yBCZX+ppwL95F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JwWyuYLdG433NkomHbt65u6x2N7yq7AiilMLx5SNTg8JWtE6E3mIuTV1y68M3sG3W
         lXlxnVuH+AvgPbz6v19tEDdYP54UvlIZThHHT+7XHneHnSR5X0+P7zlrrFr7IquD+1
         +gQSBYMEd2TEyS+y+OaJ0sX5pfQZUOcTbLkGvY+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 159/163] random: convert to using fops->read_iter()
Date:   Fri, 27 May 2022 10:50:39 +0200
Message-Id: <20220527084850.311271004@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 1b388e7765f2eaa137cf5d92b47ef5925ad83ced upstream.

This is a pre-requisite to wiring up splice() again for the random
and urandom drivers. It also allows us to remove the INT_MAX check in
getrandom(), because import_single_range() applies capping internally.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
[Jason: rewrote get_random_bytes_user() to simplify and also incorporate
 additional suggestions from Al.]
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   66 ++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -52,6 +52,7 @@
 #include <linux/uuid.h>
 #include <linux/uaccess.h>
 #include <linux/siphash.h>
+#include <linux/uio.h>
 #include <crypto/chacha.h>
 #include <crypto/blake2s.h>
 #include <asm/processor.h>
@@ -448,13 +449,13 @@ void get_random_bytes(void *buf, size_t
 }
 EXPORT_SYMBOL(get_random_bytes);
 
-static ssize_t get_random_bytes_user(void __user *ubuf, size_t len)
+static ssize_t get_random_bytes_user(struct iov_iter *iter)
 {
-	size_t block_len, left, ret = 0;
 	u32 chacha_state[CHACHA_STATE_WORDS];
-	u8 output[CHACHA_BLOCK_SIZE];
+	u8 block[CHACHA_BLOCK_SIZE];
+	size_t ret = 0, copied;
 
-	if (!len)
+	if (unlikely(!iov_iter_count(iter)))
 		return 0;
 
 	/*
@@ -468,30 +469,22 @@ static ssize_t get_random_bytes_user(voi
 	 * use chacha_state after, so we can simply return those bytes to
 	 * the user directly.
 	 */
-	if (len <= CHACHA_KEY_SIZE) {
-		ret = len - copy_to_user(ubuf, &chacha_state[4], len);
+	if (iov_iter_count(iter) <= CHACHA_KEY_SIZE) {
+		ret = copy_to_iter(&chacha_state[4], CHACHA_KEY_SIZE, iter);
 		goto out_zero_chacha;
 	}
 
 	for (;;) {
-		chacha20_block(chacha_state, output);
+		chacha20_block(chacha_state, block);
 		if (unlikely(chacha_state[12] == 0))
 			++chacha_state[13];
 
-		block_len = min_t(size_t, len, CHACHA_BLOCK_SIZE);
-		left = copy_to_user(ubuf, output, block_len);
-		if (left) {
-			ret += block_len - left;
-			break;
-		}
-
-		ubuf += block_len;
-		ret += block_len;
-		len -= block_len;
-		if (!len)
+		copied = copy_to_iter(block, sizeof(block), iter);
+		ret += copied;
+		if (!iov_iter_count(iter) || copied != sizeof(block))
 			break;
 
-		BUILD_BUG_ON(PAGE_SIZE % CHACHA_BLOCK_SIZE != 0);
+		BUILD_BUG_ON(PAGE_SIZE % sizeof(block) != 0);
 		if (ret % PAGE_SIZE == 0) {
 			if (signal_pending(current))
 				break;
@@ -499,7 +492,7 @@ static ssize_t get_random_bytes_user(voi
 		}
 	}
 
-	memzero_explicit(output, sizeof(output));
+	memzero_explicit(block, sizeof(block));
 out_zero_chacha:
 	memzero_explicit(chacha_state, sizeof(chacha_state));
 	return ret ? ret : -EFAULT;
@@ -1228,6 +1221,10 @@ static void __cold try_to_generate_entro
 
 SYSCALL_DEFINE3(getrandom, char __user *, ubuf, size_t, len, unsigned int, flags)
 {
+	struct iov_iter iter;
+	struct iovec iov;
+	int ret;
+
 	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
 		return -EINVAL;
 
@@ -1238,19 +1235,18 @@ SYSCALL_DEFINE3(getrandom, char __user *
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
 
 static __poll_t random_poll(struct file *file, poll_table *wait)
@@ -1294,8 +1290,7 @@ static ssize_t random_write(struct file
 	return (ssize_t)len;
 }
 
-static ssize_t urandom_read(struct file *file, char __user *ubuf,
-			    size_t len, loff_t *ppos)
+static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
 	static int maxwarn = 10;
 
@@ -1304,23 +1299,22 @@ static ssize_t urandom_read(struct file
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
@@ -1382,7 +1376,7 @@ static int random_fasync(int fd, struct
 }
 
 const struct file_operations random_fops = {
-	.read = random_read,
+	.read_iter = random_read_iter,
 	.write = random_write,
 	.poll = random_poll,
 	.unlocked_ioctl = random_ioctl,
@@ -1392,7 +1386,7 @@ const struct file_operations random_fops
 };
 
 const struct file_operations urandom_fops = {
-	.read = urandom_read,
+	.read_iter = urandom_read_iter,
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,


