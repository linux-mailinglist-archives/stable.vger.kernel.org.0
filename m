Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A98B551E93
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 16:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350031AbiFTOBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 10:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350467AbiFTNxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:53:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D20060E7;
        Mon, 20 Jun 2022 06:19:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D19EB61147;
        Mon, 20 Jun 2022 13:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EC9C3411B;
        Mon, 20 Jun 2022 13:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655731144;
        bh=tzzT8uSHUoTJ0bW2sg2HH0tjuwUDsUplXZQ7BuFFYQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gtvlkq5kR5J55x2ZjN7UOrxVikTuINZmQsgYS6TlytrrA/e62w+WAuTBC0FZRLttQ
         WePAFZv9nWTAFQGdbgAn2l+U+SsZXxm0Kd6kvET3eQ5mtUDwW7BXV3tPAGZ1BW10D9
         tEcoiQFJ+g1pqq3VVK8pfcXStqOy565a07OIdqj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 168/240] random: convert to using fops->write_iter()
Date:   Mon, 20 Jun 2022 14:51:09 +0200
Message-Id: <20220620124743.869216139@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 22b0a222af4df8ee9bb8e07013ab44da9511b047 upstream.

Now that the read side has been converted to fix a regression with
splice, convert the write side as well to have some symmetry in the
interface used (and help deprecate ->write()).

Signed-off-by: Jens Axboe <axboe@kernel.dk>
[Jason: cleaned up random_ioctl a bit, require full writes in
 RNDADDENTROPY since it's crediting entropy, simplify control flow of
 write_pool(), and incorporate suggestions from Al.]
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   67 ++++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 32 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1251,39 +1251,31 @@ static __poll_t random_poll(struct file
 	return crng_ready() ? EPOLLIN | EPOLLRDNORM : EPOLLOUT | EPOLLWRNORM;
 }
 
-static int write_pool(const char __user *ubuf, size_t len)
+static ssize_t write_pool(struct iov_iter *iter)
 {
-	size_t block_len;
-	int ret = 0;
 	u8 block[BLAKE2S_BLOCK_SIZE];
+	ssize_t ret = 0;
+	size_t copied;
 
-	while (len) {
-		block_len = min(len, sizeof(block));
-		if (copy_from_user(block, ubuf, block_len)) {
-			ret = -EFAULT;
-			goto out;
-		}
-		len -= block_len;
-		ubuf += block_len;
-		mix_pool_bytes(block, block_len);
+	if (unlikely(!iov_iter_count(iter)))
+		return 0;
+
+	for (;;) {
+		copied = copy_from_iter(block, sizeof(block), iter);
+		ret += copied;
+		mix_pool_bytes(block, copied);
+		if (!iov_iter_count(iter) || copied != sizeof(block))
+			break;
 		cond_resched();
 	}
 
-out:
 	memzero_explicit(block, sizeof(block));
-	return ret;
+	return ret ? ret : -EFAULT;
 }
 
-static ssize_t random_write(struct file *file, const char __user *ubuf,
-			    size_t len, loff_t *ppos)
+static ssize_t random_write_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
-	int ret;
-
-	ret = write_pool(ubuf, len);
-	if (ret)
-		return ret;
-
-	return (ssize_t)len;
+	return write_pool(iter);
 }
 
 static ssize_t urandom_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
@@ -1315,9 +1307,8 @@ static ssize_t random_read_iter(struct k
 
 static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
-	int size, ent_count;
 	int __user *p = (int __user *)arg;
-	int retval;
+	int ent_count;
 
 	switch (cmd) {
 	case RNDGETENTCNT:
@@ -1334,20 +1325,32 @@ static long random_ioctl(struct file *f,
 			return -EINVAL;
 		credit_init_bits(ent_count);
 		return 0;
-	case RNDADDENTROPY:
+	case RNDADDENTROPY: {
+		struct iov_iter iter;
+		struct iovec iov;
+		ssize_t ret;
+		int len;
+
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 		if (get_user(ent_count, p++))
 			return -EFAULT;
 		if (ent_count < 0)
 			return -EINVAL;
-		if (get_user(size, p++))
+		if (get_user(len, p++))
+			return -EFAULT;
+		ret = import_single_range(WRITE, p, len, &iov, &iter);
+		if (unlikely(ret))
+			return ret;
+		ret = write_pool(&iter);
+		if (unlikely(ret < 0))
+			return ret;
+		/* Since we're crediting, enforce that it was all written into the pool. */
+		if (unlikely(ret != len))
 			return -EFAULT;
-		retval = write_pool((const char __user *)p, size);
-		if (retval < 0)
-			return retval;
 		credit_init_bits(ent_count);
 		return 0;
+	}
 	case RNDZAPENTCNT:
 	case RNDCLEARPOOL:
 		/* No longer has any effect. */
@@ -1373,7 +1376,7 @@ static int random_fasync(int fd, struct
 
 const struct file_operations random_fops = {
 	.read_iter = random_read_iter,
-	.write = random_write,
+	.write_iter = random_write_iter,
 	.poll = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
@@ -1383,7 +1386,7 @@ const struct file_operations random_fops
 
 const struct file_operations urandom_fops = {
 	.read_iter = urandom_read_iter,
-	.write = random_write,
+	.write_iter = random_write_iter,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,


