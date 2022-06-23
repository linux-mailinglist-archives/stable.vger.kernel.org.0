Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A09645582D9
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiFWRVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbiFWRTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:19:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953E39B757;
        Thu, 23 Jun 2022 10:00:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60B8DB8248F;
        Thu, 23 Jun 2022 17:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22B0C3411B;
        Thu, 23 Jun 2022 17:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003624;
        bh=1FS9A02nun7v+wqNAWaKHTegmlCKOT0f+AeAAiTpj6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWj5YOESTodxLA2Tu9qEMF5X8xqL2fyjYy1jhWQTM0I42BSKL9qc14IQazwS/ww6m
         CD/B6SoBmKaKatXacv4gUgBohzfdU1+dyA9tAFeIVaWbObrJiIkkO+8N+IkoAW6kP+
         tGEcubGLpbOkOLLmdJ9W5Nn684/Bp4nS1mdv9jig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 033/237] random: make /dev/random be almost like /dev/urandom
Date:   Thu, 23 Jun 2022 18:41:07 +0200
Message-Id: <20220623164344.109206239@linuxfoundation.org>
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

From: Andy Lutomirski <luto@kernel.org>

commit 30c08efec8884fb106b8e57094baa51bb4c44e32 upstream.

This patch changes the read semantics of /dev/random to be the same
as /dev/urandom except that reads will block until the CRNG is
ready.

None of the cleanups that this enables have been done yet.  As a
result, this gives a warning about an unused function.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Link: https://lore.kernel.org/r/5e6ac8831c6cf2e56a7a4b39616d1732b2bdd06c.1577088521.git.luto@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   54 ++++++++++++--------------------------------------
 1 file changed, 13 insertions(+), 41 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -354,7 +354,6 @@
 #define INPUT_POOL_WORDS	(1 << (INPUT_POOL_SHIFT-5))
 #define OUTPUT_POOL_SHIFT	10
 #define OUTPUT_POOL_WORDS	(1 << (OUTPUT_POOL_SHIFT-5))
-#define SEC_XFER_SIZE		512
 #define EXTRACT_SIZE		10
 
 
@@ -804,7 +803,6 @@ retry:
 		if (entropy_bits >= random_read_wakeup_bits &&
 		    wq_has_sleeper(&random_read_wait)) {
 			wake_up_interruptible(&random_read_wait);
-			kill_fasync(&fasync, SIGIO, POLL_IN);
 		}
 		/* If the input pool is getting full, and the blocking
 		 * pool has room, send some entropy to the blocking
@@ -1925,43 +1923,6 @@ void rand_initialize_disk(struct gendisk
 #endif
 
 static ssize_t
-_random_read(int nonblock, char __user *buf, size_t nbytes)
-{
-	ssize_t n;
-
-	if (nbytes == 0)
-		return 0;
-
-	nbytes = min_t(size_t, nbytes, SEC_XFER_SIZE);
-	while (1) {
-		n = extract_entropy_user(&blocking_pool, buf, nbytes);
-		if (n < 0)
-			return n;
-		trace_random_read(n*8, (nbytes-n)*8,
-				  ENTROPY_BITS(&blocking_pool),
-				  ENTROPY_BITS(&input_pool));
-		if (n > 0)
-			return n;
-
-		/* Pool is (near) empty.  Maybe wait and retry. */
-		if (nonblock)
-			return -EAGAIN;
-
-		wait_event_interruptible(random_read_wait,
-		    blocking_pool.initialized &&
-		    (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits));
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-	}
-}
-
-static ssize_t
-random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
-{
-	return _random_read(file->f_flags & O_NONBLOCK, buf, nbytes);
-}
-
-static ssize_t
 urandom_read_nowarn(struct file *file, char __user *buf, size_t nbytes,
 		    loff_t *ppos)
 {
@@ -1993,15 +1954,26 @@ urandom_read(struct file *file, char __u
 	return urandom_read_nowarn(file, buf, nbytes, ppos);
 }
 
+static ssize_t
+random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+{
+	int ret;
+
+	ret = wait_for_random_bytes();
+	if (ret != 0)
+		return ret;
+	return urandom_read_nowarn(file, buf, nbytes, ppos);
+}
+
 static unsigned int
 random_poll(struct file *file, poll_table * wait)
 {
 	unsigned int mask;
 
-	poll_wait(file, &random_read_wait, wait);
+	poll_wait(file, &crng_init_wait, wait);
 	poll_wait(file, &random_write_wait, wait);
 	mask = 0;
-	if (ENTROPY_BITS(&input_pool) >= random_read_wakeup_bits)
+	if (crng_ready())
 		mask |= POLLIN | POLLRDNORM;
 	if (ENTROPY_BITS(&input_pool) < random_write_wakeup_bits)
 		mask |= POLLOUT | POLLWRNORM;


