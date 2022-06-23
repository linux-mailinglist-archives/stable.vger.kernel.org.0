Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1195655808D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbiFWQw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbiFWQvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7074BDEA1;
        Thu, 23 Jun 2022 09:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3049DB82490;
        Thu, 23 Jun 2022 16:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A71BC3411B;
        Thu, 23 Jun 2022 16:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003020;
        bh=kZyoMU4jppWf6k0CDp8oO6xWa2z6Gkrskz7rWT8qWnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+GwwteXrigKjUAScu63/U/Bu1Cw10aNFVQbfmaBHUloYVqyd6BKfsQd1Oq+BtznU
         nSIExLDt8J4YyDMzSawB8B3f1xViHNjM1XpN2glg9WkIwd+cyFDOXpAbCtNt3qKor6
         CoamcjPdX3mzNt5S0ZaoQXti5jawSpn2Ph+kRcLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 103/264] random: prepend remaining pool constants with POOL_
Date:   Thu, 23 Jun 2022 18:41:36 +0200
Message-Id: <20220623164346.985153235@linuxfoundation.org>
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
@@ -363,11 +363,11 @@
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
@@ -427,7 +427,7 @@ enum poolinfo {
 	POOL_BYTES = POOL_WORDS * sizeof(u32),
 	POOL_BITS = POOL_BYTES * 8,
 	POOL_BITSHIFT = ilog2(POOL_WORDS) + 5,
-	POOL_FRACBITS = POOL_WORDS << (ENTROPY_SHIFT + 5),
+	POOL_FRACBITS = POOL_WORDS << (POOL_ENTROPY_SHIFT + 5),
 
 	/* x^128 + x^104 + x^76 + x^51 +x^25 + x + 1 */
 	POOL_TAP1 = 104,
@@ -651,7 +651,7 @@ static void process_random_ready_list(vo
 static void credit_entropy_bits(int nbits)
 {
 	int entropy_count, entropy_bits, orig;
-	int nfrac = nbits << ENTROPY_SHIFT;
+	int nfrac = nbits << POOL_ENTROPY_SHIFT;
 
 	if (!nbits)
 		return;
@@ -684,7 +684,7 @@ retry:
 		 * turns no matter how large nbits is.
 		 */
 		int pnfrac = nfrac;
-		const int s = POOL_BITSHIFT + ENTROPY_SHIFT + 2;
+		const int s = POOL_BITSHIFT + POOL_ENTROPY_SHIFT + 2;
 		/* The +2 corresponds to the /4 in the denominator */
 
 		do {
@@ -705,9 +705,9 @@ retry:
 	if (cmpxchg(&input_pool.entropy_count, orig, entropy_count) != orig)
 		goto retry;
 
-	trace_credit_entropy_bits(nbits, entropy_count >> ENTROPY_SHIFT, _RET_IP_);
+	trace_credit_entropy_bits(nbits, entropy_count >> POOL_ENTROPY_SHIFT, _RET_IP_);
 
-	entropy_bits = entropy_count >> ENTROPY_SHIFT;
+	entropy_bits = entropy_count >> POOL_ENTROPY_SHIFT;
 	if (crng_init < 2 && entropy_bits >= 128)
 		crng_reseed(&primary_crng, true);
 }
@@ -1238,7 +1238,7 @@ void add_input_randomness(unsigned int t
 	last_value = value;
 	add_timer_randomness(&input_timer_state,
 			     (type << 4) ^ code ^ (code >> 4) ^ value);
-	trace_add_input_randomness(ENTROPY_BITS());
+	trace_add_input_randomness(POOL_ENTROPY_BITS());
 }
 EXPORT_SYMBOL_GPL(add_input_randomness);
 
@@ -1337,7 +1337,7 @@ void add_disk_randomness(struct gendisk
 		return;
 	/* first major is 1, so we get >= 0x200 here */
 	add_timer_randomness(disk->random, 0x100 + disk_devt(disk));
-	trace_add_disk_randomness(disk_devt(disk), ENTROPY_BITS());
+	trace_add_disk_randomness(disk_devt(disk), POOL_ENTROPY_BITS());
 }
 EXPORT_SYMBOL_GPL(add_disk_randomness);
 #endif
@@ -1364,7 +1364,7 @@ retry:
 	entropy_count = orig = READ_ONCE(input_pool.entropy_count);
 	ibytes = nbytes;
 	/* never pull more than available */
-	have_bytes = entropy_count >> (ENTROPY_SHIFT + 3);
+	have_bytes = entropy_count >> (POOL_ENTROPY_SHIFT + 3);
 
 	if (have_bytes < 0)
 		have_bytes = 0;
@@ -1376,7 +1376,7 @@ retry:
 		pr_warn("negative entropy count: count %d\n", entropy_count);
 		entropy_count = 0;
 	}
-	nfrac = ibytes << (ENTROPY_SHIFT + 3);
+	nfrac = ibytes << (POOL_ENTROPY_SHIFT + 3);
 	if ((size_t) entropy_count > nfrac)
 		entropy_count -= nfrac;
 	else
@@ -1386,7 +1386,7 @@ retry:
 		goto retry;
 
 	trace_debit_entropy(8 * ibytes);
-	if (ibytes && ENTROPY_BITS() < random_write_wakeup_bits) {
+	if (ibytes && POOL_ENTROPY_BITS() < random_write_wakeup_bits) {
 		wake_up_interruptible(&random_write_wait);
 		kill_fasync(&fasync, SIGIO, POLL_OUT);
 	}
@@ -1474,7 +1474,7 @@ static ssize_t _extract_entropy(void *bu
  */
 static ssize_t extract_entropy(void *buf, size_t nbytes, int min)
 {
-	trace_extract_entropy(nbytes, ENTROPY_BITS(), _RET_IP_);
+	trace_extract_entropy(nbytes, POOL_ENTROPY_BITS(), _RET_IP_);
 	nbytes = account(nbytes, min);
 	return _extract_entropy(buf, nbytes);
 }
@@ -1799,9 +1799,9 @@ urandom_read_nowarn(struct file *file, c
 {
 	int ret;
 
-	nbytes = min_t(size_t, nbytes, INT_MAX >> (ENTROPY_SHIFT + 3));
+	nbytes = min_t(size_t, nbytes, INT_MAX >> (POOL_ENTROPY_SHIFT + 3));
 	ret = extract_crng_user(buf, nbytes);
-	trace_urandom_read(8 * nbytes, 0, ENTROPY_BITS());
+	trace_urandom_read(8 * nbytes, 0, POOL_ENTROPY_BITS());
 	return ret;
 }
 
@@ -1841,7 +1841,7 @@ random_poll(struct file *file, poll_tabl
 	mask = 0;
 	if (crng_ready())
 		mask |= POLLIN | POLLRDNORM;
-	if (ENTROPY_BITS() < random_write_wakeup_bits)
+	if (POOL_ENTROPY_BITS() < random_write_wakeup_bits)
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
 }
@@ -1897,7 +1897,7 @@ static long random_ioctl(struct file *f,
 	switch (cmd) {
 	case RNDGETENTCNT:
 		/* inherently racy, no point locking */
-		ent_count = ENTROPY_BITS();
+		ent_count = POOL_ENTROPY_BITS();
 		if (put_user(ent_count, p))
 			return -EFAULT;
 		return 0;
@@ -2053,7 +2053,7 @@ static int proc_do_entropy(struct ctl_ta
 	struct ctl_table fake_table;
 	int entropy_count;
 
-	entropy_count = *(int *)table->data >> ENTROPY_SHIFT;
+	entropy_count = *(int *)table->data >> POOL_ENTROPY_SHIFT;
 
 	fake_table.data = &entropy_count;
 	fake_table.maxlen = sizeof(entropy_count);
@@ -2272,7 +2272,7 @@ void add_hwgenerator_randomness(const ch
 	 */
 	wait_event_interruptible(random_write_wait,
 			!system_wq || kthread_should_stop() ||
-			ENTROPY_BITS() <= random_write_wakeup_bits);
+			POOL_ENTROPY_BITS() <= random_write_wakeup_bits);
 	mix_pool_bytes(buffer, count);
 	credit_entropy_bits(entropy);
 }


