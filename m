Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34C8055823C
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbiFWRNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiFWRLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:11:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7C3AA;
        Thu, 23 Jun 2022 09:52:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E69FACE25CA;
        Thu, 23 Jun 2022 16:52:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E906FC3411B;
        Thu, 23 Jun 2022 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003119;
        bh=DO9dSnX7dg4/mK5cVIilBL3ZtVTc/gBfO9FsoAXqAfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f2FPftvWKeiFmVCEnMIOqNiXwXM8dbugs6AL08UZpJZEtccA+sF67oNFFoqF7QHdE
         K8qmsmu3C5kLXiEkdcPs7Iy5zSpHOF8RORt34KENncedPuSmQQKNbSzVm0QNbqfnbr
         uP1Su3f4LsFubxtSoIJvpQntE9KHj1QLkVGT6jkI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 137/264] random: group userspace read/write functions
Date:   Thu, 23 Jun 2022 18:42:10 +0200
Message-Id: <20220623164347.942293036@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

commit a6adf8e7a605250b911e94793fd077933709ff9e upstream.

This pulls all of the userspace read/write-focused functions into the
fifth labeled section.

No functional changes.

Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  125 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 77 insertions(+), 48 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1473,30 +1473,61 @@ static void try_to_generate_entropy(void
 	mix_pool_bytes(&stack.now, sizeof(stack.now));
 }
 
-static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
-			    loff_t *ppos)
+
+/**********************************************************************
+ *
+ * Userspace reader/writer interfaces.
+ *
+ * getrandom(2) is the primary modern interface into the RNG and should
+ * be used in preference to anything else.
+ *
+ * Reading from /dev/random has the same functionality as calling
+ * getrandom(2) with flags=0. In earlier versions, however, it had
+ * vastly different semantics and should therefore be avoided, to
+ * prevent backwards compatibility issues.
+ *
+ * Reading from /dev/urandom has the same functionality as calling
+ * getrandom(2) with flags=GRND_INSECURE. Because it does not block
+ * waiting for the RNG to be ready, it should not be used.
+ *
+ * Writing to either /dev/random or /dev/urandom adds entropy to
+ * the input pool but does not credit it.
+ *
+ * Polling on /dev/random indicates when the RNG is initialized, on
+ * the read side, and when it wants new entropy, on the write side.
+ *
+ * Both /dev/random and /dev/urandom have the same set of ioctls for
+ * adding entropy, getting the entropy count, zeroing the count, and
+ * reseeding the crng.
+ *
+ **********************************************************************/
+
+SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count, unsigned int,
+		flags)
 {
-	static int maxwarn = 10;
+	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
+		return -EINVAL;
 
-	if (!crng_ready() && maxwarn > 0) {
-		maxwarn--;
-		if (__ratelimit(&urandom_warning))
-			pr_notice("%s: uninitialized urandom read (%zd bytes read)\n",
-				  current->comm, nbytes);
-	}
+	/*
+	 * Requesting insecure and blocking randomness at the same time makes
+	 * no sense.
+	 */
+	if ((flags & (GRND_INSECURE | GRND_RANDOM)) == (GRND_INSECURE | GRND_RANDOM))
+		return -EINVAL;
 
-	return get_random_bytes_user(buf, nbytes);
-}
+	if (count > INT_MAX)
+		count = INT_MAX;
 
-static ssize_t random_read(struct file *file, char __user *buf, size_t nbytes,
-			   loff_t *ppos)
-{
-	int ret;
+	if (!(flags & GRND_INSECURE) && !crng_ready()) {
+		int ret;
 
-	ret = wait_for_random_bytes();
-	if (ret != 0)
-		return ret;
-	return get_random_bytes_user(buf, nbytes);
+		if (flags & GRND_NONBLOCK)
+			return -EAGAIN;
+		ret = wait_for_random_bytes();
+		if (unlikely(ret))
+			return ret;
+	}
+	return get_random_bytes_user(buf, count);
 }
 
 static unsigned int random_poll(struct file *file, poll_table *wait)
@@ -1548,6 +1579,32 @@ static ssize_t random_write(struct file
 	return (ssize_t)count;
 }
 
+static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
+			    loff_t *ppos)
+{
+	static int maxwarn = 10;
+
+	if (!crng_ready() && maxwarn > 0) {
+		maxwarn--;
+		if (__ratelimit(&urandom_warning))
+			pr_notice("%s: uninitialized urandom read (%zd bytes read)\n",
+				  current->comm, nbytes);
+	}
+
+	return get_random_bytes_user(buf, nbytes);
+}
+
+static ssize_t random_read(struct file *file, char __user *buf, size_t nbytes,
+			   loff_t *ppos)
+{
+	int ret;
+
+	ret = wait_for_random_bytes();
+	if (ret != 0)
+		return ret;
+	return get_random_bytes_user(buf, nbytes);
+}
+
 static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	int size, ent_count;
@@ -1556,7 +1613,7 @@ static long random_ioctl(struct file *f,
 
 	switch (cmd) {
 	case RNDGETENTCNT:
-		/* inherently racy, no point locking */
+		/* Inherently racy, no point locking. */
 		if (put_user(input_pool.entropy_count, p))
 			return -EFAULT;
 		return 0;
@@ -1630,34 +1687,6 @@ const struct file_operations urandom_fop
 	.llseek = noop_llseek,
 };
 
-SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count, unsigned int,
-		flags)
-{
-	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
-		return -EINVAL;
-
-	/*
-	 * Requesting insecure and blocking randomness at the same time makes
-	 * no sense.
-	 */
-	if ((flags & (GRND_INSECURE | GRND_RANDOM)) == (GRND_INSECURE | GRND_RANDOM))
-		return -EINVAL;
-
-	if (count > INT_MAX)
-		count = INT_MAX;
-
-	if (!(flags & GRND_INSECURE) && !crng_ready()) {
-		int ret;
-
-		if (flags & GRND_NONBLOCK)
-			return -EAGAIN;
-		ret = wait_for_random_bytes();
-		if (unlikely(ret))
-			return ret;
-	}
-	return get_random_bytes_user(buf, count);
-}
-
 /********************************************************************
  *
  * Sysctl interface


