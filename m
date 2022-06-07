Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7430536013
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237908AbiE0Ln7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244406AbiE0LnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:43:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF9413C1CE;
        Fri, 27 May 2022 04:40:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9F95B824D8;
        Fri, 27 May 2022 11:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDCAC385A9;
        Fri, 27 May 2022 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651636;
        bh=P8qT4h18c3j+Z+cKgRc6ExMuMIN1wtHhFwGiaT6Dk0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tP8uaQR09NEU6BMxo/BUudHsiiRShnKpNRjsPsFtBH2z1RJu85YePJs183/jcvicV
         HECPm2Hey9WKbwTCPNwkXbiftFpj8GaRC+hjxeMLlRS7aHnL6YxnQryVxbI5oa5C6M
         xQk3eJOB9fH03ZNcgFN0ygiIDNebqSY20ojeUdRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 042/163] random: cleanup integer types
Date:   Fri, 27 May 2022 10:48:42 +0200
Message-Id: <20220527084833.920642763@linuxfoundation.org>
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

commit d38bb0853589c939573ea50e9cb64f733e0e273d upstream.

Rather than using the userspace type, __uXX, switch to using uXX. And
rather than using variously chosen `char *` or `unsigned char *`, use
`u8 *` uniformly for things that aren't strings, in the case where we
are doing byte-by-byte traversal.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |  105 ++++++++++++++++++++++++--------------------------
 1 file changed, 52 insertions(+), 53 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -456,7 +456,7 @@ static DEFINE_SPINLOCK(random_ready_list
 static LIST_HEAD(random_ready_list);
 
 struct crng_state {
-	__u32		state[16];
+	u32		state[16];
 	unsigned long	init_time;
 	spinlock_t	lock;
 };
@@ -483,9 +483,9 @@ static bool crng_need_final_init = false
 static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
 #define CRNG_INIT_CNT_THRESH (2*CHACHA_KEY_SIZE)
-static void _extract_crng(struct crng_state *crng, __u8 out[CHACHA_BLOCK_SIZE]);
+static void _extract_crng(struct crng_state *crng, u8 out[CHACHA_BLOCK_SIZE]);
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u8 tmp[CHACHA_BLOCK_SIZE], int used);
+				    u8 tmp[CHACHA_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
 static void _get_random_bytes(void *buf, int nbytes);
 
@@ -509,16 +509,16 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
 struct entropy_store;
 struct entropy_store {
 	/* read-only data: */
-	__u32 *pool;
+	u32 *pool;
 	const char *name;
 
 	/* read-write data: */
 	spinlock_t lock;
-	unsigned short add_ptr;
-	unsigned short input_rotate;
+	u16 add_ptr;
+	u16 input_rotate;
 	int entropy_count;
 	unsigned int last_data_init:1;
-	__u8 last_data[EXTRACT_SIZE];
+	u8 last_data[EXTRACT_SIZE];
 };
 
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
@@ -527,7 +527,7 @@ static ssize_t _extract_entropy(struct e
 				size_t nbytes, int fips);
 
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
-static __u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
+static u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
 
 static struct entropy_store input_pool = {
 	.name = "input",
@@ -535,7 +535,7 @@ static struct entropy_store input_pool =
 	.pool = input_pool_data
 };
 
-static __u32 const twist_table[8] = {
+static u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
 
@@ -554,8 +554,8 @@ static void _mix_pool_bytes(struct entro
 {
 	unsigned long i;
 	int input_rotate;
-	const unsigned char *bytes = in;
-	__u32 w;
+	const u8 *bytes = in;
+	u32 w;
 
 	input_rotate = r->input_rotate;
 	i = r->add_ptr;
@@ -608,10 +608,10 @@ static void mix_pool_bytes(struct entrop
 }
 
 struct fast_pool {
-	__u32		pool[4];
+	u32		pool[4];
 	unsigned long	last;
-	unsigned short	reg_idx;
-	unsigned char	count;
+	u16		reg_idx;
+	u8		count;
 };
 
 /*
@@ -621,8 +621,8 @@ struct fast_pool {
  */
 static void fast_mix(struct fast_pool *f)
 {
-	__u32 a = f->pool[0],	b = f->pool[1];
-	__u32 c = f->pool[2],	d = f->pool[3];
+	u32 a = f->pool[0],	b = f->pool[1];
+	u32 c = f->pool[2],	d = f->pool[3];
 
 	a += b;			c += d;
 	b = rol32(b, 6);	d = rol32(d, 27);
@@ -814,14 +814,14 @@ static bool __init crng_init_try_arch_ea
 static void crng_initialize_secondary(struct crng_state *crng)
 {
 	chacha_init_consts(crng->state);
-	_get_random_bytes(&crng->state[4], sizeof(__u32) * 12);
+	_get_random_bytes(&crng->state[4], sizeof(u32) * 12);
 	crng_init_try_arch(crng);
 	crng->init_time = jiffies - CRNG_RESEED_INTERVAL - 1;
 }
 
 static void __init crng_initialize_primary(struct crng_state *crng)
 {
-	_extract_entropy(&input_pool, &crng->state[4], sizeof(__u32) * 12, 0);
+	_extract_entropy(&input_pool, &crng->state[4], sizeof(u32) * 12, 0);
 	if (crng_init_try_arch_early(crng) && trust_cpu && crng_init < 2) {
 		invalidate_batched_entropy();
 		numa_crng_init();
@@ -911,10 +911,10 @@ static struct crng_state *select_crng(vo
  * path.  So we can't afford to dilly-dally. Returns the number of
  * bytes processed from cp.
  */
-static size_t crng_fast_load(const char *cp, size_t len)
+static size_t crng_fast_load(const u8 *cp, size_t len)
 {
 	unsigned long flags;
-	char *p;
+	u8 *p;
 	size_t ret = 0;
 
 	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
@@ -923,7 +923,7 @@ static size_t crng_fast_load(const char
 		spin_unlock_irqrestore(&primary_crng.lock, flags);
 		return 0;
 	}
-	p = (unsigned char *) &primary_crng.state[4];
+	p = (u8 *) &primary_crng.state[4];
 	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
 		p[crng_init_cnt % CHACHA_KEY_SIZE] ^= *cp;
 		cp++; crng_init_cnt++; len--; ret++;
@@ -951,14 +951,14 @@ static size_t crng_fast_load(const char
  * like a fixed DMI table (for example), which might very well be
  * unique to the machine, but is otherwise unvarying.
  */
-static int crng_slow_load(const char *cp, size_t len)
+static int crng_slow_load(const u8 *cp, size_t len)
 {
 	unsigned long		flags;
-	static unsigned char	lfsr = 1;
-	unsigned char		tmp;
-	unsigned		i, max = CHACHA_KEY_SIZE;
-	const char *		src_buf = cp;
-	char *			dest_buf = (char *) &primary_crng.state[4];
+	static u8		lfsr = 1;
+	u8			tmp;
+	unsigned int		i, max = CHACHA_KEY_SIZE;
+	const u8 *		src_buf = cp;
+	u8 *			dest_buf = (u8 *) &primary_crng.state[4];
 
 	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
 		return 0;
@@ -987,8 +987,8 @@ static void crng_reseed(struct crng_stat
 	unsigned long	flags;
 	int		i, num;
 	union {
-		__u8	block[CHACHA_BLOCK_SIZE];
-		__u32	key[8];
+		u8	block[CHACHA_BLOCK_SIZE];
+		u32	key[8];
 	} buf;
 
 	if (r) {
@@ -1015,7 +1015,7 @@ static void crng_reseed(struct crng_stat
 }
 
 static void _extract_crng(struct crng_state *crng,
-			  __u8 out[CHACHA_BLOCK_SIZE])
+			  u8 out[CHACHA_BLOCK_SIZE])
 {
 	unsigned long flags, init_time;
 
@@ -1033,7 +1033,7 @@ static void _extract_crng(struct crng_st
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void extract_crng(__u8 out[CHACHA_BLOCK_SIZE])
+static void extract_crng(u8 out[CHACHA_BLOCK_SIZE])
 {
 	_extract_crng(select_crng(), out);
 }
@@ -1043,26 +1043,26 @@ static void extract_crng(__u8 out[CHACHA
  * enough) to mutate the CRNG key to provide backtracking protection.
  */
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u8 tmp[CHACHA_BLOCK_SIZE], int used)
+				    u8 tmp[CHACHA_BLOCK_SIZE], int used)
 {
 	unsigned long	flags;
-	__u32		*s, *d;
+	u32		*s, *d;
 	int		i;
 
-	used = round_up(used, sizeof(__u32));
+	used = round_up(used, sizeof(u32));
 	if (used + CHACHA_KEY_SIZE > CHACHA_BLOCK_SIZE) {
 		extract_crng(tmp);
 		used = 0;
 	}
 	spin_lock_irqsave(&crng->lock, flags);
-	s = (__u32 *) &tmp[used];
+	s = (u32 *) &tmp[used];
 	d = &crng->state[4];
 	for (i=0; i < 8; i++)
 		*d++ ^= *s++;
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void crng_backtrack_protect(__u8 tmp[CHACHA_BLOCK_SIZE], int used)
+static void crng_backtrack_protect(u8 tmp[CHACHA_BLOCK_SIZE], int used)
 {
 	_crng_backtrack_protect(select_crng(), tmp, used);
 }
@@ -1070,7 +1070,7 @@ static void crng_backtrack_protect(__u8
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i = CHACHA_BLOCK_SIZE;
-	__u8 tmp[CHACHA_BLOCK_SIZE] __aligned(4);
+	u8 tmp[CHACHA_BLOCK_SIZE] __aligned(4);
 	int large_request = (nbytes > 256);
 
 	while (nbytes) {
@@ -1158,8 +1158,8 @@ static void add_timer_randomness(struct
 	struct entropy_store	*r;
 	struct {
 		long jiffies;
-		unsigned cycles;
-		unsigned num;
+		unsigned int cycles;
+		unsigned int num;
 	} sample;
 	long delta, delta2, delta3;
 
@@ -1241,15 +1241,15 @@ static void add_interrupt_bench(cycles_t
 #define add_interrupt_bench(x)
 #endif
 
-static __u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
+static u32 get_reg(struct fast_pool *f, struct pt_regs *regs)
 {
-	__u32 *ptr = (__u32 *) regs;
+	u32 *ptr = (u32 *) regs;
 	unsigned int idx;
 
 	if (regs == NULL)
 		return 0;
 	idx = READ_ONCE(f->reg_idx);
-	if (idx >= sizeof(struct pt_regs) / sizeof(__u32))
+	if (idx >= sizeof(struct pt_regs) / sizeof(u32))
 		idx = 0;
 	ptr += idx++;
 	WRITE_ONCE(f->reg_idx, idx);
@@ -1263,8 +1263,8 @@ void add_interrupt_randomness(int irq)
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
 	cycles_t		cycles = random_get_entropy();
-	__u32			c_high, j_high;
-	__u64			ip;
+	u32			c_high, j_high;
+	u64			ip;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
@@ -1282,8 +1282,7 @@ void add_interrupt_randomness(int irq)
 
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
-		    crng_fast_load((char *) fast_pool->pool,
-				   sizeof(fast_pool->pool)) > 0) {
+		    crng_fast_load((u8 *)fast_pool->pool, sizeof(fast_pool->pool)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
 		}
@@ -1380,7 +1379,7 @@ retry:
  *
  * Note: we assume that .poolwords is a multiple of 16 words.
  */
-static void extract_buf(struct entropy_store *r, __u8 *out)
+static void extract_buf(struct entropy_store *r, u8 *out)
 {
 	struct blake2s_state state __aligned(__alignof__(unsigned long));
 	u8 hash[BLAKE2S_HASH_SIZE];
@@ -1430,7 +1429,7 @@ static ssize_t _extract_entropy(struct e
 				size_t nbytes, int fips)
 {
 	ssize_t ret = 0, i;
-	__u8 tmp[EXTRACT_SIZE];
+	u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
 	while (nbytes) {
@@ -1468,7 +1467,7 @@ static ssize_t _extract_entropy(struct e
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 				 size_t nbytes, int min, int reserved)
 {
-	__u8 tmp[EXTRACT_SIZE];
+	u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
 	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
@@ -1530,7 +1529,7 @@ static void _warn_unseeded_randomness(co
  */
 static void _get_random_bytes(void *buf, int nbytes)
 {
-	__u8 tmp[CHACHA_BLOCK_SIZE] __aligned(4);
+	u8 tmp[CHACHA_BLOCK_SIZE] __aligned(4);
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
@@ -1724,7 +1723,7 @@ EXPORT_SYMBOL(del_random_ready_callback)
 int __must_check get_random_bytes_arch(void *buf, int nbytes)
 {
 	int left = nbytes;
-	char *p = buf;
+	u8 *p = buf;
 
 	trace_get_random_bytes_arch(left, _RET_IP_);
 	while (left) {
@@ -1866,7 +1865,7 @@ static int
 write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 {
 	size_t bytes;
-	__u32 t, buf[16];
+	u32 t, buf[16];
 	const char __user *p = buffer;
 
 	while (count > 0) {
@@ -1876,7 +1875,7 @@ write_pool(struct entropy_store *r, cons
 		if (copy_from_user(&buf, p, bytes))
 			return -EFAULT;
 
-		for (b = bytes ; b > 0 ; b -= sizeof(__u32), i++) {
+		for (b = bytes; b > 0; b -= sizeof(u32), i++) {
 			if (!arch_get_random_int(&t))
 				break;
 			buf[i] ^= t;


