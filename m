Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFCB558671
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236352AbiFWSN1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiFWSMU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:12:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBABDBEAA2;
        Thu, 23 Jun 2022 10:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 603DEB82480;
        Thu, 23 Jun 2022 17:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2DBC3411B;
        Thu, 23 Jun 2022 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004837;
        bh=PHqgsiCBFiSCo6xy0pye59C3TYC/dAmQBjvcwFWr20c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlf6/y9psHifPdox5ODhEIomTXhfpJlDY1Lcg8ld0mmwW4JoQ8N1+MqhKqpeX/Ed8
         +76EV49ybHGDZoxLmRxb7y2M3gny9lMT5qatNMTpF466A6vbDo9VbxOKoqkPJ4E1QW
         ILxO4nNFaayXH0p7Mp1sxKMMsvoI39OV67K6nDqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 164/234] random: use proper return types on get_random_{int,long}_wait()
Date:   Thu, 23 Jun 2022 18:43:51 +0200
Message-Id: <20220623164347.695256092@linuxfoundation.org>
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

commit 7c3a8a1db5e03d02cc0abb3357a84b8b326dfac3 upstream.

Before these were returning signed values, but the API is intended to be
used with unsigned values.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c  |  195 +++++++++++++++++++++++--------------------------
 include/linux/random.h |   24 +++---
 2 files changed, 107 insertions(+), 112 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -210,7 +210,7 @@ static void _warn_unseeded_randomness(co
  *
  * There are a few exported interfaces for use by other drivers:
  *
- *	void get_random_bytes(void *buf, size_t nbytes)
+ *	void get_random_bytes(void *buf, size_t len)
  *	u32 get_random_u32()
  *	u64 get_random_u64()
  *	unsigned int get_random_int()
@@ -249,7 +249,7 @@ static DEFINE_PER_CPU(struct crng, crngs
 };
 
 /* Used by crng_reseed() and crng_make_state() to extract a new seed from the input pool. */
-static void extract_entropy(void *buf, size_t nbytes);
+static void extract_entropy(void *buf, size_t len);
 
 /* This extracts a new crng key from the input pool. */
 static void crng_reseed(void)
@@ -403,24 +403,24 @@ static void crng_make_state(u32 chacha_s
 	local_irq_restore(flags);
 }
 
-static void _get_random_bytes(void *buf, size_t nbytes)
+static void _get_random_bytes(void *buf, size_t len)
 {
 	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
 	u8 tmp[CHACHA20_BLOCK_SIZE];
-	size_t len;
+	size_t first_block_len;
 
-	if (!nbytes)
+	if (!len)
 		return;
 
-	len = min_t(size_t, 32, nbytes);
-	crng_make_state(chacha_state, buf, len);
-	nbytes -= len;
-	buf += len;
+	first_block_len = min_t(size_t, 32, len);
+	crng_make_state(chacha_state, buf, first_block_len);
+	len -= first_block_len;
+	buf += first_block_len;
 
-	while (nbytes) {
-		if (nbytes < CHACHA20_BLOCK_SIZE) {
+	while (len) {
+		if (len < CHACHA20_BLOCK_SIZE) {
 			chacha20_block(chacha_state, tmp);
-			memcpy(buf, tmp, nbytes);
+			memcpy(buf, tmp, len);
 			memzero_explicit(tmp, sizeof(tmp));
 			break;
 		}
@@ -428,7 +428,7 @@ static void _get_random_bytes(void *buf,
 		chacha20_block(chacha_state, buf);
 		if (unlikely(chacha_state[12] == 0))
 			++chacha_state[13];
-		nbytes -= CHACHA20_BLOCK_SIZE;
+		len -= CHACHA20_BLOCK_SIZE;
 		buf += CHACHA20_BLOCK_SIZE;
 	}
 
@@ -445,20 +445,20 @@ static void _get_random_bytes(void *buf,
  * wait_for_random_bytes() should be called and return 0 at least once
  * at any point prior.
  */
-void get_random_bytes(void *buf, size_t nbytes)
+void get_random_bytes(void *buf, size_t len)
 {
 	warn_unseeded_randomness();
-	_get_random_bytes(buf, nbytes);
+	_get_random_bytes(buf, len);
 }
 EXPORT_SYMBOL(get_random_bytes);
 
-static ssize_t get_random_bytes_user(void __user *buf, size_t nbytes)
+static ssize_t get_random_bytes_user(void __user *ubuf, size_t len)
 {
-	size_t len, left, ret = 0;
+	size_t block_len, left, ret = 0;
 	u32 chacha_state[CHACHA20_BLOCK_SIZE / sizeof(u32)];
 	u8 output[CHACHA20_BLOCK_SIZE];
 
-	if (!nbytes)
+	if (!len)
 		return 0;
 
 	/*
@@ -472,8 +472,8 @@ static ssize_t get_random_bytes_user(voi
 	 * use chacha_state after, so we can simply return those bytes to
 	 * the user directly.
 	 */
-	if (nbytes <= CHACHA20_KEY_SIZE) {
-		ret = nbytes - copy_to_user(buf, &chacha_state[4], nbytes);
+	if (len <= CHACHA20_KEY_SIZE) {
+		ret = len - copy_to_user(ubuf, &chacha_state[4], len);
 		goto out_zero_chacha;
 	}
 
@@ -482,17 +482,17 @@ static ssize_t get_random_bytes_user(voi
 		if (unlikely(chacha_state[12] == 0))
 			++chacha_state[13];
 
-		len = min_t(size_t, nbytes, CHACHA20_BLOCK_SIZE);
-		left = copy_to_user(buf, output, len);
+		block_len = min_t(size_t, len, CHACHA20_BLOCK_SIZE);
+		left = copy_to_user(ubuf, output, block_len);
 		if (left) {
-			ret += len - left;
+			ret += block_len - left;
 			break;
 		}
 
-		buf += len;
-		ret += len;
-		nbytes -= len;
-		if (!nbytes)
+		ubuf += block_len;
+		ret += block_len;
+		len -= block_len;
+		if (!len)
 			break;
 
 		BUILD_BUG_ON(PAGE_SIZE % CHACHA20_BLOCK_SIZE != 0);
@@ -663,24 +663,24 @@ unsigned long randomize_page(unsigned lo
  * use. Use get_random_bytes() instead. It returns the number of
  * bytes filled in.
  */
-size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes)
+size_t __must_check get_random_bytes_arch(void *buf, size_t len)
 {
-	size_t left = nbytes;
+	size_t left = len;
 	u8 *p = buf;
 
 	while (left) {
 		unsigned long v;
-		size_t chunk = min_t(size_t, left, sizeof(unsigned long));
+		size_t block_len = min_t(size_t, left, sizeof(unsigned long));
 
 		if (!arch_get_random_long(&v))
 			break;
 
-		memcpy(p, &v, chunk);
-		p += chunk;
-		left -= chunk;
+		memcpy(p, &v, block_len);
+		p += block_len;
+		left -= block_len;
 	}
 
-	return nbytes - left;
+	return len - left;
 }
 EXPORT_SYMBOL(get_random_bytes_arch);
 
@@ -691,15 +691,15 @@ EXPORT_SYMBOL(get_random_bytes_arch);
  *
  * Callers may add entropy via:
  *
- *     static void mix_pool_bytes(const void *in, size_t nbytes)
+ *     static void mix_pool_bytes(const void *buf, size_t len)
  *
  * After which, if added entropy should be credited:
  *
- *     static void credit_init_bits(size_t nbits)
+ *     static void credit_init_bits(size_t bits)
  *
  * Finally, extract entropy via:
  *
- *     static void extract_entropy(void *buf, size_t nbytes)
+ *     static void extract_entropy(void *buf, size_t len)
  *
  **********************************************************************/
 
@@ -721,9 +721,9 @@ static struct {
 	.lock = __SPIN_LOCK_UNLOCKED(input_pool.lock),
 };
 
-static void _mix_pool_bytes(const void *in, size_t nbytes)
+static void _mix_pool_bytes(const void *buf, size_t len)
 {
-	blake2s_update(&input_pool.hash, in, nbytes);
+	blake2s_update(&input_pool.hash, buf, len);
 }
 
 /*
@@ -731,12 +731,12 @@ static void _mix_pool_bytes(const void *
  * update the initialization bit counter; the caller should call
  * credit_init_bits if this is appropriate.
  */
-static void mix_pool_bytes(const void *in, size_t nbytes)
+static void mix_pool_bytes(const void *buf, size_t len)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&input_pool.lock, flags);
-	_mix_pool_bytes(in, nbytes);
+	_mix_pool_bytes(buf, len);
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
 
@@ -744,7 +744,7 @@ static void mix_pool_bytes(const void *i
  * This is an HKDF-like construction for using the hashed collected entropy
  * as a PRF key, that's then expanded block-by-block.
  */
-static void extract_entropy(void *buf, size_t nbytes)
+static void extract_entropy(void *buf, size_t len)
 {
 	unsigned long flags;
 	u8 seed[BLAKE2S_HASH_SIZE], next_key[BLAKE2S_HASH_SIZE];
@@ -773,12 +773,12 @@ static void extract_entropy(void *buf, s
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 	memzero_explicit(next_key, sizeof(next_key));
 
-	while (nbytes) {
-		i = min_t(size_t, nbytes, BLAKE2S_HASH_SIZE);
+	while (len) {
+		i = min_t(size_t, len, BLAKE2S_HASH_SIZE);
 		/* output = HASHPRF(seed, RDSEED || ++counter) */
 		++block.counter;
 		blake2s(buf, (u8 *)&block, seed, i, sizeof(block), sizeof(seed));
-		nbytes -= i;
+		len -= i;
 		buf += i;
 	}
 
@@ -786,16 +786,16 @@ static void extract_entropy(void *buf, s
 	memzero_explicit(&block, sizeof(block));
 }
 
-static void credit_init_bits(size_t nbits)
+static void credit_init_bits(size_t bits)
 {
 	static struct execute_work set_ready;
 	unsigned int new, orig, add;
 	unsigned long flags;
 
-	if (crng_ready() || !nbits)
+	if (crng_ready() || !bits)
 		return;
 
-	add = min_t(size_t, nbits, POOL_BITS);
+	add = min_t(size_t, bits, POOL_BITS);
 
 	do {
 		orig = READ_ONCE(input_pool.init_bits);
@@ -831,13 +831,11 @@ static void credit_init_bits(size_t nbit
  * The following exported functions are used for pushing entropy into
  * the above entropy accumulation routines:
  *
- *	void add_device_randomness(const void *buf, size_t size);
- *	void add_hwgenerator_randomness(const void *buffer, size_t count,
- *					size_t entropy);
- *	void add_bootloader_randomness(const void *buf, size_t size);
+ *	void add_device_randomness(const void *buf, size_t len);
+ *	void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
+ *	void add_bootloader_randomness(const void *buf, size_t len);
  *	void add_interrupt_randomness(int irq);
- *	void add_input_randomness(unsigned int type, unsigned int code,
- *	                          unsigned int value);
+ *	void add_input_randomness(unsigned int type, unsigned int code, unsigned int value);
  *	void add_disk_randomness(struct gendisk *disk);
  *
  * add_device_randomness() adds data to the input pool that
@@ -901,7 +899,7 @@ int __init random_init(const char *comma
 {
 	ktime_t now = ktime_get_real();
 	unsigned int i, arch_bytes;
-	unsigned long rv;
+	unsigned long entropy;
 
 #if defined(LATENT_ENTROPY_PLUGIN)
 	static const u8 compiletime_seed[BLAKE2S_BLOCK_SIZE] __initconst __latent_entropy;
@@ -909,13 +907,13 @@ int __init random_init(const char *comma
 #endif
 
 	for (i = 0, arch_bytes = BLAKE2S_BLOCK_SIZE;
-	     i < BLAKE2S_BLOCK_SIZE; i += sizeof(rv)) {
-		if (!arch_get_random_seed_long_early(&rv) &&
-		    !arch_get_random_long_early(&rv)) {
-			rv = random_get_entropy();
-			arch_bytes -= sizeof(rv);
+	     i < BLAKE2S_BLOCK_SIZE; i += sizeof(entropy)) {
+		if (!arch_get_random_seed_long_early(&entropy) &&
+		    !arch_get_random_long_early(&entropy)) {
+			entropy = random_get_entropy();
+			arch_bytes -= sizeof(entropy);
 		}
-		_mix_pool_bytes(&rv, sizeof(rv));
+		_mix_pool_bytes(&entropy, sizeof(entropy));
 	}
 	_mix_pool_bytes(&now, sizeof(now));
 	_mix_pool_bytes(utsname(), sizeof(*(utsname())));
@@ -938,14 +936,14 @@ int __init random_init(const char *comma
  * the entropy pool having similar initial state across largely
  * identical devices.
  */
-void add_device_randomness(const void *buf, size_t size)
+void add_device_randomness(const void *buf, size_t len)
 {
 	unsigned long entropy = random_get_entropy();
 	unsigned long flags;
 
 	spin_lock_irqsave(&input_pool.lock, flags);
 	_mix_pool_bytes(&entropy, sizeof(entropy));
-	_mix_pool_bytes(buf, size);
+	_mix_pool_bytes(buf, len);
 	spin_unlock_irqrestore(&input_pool.lock, flags);
 }
 EXPORT_SYMBOL(add_device_randomness);
@@ -955,10 +953,9 @@ EXPORT_SYMBOL(add_device_randomness);
  * Those devices may produce endless random bits and will be throttled
  * when our pool is full.
  */
-void add_hwgenerator_randomness(const void *buffer, size_t count,
-				size_t entropy)
+void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy)
 {
-	mix_pool_bytes(buffer, count);
+	mix_pool_bytes(buf, len);
 	credit_init_bits(entropy);
 
 	/*
@@ -974,11 +971,11 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_random
  * Handle random seed passed by bootloader, and credit it if
  * CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  */
-void add_bootloader_randomness(const void *buf, size_t size)
+void add_bootloader_randomness(const void *buf, size_t len)
 {
-	mix_pool_bytes(buf, size);
+	mix_pool_bytes(buf, len);
 	if (trust_bootloader)
-		credit_init_bits(size * 8);
+		credit_init_bits(len * 8);
 }
 EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
@@ -1178,8 +1175,7 @@ static void add_timer_randomness(struct
 		credit_init_bits(bits);
 }
 
-void add_input_randomness(unsigned int type, unsigned int code,
-			  unsigned int value)
+void add_input_randomness(unsigned int type, unsigned int code, unsigned int value)
 {
 	static unsigned char last_value;
 	static struct timer_rand_state input_timer_state = { INITIAL_JIFFIES };
@@ -1298,8 +1294,7 @@ static void try_to_generate_entropy(void
  *
  **********************************************************************/
 
-SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count, unsigned int,
-		flags)
+SYSCALL_DEFINE3(getrandom, char __user *, ubuf, size_t, len, unsigned int, flags)
 {
 	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
 		return -EINVAL;
@@ -1311,8 +1306,8 @@ SYSCALL_DEFINE3(getrandom, char __user *
 	if ((flags & (GRND_INSECURE | GRND_RANDOM)) == (GRND_INSECURE | GRND_RANDOM))
 		return -EINVAL;
 
-	if (count > INT_MAX)
-		count = INT_MAX;
+	if (len > INT_MAX)
+		len = INT_MAX;
 
 	if (!crng_ready() && !(flags & GRND_INSECURE)) {
 		int ret;
@@ -1323,7 +1318,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 		if (unlikely(ret))
 			return ret;
 	}
-	return get_random_bytes_user(buf, count);
+	return get_random_bytes_user(ubuf, len);
 }
 
 static __poll_t random_poll(struct file *file, poll_table *wait)
@@ -1332,21 +1327,21 @@ static __poll_t random_poll(struct file
 	return crng_ready() ? EPOLLIN | EPOLLRDNORM : EPOLLOUT | EPOLLWRNORM;
 }
 
-static int write_pool(const char __user *ubuf, size_t count)
+static int write_pool(const char __user *ubuf, size_t len)
 {
-	size_t len;
+	size_t block_len;
 	int ret = 0;
 	u8 block[BLAKE2S_BLOCK_SIZE];
 
-	while (count) {
-		len = min(count, sizeof(block));
-		if (copy_from_user(block, ubuf, len)) {
+	while (len) {
+		block_len = min(len, sizeof(block));
+		if (copy_from_user(block, ubuf, block_len)) {
 			ret = -EFAULT;
 			goto out;
 		}
-		count -= len;
-		ubuf += len;
-		mix_pool_bytes(block, len);
+		len -= block_len;
+		ubuf += block_len;
+		mix_pool_bytes(block, block_len);
 		cond_resched();
 	}
 
@@ -1355,20 +1350,20 @@ out:
 	return ret;
 }
 
-static ssize_t random_write(struct file *file, const char __user *buffer,
-			    size_t count, loff_t *ppos)
+static ssize_t random_write(struct file *file, const char __user *ubuf,
+			    size_t len, loff_t *ppos)
 {
 	int ret;
 
-	ret = write_pool(buffer, count);
+	ret = write_pool(ubuf, len);
 	if (ret)
 		return ret;
 
-	return (ssize_t)count;
+	return (ssize_t)len;
 }
 
-static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
-			    loff_t *ppos)
+static ssize_t urandom_read(struct file *file, char __user *ubuf,
+			    size_t len, loff_t *ppos)
 {
 	static int maxwarn = 10;
 
@@ -1378,22 +1373,22 @@ static ssize_t urandom_read(struct file
 		else if (ratelimit_disable || __ratelimit(&urandom_warning)) {
 			--maxwarn;
 			pr_notice("%s: uninitialized urandom read (%zd bytes read)\n",
-				  current->comm, nbytes);
+				  current->comm, len);
 		}
 	}
 
-	return get_random_bytes_user(buf, nbytes);
+	return get_random_bytes_user(ubuf, len);
 }
 
-static ssize_t random_read(struct file *file, char __user *buf, size_t nbytes,
-			   loff_t *ppos)
+static ssize_t random_read(struct file *file, char __user *ubuf,
+			   size_t len, loff_t *ppos)
 {
 	int ret;
 
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;
-	return get_random_bytes_user(buf, nbytes);
+	return get_random_bytes_user(ubuf, len);
 }
 
 static long random_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
@@ -1516,8 +1511,8 @@ static u8 sysctl_bootid[UUID_SIZE];
  * UUID. The difference is in whether table->data is NULL; if it is,
  * then a new UUID is generated and returned to the user.
  */
-static int proc_do_uuid(struct ctl_table *table, int write,
-			void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_do_uuid(struct ctl_table *table, int write, void __user *buf,
+			size_t *lenp, loff_t *ppos)
 {
 	u8 tmp_uuid[UUID_SIZE], *uuid;
 	char uuid_string[UUID_STRING_LEN + 1];
@@ -1543,14 +1538,14 @@ static int proc_do_uuid(struct ctl_table
 	}
 
 	snprintf(uuid_string, sizeof(uuid_string), "%pU", uuid);
-	return proc_dostring(&fake_table, 0, buffer, lenp, ppos);
+	return proc_dostring(&fake_table, 0, buf, lenp, ppos);
 }
 
 /* The same as proc_dointvec, but writes don't change anything. */
-static int proc_do_rointvec(struct ctl_table *table, int write, void __user *buffer,
+static int proc_do_rointvec(struct ctl_table *table, int write, void __user *buf,
 			    size_t *lenp, loff_t *ppos)
 {
-	return write ? 0 : proc_dointvec(table, 0, buffer, lenp, ppos);
+	return write ? 0 : proc_dointvec(table, 0, buf, lenp, ppos);
 }
 
 extern struct ctl_table random_table[];
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -12,12 +12,12 @@
 
 struct notifier_block;
 
-void add_device_randomness(const void *, size_t);
-void add_bootloader_randomness(const void *, size_t);
+void add_device_randomness(const void *buf, size_t len);
+void add_bootloader_randomness(const void *buf, size_t len);
 void add_input_randomness(unsigned int type, unsigned int code,
 			  unsigned int value) __latent_entropy;
 void add_interrupt_randomness(int irq) __latent_entropy;
-void add_hwgenerator_randomness(const void *buffer, size_t count, size_t entropy);
+void add_hwgenerator_randomness(const void *buf, size_t len, size_t entropy);
 
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 static inline void add_latent_entropy(void)
@@ -28,8 +28,8 @@ static inline void add_latent_entropy(vo
 static inline void add_latent_entropy(void) { }
 #endif
 
-void get_random_bytes(void *buf, size_t nbytes);
-size_t __must_check get_random_bytes_arch(void *buf, size_t nbytes);
+void get_random_bytes(void *buf, size_t len);
+size_t __must_check get_random_bytes_arch(void *buf, size_t len);
 u32 get_random_u32(void);
 u64 get_random_u64(void);
 static inline unsigned int get_random_int(void)
@@ -81,18 +81,18 @@ static inline int get_random_bytes_wait(
 	return ret;
 }
 
-#define declare_get_random_var_wait(var) \
-	static inline int get_random_ ## var ## _wait(var *out) { \
+#define declare_get_random_var_wait(name, ret_type) \
+	static inline int get_random_ ## name ## _wait(ret_type *out) { \
 		int ret = wait_for_random_bytes(); \
 		if (unlikely(ret)) \
 			return ret; \
-		*out = get_random_ ## var(); \
+		*out = get_random_ ## name(); \
 		return 0; \
 	}
-declare_get_random_var_wait(u32)
-declare_get_random_var_wait(u64)
-declare_get_random_var_wait(int)
-declare_get_random_var_wait(long)
+declare_get_random_var_wait(u32, u32)
+declare_get_random_var_wait(u64, u32)
+declare_get_random_var_wait(int, unsigned int)
+declare_get_random_var_wait(long, unsigned long)
 #undef declare_get_random_var
 
 /*


