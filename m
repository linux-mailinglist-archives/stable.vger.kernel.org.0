Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA8F53611B
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351850AbiE0L70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352390AbiE0LzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:55:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B89215A749;
        Fri, 27 May 2022 04:48:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC33A61D56;
        Fri, 27 May 2022 11:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D77C385A9;
        Fri, 27 May 2022 11:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652100;
        bh=eTiNwnTuZEIS520BxGxeULXm+yAoNMpLHA1evdbh5pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2GyPh+91O2NRkEsG+ywY2F8tG3ECxlRPCszYY5n3csyaVBSNmOo2F6wbeH+m2kdHI
         jfQgckYkzaTIwnwRokeCxnDfAXLQJcIpnLEXYcaNKQgQco2kWzM0Y7ptTmZcyVSVIt
         o3fN22KWbWx/HXgNCCOYW+W+Iol4tOImAKnTdHGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Eric Biggers <ebiggers@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 088/163] random: group userspace read/write functions
Date:   Fri, 27 May 2022 10:49:28 +0200
Message-Id: <20220527084840.283045390@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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
@@ -1477,30 +1477,61 @@ static void try_to_generate_entropy(void
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
 
 static __poll_t random_poll(struct file *file, poll_table *wait)
@@ -1552,6 +1583,32 @@ static ssize_t random_write(struct file
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
@@ -1560,7 +1617,7 @@ static long random_ioctl(struct file *f,
 
 	switch (cmd) {
 	case RNDGETENTCNT:
-		/* inherently racy, no point locking */
+		/* Inherently racy, no point locking. */
 		if (put_user(input_pool.entropy_count, p))
 			return -EFAULT;
 		return 0;
@@ -1636,34 +1693,6 @@ const struct file_operations urandom_fop
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


