Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA83253600B
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351830AbiE0Lq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352086AbiE0LpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:45:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D202714085F;
        Fri, 27 May 2022 04:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F5DEB824D6;
        Fri, 27 May 2022 11:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A1FC385A9;
        Fri, 27 May 2022 11:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651713;
        bh=S8DSGzw8V20FZbRL/FyXfN3Tm7v1Hncxp2pnMVfQqrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIdHaC8p1fI7i3qikc58++XHR9VLaCprI3hNY696gVTmY2lYia/0mG7kfIaupfsIy
         FgmJN+eokcaWOJVfPaS112BsXKtIflvyct+WVF3jZPkvU1B2kcKjJwAqjBbkvQbl1Q
         BIR7OQdEZWQ8FCHDe016jz7+0yrluAbVc1oJcHCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 051/163] random: selectively clang-format where it makes sense
Date:   Fri, 27 May 2022 10:48:51 +0200
Message-Id: <20220527084835.132219281@linuxfoundation.org>
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

commit 248045b8dea5a32ddc0aa44193d6bc70c4b9cd8e upstream.

This is an old driver that has seen a lot of different eras of kernel
coding style. In an effort to make it easier to code for, unify the
coding style around the current norm, by accepting some of -- but
certainly not all of -- the suggestions from clang-format. This should
remove ambiguity in coding style, especially with regards to spacing,
when code is being changed or amended. Consequently it also makes code
review easier on the eyes, following one uniform style rather than
several.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  209 +++++++++++++++++++++++---------------------------
 1 file changed, 99 insertions(+), 110 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -124,7 +124,7 @@
  *
  * The primary kernel interface is
  *
- * 	void get_random_bytes(void *buf, int nbytes);
+ *	void get_random_bytes(void *buf, int nbytes);
  *
  * This interface will return the requested number of random bytes,
  * and place it in the requested buffer.  This is equivalent to a
@@ -132,10 +132,10 @@
  *
  * For less critical applications, there are the functions:
  *
- * 	u32 get_random_u32()
- * 	u64 get_random_u64()
- * 	unsigned int get_random_int()
- * 	unsigned long get_random_long()
+ *	u32 get_random_u32()
+ *	u64 get_random_u64()
+ *	unsigned int get_random_int()
+ *	unsigned long get_random_long()
  *
  * These are produced by a cryptographic RNG seeded from get_random_bytes,
  * and so do not deplete the entropy pool as much.  These are recommended
@@ -197,10 +197,10 @@
  * from the devices are:
  *
  *	void add_device_randomness(const void *buf, unsigned int size);
- * 	void add_input_randomness(unsigned int type, unsigned int code,
+ *	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
  *	void add_interrupt_randomness(int irq);
- * 	void add_disk_randomness(struct gendisk *disk);
+ *	void add_disk_randomness(struct gendisk *disk);
  *	void add_hwgenerator_randomness(const char *buffer, size_t count,
  *					size_t entropy);
  *	void add_bootloader_randomness(const void *buf, unsigned int size);
@@ -296,8 +296,8 @@
  * /dev/random and /dev/urandom created already, they can be created
  * by using the commands:
  *
- * 	mknod /dev/random c 1 8
- * 	mknod /dev/urandom c 1 9
+ *	mknod /dev/random c 1 8
+ *	mknod /dev/urandom c 1 9
  *
  * Acknowledgements:
  * =================
@@ -443,9 +443,9 @@ static DEFINE_SPINLOCK(random_ready_list
 static LIST_HEAD(random_ready_list);
 
 struct crng_state {
-	u32		state[16];
-	unsigned long	init_time;
-	spinlock_t	lock;
+	u32 state[16];
+	unsigned long init_time;
+	spinlock_t lock;
 };
 
 static struct crng_state primary_crng = {
@@ -469,7 +469,7 @@ static bool crng_need_final_init = false
 #define crng_ready() (likely(crng_init > 1))
 static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
-#define CRNG_INIT_CNT_THRESH (2*CHACHA_KEY_SIZE)
+#define CRNG_INIT_CNT_THRESH (2 * CHACHA_KEY_SIZE)
 static void _extract_crng(struct crng_state *crng, u8 out[CHACHA_BLOCK_SIZE]);
 static void _crng_backtrack_protect(struct crng_state *crng,
 				    u8 tmp[CHACHA_BLOCK_SIZE], int used);
@@ -509,7 +509,7 @@ static ssize_t _extract_entropy(void *bu
 
 static void crng_reseed(struct crng_state *crng, bool use_input_pool);
 
-static u32 const twist_table[8] = {
+static const u32 twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
 
@@ -579,10 +579,10 @@ static void mix_pool_bytes(const void *i
 }
 
 struct fast_pool {
-	u32		pool[4];
-	unsigned long	last;
-	u16		reg_idx;
-	u8		count;
+	u32 pool[4];
+	unsigned long last;
+	u16 reg_idx;
+	u8 count;
 };
 
 /*
@@ -710,7 +710,7 @@ static int credit_entropy_bits_safe(int
 		return -EINVAL;
 
 	/* Cap the value to avoid overflows */
-	nbits = min(nbits,  POOL_BITS);
+	nbits = min(nbits, POOL_BITS);
 
 	credit_entropy_bits(nbits);
 	return 0;
@@ -722,7 +722,7 @@ static int credit_entropy_bits_safe(int
  *
  *********************************************************************/
 
-#define CRNG_RESEED_INTERVAL (300*HZ)
+#define CRNG_RESEED_INTERVAL (300 * HZ)
 
 static DECLARE_WAIT_QUEUE_HEAD(crng_init_wait);
 
@@ -746,9 +746,9 @@ early_param("random.trust_cpu", parse_tr
 
 static bool crng_init_try_arch(struct crng_state *crng)
 {
-	int		i;
-	bool		arch_init = true;
-	unsigned long	rv;
+	int i;
+	bool arch_init = true;
+	unsigned long rv;
 
 	for (i = 4; i < 16; i++) {
 		if (!arch_get_random_seed_long(&rv) &&
@@ -764,9 +764,9 @@ static bool crng_init_try_arch(struct cr
 
 static bool __init crng_init_try_arch_early(struct crng_state *crng)
 {
-	int		i;
-	bool		arch_init = true;
-	unsigned long	rv;
+	int i;
+	bool arch_init = true;
+	unsigned long rv;
 
 	for (i = 4; i < 16; i++) {
 		if (!arch_get_random_seed_long_early(&rv) &&
@@ -836,7 +836,7 @@ static void do_numa_crng_init(struct wor
 	struct crng_state *crng;
 	struct crng_state **pool;
 
-	pool = kcalloc(nr_node_ids, sizeof(*pool), GFP_KERNEL|__GFP_NOFAIL);
+	pool = kcalloc(nr_node_ids, sizeof(*pool), GFP_KERNEL | __GFP_NOFAIL);
 	for_each_online_node(i) {
 		crng = kmalloc_node(sizeof(struct crng_state),
 				    GFP_KERNEL | __GFP_NOFAIL, i);
@@ -892,7 +892,7 @@ static size_t crng_fast_load(const u8 *c
 		spin_unlock_irqrestore(&primary_crng.lock, flags);
 		return 0;
 	}
-	p = (u8 *) &primary_crng.state[4];
+	p = (u8 *)&primary_crng.state[4];
 	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
 		p[crng_init_cnt % CHACHA_KEY_SIZE] ^= *cp;
 		cp++; crng_init_cnt++; len--; ret++;
@@ -922,12 +922,12 @@ static size_t crng_fast_load(const u8 *c
  */
 static int crng_slow_load(const u8 *cp, size_t len)
 {
-	unsigned long		flags;
-	static u8		lfsr = 1;
-	u8			tmp;
-	unsigned int		i, max = CHACHA_KEY_SIZE;
-	const u8 *		src_buf = cp;
-	u8 *			dest_buf = (u8 *) &primary_crng.state[4];
+	unsigned long flags;
+	static u8 lfsr = 1;
+	u8 tmp;
+	unsigned int i, max = CHACHA_KEY_SIZE;
+	const u8 *src_buf = cp;
+	u8 *dest_buf = (u8 *)&primary_crng.state[4];
 
 	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
 		return 0;
@@ -938,7 +938,7 @@ static int crng_slow_load(const u8 *cp,
 	if (len > max)
 		max = len;
 
-	for (i = 0; i < max ; i++) {
+	for (i = 0; i < max; i++) {
 		tmp = lfsr;
 		lfsr >>= 1;
 		if (tmp & 1)
@@ -953,11 +953,11 @@ static int crng_slow_load(const u8 *cp,
 
 static void crng_reseed(struct crng_state *crng, bool use_input_pool)
 {
-	unsigned long	flags;
-	int		i, num;
+	unsigned long flags;
+	int i, num;
 	union {
-		u8	block[CHACHA_BLOCK_SIZE];
-		u32	key[8];
+		u8 block[CHACHA_BLOCK_SIZE];
+		u32 key[8];
 	} buf;
 
 	if (use_input_pool) {
@@ -971,11 +971,11 @@ static void crng_reseed(struct crng_stat
 	}
 	spin_lock_irqsave(&crng->lock, flags);
 	for (i = 0; i < 8; i++) {
-		unsigned long	rv;
+		unsigned long rv;
 		if (!arch_get_random_seed_long(&rv) &&
 		    !arch_get_random_long(&rv))
 			rv = random_get_entropy();
-		crng->state[i+4] ^= buf.key[i] ^ rv;
+		crng->state[i + 4] ^= buf.key[i] ^ rv;
 	}
 	memzero_explicit(&buf, sizeof(buf));
 	WRITE_ONCE(crng->init_time, jiffies);
@@ -983,8 +983,7 @@ static void crng_reseed(struct crng_stat
 	crng_finalize_init(crng);
 }
 
-static void _extract_crng(struct crng_state *crng,
-			  u8 out[CHACHA_BLOCK_SIZE])
+static void _extract_crng(struct crng_state *crng, u8 out[CHACHA_BLOCK_SIZE])
 {
 	unsigned long flags, init_time;
 
@@ -1013,9 +1012,9 @@ static void extract_crng(u8 out[CHACHA_B
 static void _crng_backtrack_protect(struct crng_state *crng,
 				    u8 tmp[CHACHA_BLOCK_SIZE], int used)
 {
-	unsigned long	flags;
-	u32		*s, *d;
-	int		i;
+	unsigned long flags;
+	u32 *s, *d;
+	int i;
 
 	used = round_up(used, sizeof(u32));
 	if (used + CHACHA_KEY_SIZE > CHACHA_BLOCK_SIZE) {
@@ -1023,9 +1022,9 @@ static void _crng_backtrack_protect(stru
 		used = 0;
 	}
 	spin_lock_irqsave(&crng->lock, flags);
-	s = (u32 *) &tmp[used];
+	s = (u32 *)&tmp[used];
 	d = &crng->state[4];
-	for (i=0; i < 8; i++)
+	for (i = 0; i < 8; i++)
 		*d++ ^= *s++;
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
@@ -1070,7 +1069,6 @@ static ssize_t extract_crng_user(void __
 	return ret;
 }
 
-
 /*********************************************************************
  *
  * Entropy input management
@@ -1165,11 +1163,11 @@ static void add_timer_randomness(struct
 	 * Round down by 1 bit on general principles,
 	 * and limit entropy estimate to 12 bits.
 	 */
-	credit_entropy_bits(min_t(int, fls(delta>>1), 11));
+	credit_entropy_bits(min_t(int, fls(delta >> 1), 11));
 }
 
 void add_input_randomness(unsigned int type, unsigned int code,
-				 unsigned int value)
+			  unsigned int value)
 {
 	static unsigned char last_value;
 
@@ -1189,19 +1187,19 @@ static DEFINE_PER_CPU(struct fast_pool,
 #ifdef ADD_INTERRUPT_BENCH
 static unsigned long avg_cycles, avg_deviation;
 
-#define AVG_SHIFT 8     /* Exponential average factor k=1/256 */
-#define FIXED_1_2 (1 << (AVG_SHIFT-1))
+#define AVG_SHIFT 8 /* Exponential average factor k=1/256 */
+#define FIXED_1_2 (1 << (AVG_SHIFT - 1))
 
 static void add_interrupt_bench(cycles_t start)
 {
-        long delta = random_get_entropy() - start;
+	long delta = random_get_entropy() - start;
 
-        /* Use a weighted moving average */
-        delta = delta - ((avg_cycles + FIXED_1_2) >> AVG_SHIFT);
-        avg_cycles += delta;
-        /* And average deviation */
-        delta = abs(delta) - ((avg_deviation + FIXED_1_2) >> AVG_SHIFT);
-        avg_deviation += delta;
+	/* Use a weighted moving average */
+	delta = delta - ((avg_cycles + FIXED_1_2) >> AVG_SHIFT);
+	avg_cycles += delta;
+	/* And average deviation */
+	delta = abs(delta) - ((avg_deviation + FIXED_1_2) >> AVG_SHIFT);
+	avg_deviation += delta;
 }
 #else
 #define add_interrupt_bench(x)
@@ -1209,7 +1207,7 @@ static void add_interrupt_bench(cycles_t
 
 static u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
 {
-	u32 *ptr = (u32 *) regs;
+	u32 *ptr = (u32 *)regs;
 	unsigned int idx;
 
 	if (regs == NULL)
@@ -1224,12 +1222,12 @@ static u32 get_reg(struct fast_pool *f,
 
 void add_interrupt_randomness(int irq)
 {
-	struct fast_pool	*fast_pool = this_cpu_ptr(&irq_randomness);
-	struct pt_regs		*regs = get_irq_regs();
-	unsigned long		now = jiffies;
-	cycles_t		cycles = random_get_entropy();
-	u32			c_high, j_high;
-	u64			ip;
+	struct fast_pool *fast_pool = this_cpu_ptr(&irq_randomness);
+	struct pt_regs *regs = get_irq_regs();
+	unsigned long now = jiffies;
+	cycles_t cycles = random_get_entropy();
+	u32 c_high, j_high;
+	u64 ip;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
@@ -1239,8 +1237,8 @@ void add_interrupt_randomness(int irq)
 	fast_pool->pool[1] ^= now ^ c_high;
 	ip = regs ? instruction_pointer(regs) : _RET_IP_;
 	fast_pool->pool[2] ^= ip;
-	fast_pool->pool[3] ^= (sizeof(ip) > 4) ? ip >> 32 :
-		get_reg(fast_pool, regs);
+	fast_pool->pool[3] ^=
+		(sizeof(ip) > 4) ? ip >> 32 : get_reg(fast_pool, regs);
 
 	fast_mix(fast_pool);
 	add_interrupt_bench(cycles);
@@ -1254,8 +1252,7 @@ void add_interrupt_randomness(int irq)
 		return;
 	}
 
-	if ((fast_pool->count < 64) &&
-	    !time_after(now, fast_pool->last + HZ))
+	if ((fast_pool->count < 64) && !time_after(now, fast_pool->last + HZ))
 		return;
 
 	if (!spin_trylock(&input_pool.lock))
@@ -1319,7 +1316,7 @@ retry:
 		entropy_count = 0;
 	}
 	nfrac = ibytes << (POOL_ENTROPY_SHIFT + 3);
-	if ((size_t) entropy_count > nfrac)
+	if ((size_t)entropy_count > nfrac)
 		entropy_count -= nfrac;
 	else
 		entropy_count = 0;
@@ -1422,10 +1419,9 @@ static ssize_t extract_entropy(void *buf
 }
 
 #define warn_unseeded_randomness(previous) \
-	_warn_unseeded_randomness(__func__, (void *) _RET_IP_, (previous))
+	_warn_unseeded_randomness(__func__, (void *)_RET_IP_, (previous))
 
-static void _warn_unseeded_randomness(const char *func_name, void *caller,
-				      void **previous)
+static void _warn_unseeded_randomness(const char *func_name, void *caller, void **previous)
 {
 #ifdef CONFIG_WARN_ALL_UNSEEDED_RANDOM
 	const bool print_once = false;
@@ -1433,8 +1429,7 @@ static void _warn_unseeded_randomness(co
 	static bool print_once __read_mostly;
 #endif
 
-	if (print_once ||
-	    crng_ready() ||
+	if (print_once || crng_ready() ||
 	    (previous && (caller == READ_ONCE(*previous))))
 		return;
 	WRITE_ONCE(*previous, caller);
@@ -1442,9 +1437,8 @@ static void _warn_unseeded_randomness(co
 	print_once = true;
 #endif
 	if (__ratelimit(&unseeded_warning))
-		printk_deferred(KERN_NOTICE "random: %s called from %pS "
-				"with crng_init=%d\n", func_name, caller,
-				crng_init);
+		printk_deferred(KERN_NOTICE "random: %s called from %pS with crng_init=%d\n",
+				func_name, caller, crng_init);
 }
 
 /*
@@ -1487,7 +1481,6 @@ void get_random_bytes(void *buf, int nby
 }
 EXPORT_SYMBOL(get_random_bytes);
 
-
 /*
  * Each time the timer fires, we expect that we got an unpredictable
  * jump in the cycle counter. Even if the timer is running on another
@@ -1526,7 +1519,7 @@ static void try_to_generate_entropy(void
 	timer_setup_on_stack(&stack.timer, entropy_timer, 0);
 	while (!crng_ready()) {
 		if (!timer_pending(&stack.timer))
-			mod_timer(&stack.timer, jiffies+1);
+			mod_timer(&stack.timer, jiffies + 1);
 		mix_pool_bytes(&stack.now, sizeof(stack.now));
 		schedule();
 		stack.now = random_get_entropy();
@@ -1736,9 +1729,8 @@ void rand_initialize_disk(struct gendisk
 }
 #endif
 
-static ssize_t
-urandom_read_nowarn(struct file *file, char __user *buf, size_t nbytes,
-		    loff_t *ppos)
+static ssize_t urandom_read_nowarn(struct file *file, char __user *buf,
+				   size_t nbytes, loff_t *ppos)
 {
 	int ret;
 
@@ -1748,8 +1740,8 @@ urandom_read_nowarn(struct file *file, c
 	return ret;
 }
 
-static ssize_t
-urandom_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+static ssize_t urandom_read(struct file *file, char __user *buf, size_t nbytes,
+			    loff_t *ppos)
 {
 	static int maxwarn = 10;
 
@@ -1763,8 +1755,8 @@ urandom_read(struct file *file, char __u
 	return urandom_read_nowarn(file, buf, nbytes, ppos);
 }
 
-static ssize_t
-random_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+static ssize_t random_read(struct file *file, char __user *buf, size_t nbytes,
+			   loff_t *ppos)
 {
 	int ret;
 
@@ -1774,8 +1766,7 @@ random_read(struct file *file, char __us
 	return urandom_read_nowarn(file, buf, nbytes, ppos);
 }
 
-static __poll_t
-random_poll(struct file *file, poll_table * wait)
+static __poll_t random_poll(struct file *file, poll_table *wait)
 {
 	__poll_t mask;
 
@@ -1789,8 +1780,7 @@ random_poll(struct file *file, poll_tabl
 	return mask;
 }
 
-static int
-write_pool(const char __user *buffer, size_t count)
+static int write_pool(const char __user *buffer, size_t count)
 {
 	size_t bytes;
 	u32 t, buf[16];
@@ -1895,9 +1885,9 @@ static int random_fasync(int fd, struct
 }
 
 const struct file_operations random_fops = {
-	.read  = random_read,
+	.read = random_read,
 	.write = random_write,
-	.poll  = random_poll,
+	.poll = random_poll,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,
@@ -1905,7 +1895,7 @@ const struct file_operations random_fops
 };
 
 const struct file_operations urandom_fops = {
-	.read  = urandom_read,
+	.read = urandom_read,
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
 	.compat_ioctl = compat_ptr_ioctl,
@@ -1913,19 +1903,19 @@ const struct file_operations urandom_fop
 	.llseek = noop_llseek,
 };
 
-SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
-		unsigned int, flags)
+SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count, unsigned int,
+		flags)
 {
 	int ret;
 
-	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM|GRND_INSECURE))
+	if (flags & ~(GRND_NONBLOCK | GRND_RANDOM | GRND_INSECURE))
 		return -EINVAL;
 
 	/*
 	 * Requesting insecure and blocking randomness at the same time makes
 	 * no sense.
 	 */
-	if ((flags & (GRND_INSECURE|GRND_RANDOM)) == (GRND_INSECURE|GRND_RANDOM))
+	if ((flags & (GRND_INSECURE | GRND_RANDOM)) == (GRND_INSECURE | GRND_RANDOM))
 		return -EINVAL;
 
 	if (count > INT_MAX)
@@ -1965,8 +1955,8 @@ static char sysctl_bootid[16];
  * returned as an ASCII string in the standard UUID format; if via the
  * sysctl system call, as 16 bytes of binary data.
  */
-static int proc_do_uuid(struct ctl_table *table, int write,
-			void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_do_uuid(struct ctl_table *table, int write, void *buffer,
+			size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table fake_table;
 	unsigned char buf[64], tmp_uuid[16], *uuid;
@@ -1995,8 +1985,8 @@ static int proc_do_uuid(struct ctl_table
 /*
  * Return entropy available scaled to integral bits
  */
-static int proc_do_entropy(struct ctl_table *table, int write,
-			   void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_do_entropy(struct ctl_table *table, int write, void *buffer,
+			   size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table fake_table;
 	int entropy_count;
@@ -2073,7 +2063,7 @@ struct ctl_table random_table[] = {
 #endif
 	{ }
 };
-#endif 	/* CONFIG_SYSCTL */
+#endif	/* CONFIG_SYSCTL */
 
 struct batched_entropy {
 	union {
@@ -2093,7 +2083,7 @@ struct batched_entropy {
  * point prior.
  */
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u64) = {
-	.batch_lock	= __SPIN_LOCK_UNLOCKED(batched_entropy_u64.lock),
+	.batch_lock = __SPIN_LOCK_UNLOCKED(batched_entropy_u64.lock),
 };
 
 u64 get_random_u64(void)
@@ -2118,7 +2108,7 @@ u64 get_random_u64(void)
 EXPORT_SYMBOL(get_random_u64);
 
 static DEFINE_PER_CPU(struct batched_entropy, batched_entropy_u32) = {
-	.batch_lock	= __SPIN_LOCK_UNLOCKED(batched_entropy_u32.lock),
+	.batch_lock = __SPIN_LOCK_UNLOCKED(batched_entropy_u32.lock),
 };
 u32 get_random_u32(void)
 {
@@ -2150,7 +2140,7 @@ static void invalidate_batched_entropy(v
 	int cpu;
 	unsigned long flags;
 
-	for_each_possible_cpu (cpu) {
+	for_each_possible_cpu(cpu) {
 		struct batched_entropy *batched_entropy;
 
 		batched_entropy = per_cpu_ptr(&batched_entropy_u32, cpu);
@@ -2179,8 +2169,7 @@ static void invalidate_batched_entropy(v
  * Return: A page aligned address within [start, start + range).  On error,
  * @start is returned.
  */
-unsigned long
-randomize_page(unsigned long start, unsigned long range)
+unsigned long randomize_page(unsigned long start, unsigned long range)
 {
 	if (!PAGE_ALIGNED(start)) {
 		range -= PAGE_ALIGN(start) - start;


