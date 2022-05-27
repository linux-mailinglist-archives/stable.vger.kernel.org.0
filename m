Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D8653606A
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbiE0Lw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352975AbiE0LvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:51:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC0E5E147;
        Fri, 27 May 2022 04:46:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0CACACE2515;
        Fri, 27 May 2022 11:46:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C34C3411B;
        Fri, 27 May 2022 11:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651987;
        bh=2SasQTV6ClENlko5/hdJg+orqIXDfNMPBOI6d7o77qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VPVPBv1+cVErIK7A1bvVMVXrqZ9EJEwiI7xN4CjmxsRmA8U/8/mfha7FQM/VIvsoV
         gLIND98rl2iNTkbd5lpyHoTGPOAdtsnAmDNPYsre+j/ogxWesbLSL2svQI8xXuuY5D
         tLQ/Oxp0HsH8PBcCDxFN5MRR4uyStIz8xdtuM2Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.17 107/111] random: convert to using fops->write_iter()
Date:   Fri, 27 May 2022 10:50:19 +0200
Message-Id: <20220527084834.398838429@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084819.133490171@linuxfoundation.org>
References: <20220527084819.133490171@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -1253,39 +1253,31 @@ static __poll_t random_poll(struct file
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
@@ -1317,9 +1309,8 @@ static ssize_t random_read_iter(struct k
 
 static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
-	int size, ent_count;
 	int __user *p = (int __user *)arg;
-	int retval;
+	int ent_count;
 
 	switch (cmd) {
 	case RNDGETENTCNT:
@@ -1336,20 +1327,32 @@ static long random_ioctl(struct file *f,
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
@@ -1375,7 +1378,7 @@ static int random_fasync(int fd, struct
 
 const struct file_operations random_fops = {
 	.read_iter = random_read_iter,
-	.write = random_write,
+	.write_iter = random_write_iter,
 	.poll = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
@@ -1385,7 +1388,7 @@ const struct file_operations random_fops
 
 const struct file_operations urandom_fops = {
 	.read_iter = urandom_read_iter,
-	.write = random_write,
+	.write_iter = random_write_iter,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,


