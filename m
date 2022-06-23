Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B772558590
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbiFWR7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235782AbiFWR5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:57:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E75AE9A9;
        Thu, 23 Jun 2022 10:15:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E5B561DEF;
        Thu, 23 Jun 2022 17:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1036AC3411B;
        Thu, 23 Jun 2022 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004538;
        bh=Yj0OMr2zRS3PhpRxi2VpRMDqtk84MGxs5y/lX/o30X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUWTUApmyu1SpZ1PXSiryWwnB/t3qkGnyhmL1Tb7tSpk/wvDtyAZH2TUCaD2ujb/I
         /H4GmmDau4gG/e31plqBrdGgX61pn435Uu4ToQkyoJoDmA0YRtdG98JR4ufCiyJ5Xc
         2n2L2bTp/lJb6ZTL901COckbe0bk+l3NykUs+Ojo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 068/234] random: prepend remaining pool constants with POOL_
Date:   Thu, 23 Jun 2022 18:42:15 +0200
Message-Id: <20220623164344.985897956@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
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

commit b3d51c1f542113342ddfbf6007e38a684b9dbec9 upstream.

The other pool constants are prepended with POOL_, but not these last
ones. Rename them. This will then let us move them into the enum in the
following commit.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -362,11 +362,11 @@
  * To allow fractional bits to be tracked, the entropy_count field is
  * denominated in units of 1/8th bits.
  *
- * 2*(ENTROPY_SHIFT + poolbitshift) must <= 31, or the multiply in
+ * 2*(POOL_ENTROPY_SHIFT + poolbitshift) must <= 31, or the multiply in
  * credit_entropy_bits() needs to be 64 bits wide.
  */
-#define ENTROPY_SHIFT 3
-#define ENTROPY_BITS() (input_pool.entropy_count >> ENTROPY_SHIFT)
+#define POOL_ENTROPY_SHIFT 3
+#define POOL_ENTROPY_BITS() (input_pool.entropy_count >> POOL_ENTROPY_SHIFT)
 
 /*
  * If the entropy count falls under this number of bits, then we
@@ -426,7 +426,7 @@ enum poolinfo {
 	POOL_BYTES = POOL_WORDS * sizeof(u32),
 	POOL_BITS = POOL_BYTES * 8,
 	POOL_BITSHIFT = ilog2(POOL_WORDS) + 5,
-	POOL_FRACBITS = POOL_WORDS << (ENTROPY_SHIFT + 5),
+	POOL_FRACBITS = POOL_WORDS << (POOL_ENTROPY_SHIFT + 5),
 
 	/* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
 	POOL_TAP1 = 104,
@@ -650,7 +650,7 @@ static void process_random_ready_list(vo
 static void credit_entropy_bits(int nbits)
 {
 	int entropy_count, entropy_bits, orig;
-	int nfrac = nbits << ENTROPY_SHIFT;
+	int nfrac = nbits << POOL_ENTROPY_SHIFT;
 
 	if (!nbits)
 		return;
@@ -683,7 +683,7 @@ retry:
 		 * turns no matter how large nbits is.
 		 */
 		int pnfrac = nfrac;
-		const int s = POOL_BITSHIFT + ENTROPY_SHIFT + 2;
+		const int s = POOL_BITSHIFT + POOL_ENTROPY_SHIFT + 2;
 		/* The +2 corresponds to the /4 in the denominator */
 
 		do {
@@ -704,9 +704,9 @@ retry:
 	if (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	trace_credit_entropy_bits(nbits, entropy_count >> ENTROPY_SHIFT, _RET_IP_);
+	trace_credit_entropy_bits(nbits, entropy_count >> POOL_ENTROPY_SHIFT, _RET_IP_);
 
-	entropy_bits = entropy_count >> ENTROPY_SHIFT;
+	entropy_bits = entropy_count >> POOL_ENTROPY_SHIFT;
 	if (crng_init < 2 && entropy_bits >= 128)
 		crng_reseed(&primary_crng, true);
 }
@@ -1187,7 +1187,7 @@ void add_input_randomness(unsigned int t
 	last_value = value;
 	add_timer_randomness(&input_timer_state,
 			     (type << 4) ^ code ^ (code >> 4) ^ value);
-	trace_add_input_randomness(ENTROPY_BITS());
+	trace_add_input_randomness(POOL_ENTROPY_BITS());
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
@@ -1286,7 +1286,7 @@ void add_disk_randomness(struct gendisk
 		return;
 	/* first major is 1, so we get >= 0x200 here */
 	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
-	trace_add_disk_randomness(disk_devt(disk), ENTROPY_BITS());
+	trace_add_disk_randomness(disk_devt(disk), POOL_ENTROPY_BITS());
 }
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
@@ -1313,7 +1313,7 @@ retry:
 	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
 	ibytes = nbytes;
 	/* never pull more than available */
-	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
+	have_bytes = entropy_count >> (POOL_ENTROPY_SHIFT + 3);
 
 	if (have_bytes < 0)
 		have_bytes = 0;
@@ -1325,7 +1325,7 @@ retry:
 		pr_warn("negative entropy count: count %d\n", entropy_count);
 		entropy_count = 0;
 	}
-	nfrac = ibytes << (ENTROPY_SHIFT + 3);
+	nfrac = ibytes << (POOL_ENTROPY_SHIFT + 3);
 	if ((size_t) entropy_count > nfrac)
 		entropy_count -= nfrac;
 	else
@@ -1335,7 +1335,7 @@ retry:
 		goto retry;
 
 	trace_debit_entropy(8 * ibytes);
-	if (ibytes && ENTROPY_BITS() < random_write_wakeup_bits) {
+	if (ibytes && POOL_ENTROPY_BITS() < random_write_wakeup_bits) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	}
@@ -1423,7 +1423,7 @@ static ssize_t _extract_entropy(void *bu
  */
 static ssize_t extract_entropy(void *buf, size_t nbytes, int min)
 {
-	trace_extract_entropy(nbytes, ENTROPY_BITS(), _RET_IP_);
+	trace_extract_entropy(nbytes, POOL_ENTROPY_BITS(), _RET_IP_);
 	nbytes = account(nbytes, min);
 	return _extract_entropy(buf, nbytes);
 }
@@ -1749,9 +1749,9 @@ urandom_read_nowarn(struct file *file, c
 {
 	int ret;
 
-	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
+	nbytes = min_t(size_t, nbytes, INT_MAX >> (POOL_ENTROPY_SHIFT + 3));
 	ret = extract_crng_user(buf, nbytes);
-	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS());
+	trace_urandom_read(8 * nbytes, 0, POOL_ENTROPY_BITS());
 	return ret;
 }
 
@@ -1791,7 +1791,7 @@ random_poll(struct file *file, poll_tabl
 	mask = 0;
 	if (crng_ready())
 		mask |= EPOLLIN | EPOLLRDNORM;
-	if (ENTROPY_BITS() < random_write_wakeup_bits)
+	if (POOL_ENTROPY_BITS() < random_write_wakeup_bits)
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	return mask;
 }
@@ -1847,7 +1847,7 @@ static long random_ioctl(struct file *f,
 	switch (cmd) {
 	case RNDGETENTCNT:
 		/* inherently racy, no point locking */
-		ent_count = ENTROPY_BITS();
+		ent_count = POOL_ENTROPY_BITS();
 		if (put_user(ent_count, p))
 			return -EFAULT;
 		return 0;
@@ -2003,7 +2003,7 @@ static int proc_do_entropy(struct ctl_ta
 	struct ctl_table fake_table;
 	int entropy_count;
 
-	entropy_count = *(int *)table->data >> ENTROPY_SHIFT;
+	entropy_count = *(int *)table->data >> POOL_ENTROPY_SHIFT;
 
 	fake_table.data = &entropy_count;
 	fake_table.maxlen = sizeof(entropy_count);
@@ -2222,7 +2222,7 @@ void add_hwgenerator_randomness(const ch
 	 */
 	wait_event_interruptible(random_write_wait,
 			!system_wq || kthread_should_stop() ||
-			ENTROPY_BITS() <= random_write_wakeup_bits);
+			POOL_ENTROPY_BITS() <= random_write_wakeup_bits);
 	mix_pool_bytes(buffer, count);
 	credit_entropy_bits(entropy);
 }


