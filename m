Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C10558329
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233834AbiFWR0G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiFWRZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118EE4F9F2;
        Thu, 23 Jun 2022 10:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 884A56159A;
        Thu, 23 Jun 2022 17:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B85C3411B;
        Thu, 23 Jun 2022 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003747;
        bh=kc7tC5l/+BrM/OAd2wG2LFIq9ohFNPbaBFcJ1AFq8A8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=skxhGgcLi2UAkkVeNwKYXezbjHIElYLpJx70v+lf3JiY1eMbZ0mbv88zeVIiwyIf+
         PoE1ZVpOEJ/gJah1XEhcbGqTRhunMpvLGto6/5QPWgW2pPW3P6IWFYdY1JK0hLv9rk
         pcmCeCbaK0+F8Bm+1zAVzUmrvqjaWFfYEBGuy2hg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 074/237] random: cleanup integer types
Date:   Thu, 23 Jun 2022 18:41:48 +0200
Message-Id: <20220623164345.281821881@linuxfoundation.org>
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
 drivers/char/random.c |  114 +++++++++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 57 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -457,7 +457,7 @@ static DEFINE_SPINLOCK(random_ready_list
 static LIST_HEAD(random_ready_list);
 
 struct crng_state {
-	__u32		state[16];
+	u32		state[16];
 	unsigned long	init_time;
 	spinlock_t	lock;
 };
@@ -484,10 +484,9 @@ static bool crng_need_final_init = false
 static int crng_init_cnt = 0;
 static unsigned long crng_global_init_time = 0;
 #define CRNG_INIT_CNT_THRESH (2*CHACHA20_KEY_SIZE)
-static void _extract_crng(struct crng_state *crng,
-			  __u8 out[CHACHA20_BLOCK_SIZE]);
+static void _extract_crng(struct crng_state *crng, u8 out[CHACHA20_BLOCK_SIZE]);
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used);
+				    u8 tmp[CHACHA20_BLOCK_SIZE], int used);
 static void process_random_ready_list(void);
 static void _get_random_bytes(void *buf, int nbytes);
 
@@ -511,16 +510,16 @@ MODULE_PARM_DESC(ratelimit_disable, "Dis
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
@@ -529,7 +528,7 @@ static ssize_t _extract_entropy(struct e
 				size_t nbytes, int fips);
 
 static void crng_reseed(struct crng_state *crng, struct entropy_store *r);
-static __u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
+static u32 input_pool_data[INPUT_POOL_WORDS] __latent_entropy;
 
 static struct entropy_store input_pool = {
 	.name = "input",
@@ -537,7 +536,7 @@ static struct entropy_store input_pool =
 	.pool = input_pool_data
 };
 
-static __u32 const twist_table[8] = {
+static u32 const twist_table[8] = {
 	0x00000000, 0x3b6e20c8, 0x76dc4190, 0x4db26158,
 	0xedb88320, 0xd6d6a3e8, 0x9b64c2b0, 0xa00ae278 };
 
@@ -556,8 +555,8 @@ static void _mix_pool_bytes(struct entro
 {
 	unsigned long i;
 	int input_rotate;
-	const unsigned char *bytes = in;
-	__u32 w;
+	const u8 *bytes = in;
+	u32 w;
 
 	input_rotate = r->input_rotate;
 	i = r->add_ptr;
@@ -610,10 +609,10 @@ static void mix_pool_bytes(struct entrop
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
@@ -623,8 +622,8 @@ struct fast_pool {
  */
 static void fast_mix(struct fast_pool *f)
 {
-	__u32 a = f->pool[0],	b = f->pool[1];
-	__u32 c = f->pool[2],	d = f->pool[3];
+	u32 a = f->pool[0],	b = f->pool[1];
+	u32 c = f->pool[2],	d = f->pool[3];
 
 	a += b;			c += d;
 	b = rol32(b, 6);	d = rol32(d, 27);
@@ -815,14 +814,14 @@ static bool __init crng_init_try_arch_ea
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
@@ -909,12 +908,14 @@ static struct crng_state *select_crng(vo
 
 /*
  * crng_fast_load() can be called by code in the interrupt service
- * path.  So we can't afford to dilly-dally.
+ * path.  So we can't afford to dilly-dally. Returns the number of
+ * bytes processed from cp.
  */
-static int crng_fast_load(const char *cp, size_t len)
+static size_t crng_fast_load(const u8 *cp, size_t len)
 {
 	unsigned long flags;
-	char *p;
+	u8 *p;
+	size_t ret = 0;
 
 	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
 		return 0;
@@ -922,10 +923,10 @@ static int crng_fast_load(const char *cp
 		spin_unlock_irqrestore(&primary_crng.lock, flags);
 		return 0;
 	}
-	p = (unsigned char *) &primary_crng.state[4];
+	p = (u8 *) &primary_crng.state[4];
 	while (len > 0 && crng_init_cnt < CRNG_INIT_CNT_THRESH) {
 		p[crng_init_cnt % CHACHA20_KEY_SIZE] ^= *cp;
-		cp++; crng_init_cnt++; len--;
+		cp++; crng_init_cnt++; len--; ret++;
 	}
 	spin_unlock_irqrestore(&primary_crng.lock, flags);
 	if (crng_init_cnt >= CRNG_INIT_CNT_THRESH) {
@@ -933,7 +934,7 @@ static int crng_fast_load(const char *cp
 		crng_init = 1;
 		pr_notice("fast init done\n");
 	}
-	return 1;
+	return ret;
 }
 
 /*
@@ -950,14 +951,14 @@ static int crng_fast_load(const char *cp
  * like a fixed DMI table (for example), which might very well be
  * unique to the machine, but is otherwise unvarying.
  */
-static int crng_slow_load(const char *cp, size_t len)
+static int crng_slow_load(const u8 *cp, size_t len)
 {
 	unsigned long		flags;
-	static unsigned char	lfsr = 1;
-	unsigned char		tmp;
-	unsigned		i, max = CHACHA20_KEY_SIZE;
-	const char *		src_buf = cp;
-	char *			dest_buf = (char *) &primary_crng.state[4];
+	static u8		lfsr = 1;
+	u8			tmp;
+	unsigned int		i, max = CHACHA20_KEY_SIZE;
+	const u8 *		src_buf = cp;
+	u8 *			dest_buf = (u8 *) &primary_crng.state[4];
 
 	if (!spin_trylock_irqsave(&primary_crng.lock, flags))
 		return 0;
@@ -986,8 +987,8 @@ static void crng_reseed(struct crng_stat
 	unsigned long	flags;
 	int		i, num;
 	union {
-		__u8	block[CHACHA20_BLOCK_SIZE];
-		__u32	key[8];
+		u8	block[CHACHA20_BLOCK_SIZE];
+		u32	key[8];
 	} buf;
 
 	if (r) {
@@ -1014,7 +1015,7 @@ static void crng_reseed(struct crng_stat
 }
 
 static void _extract_crng(struct crng_state *crng,
-			  __u8 out[CHACHA20_BLOCK_SIZE])
+			  u8 out[CHACHA20_BLOCK_SIZE])
 {
 	unsigned long flags, init_time;
 
@@ -1032,7 +1033,7 @@ static void _extract_crng(struct crng_st
 	spin_unlock_irqrestore(&crng->lock, flags);
 }
 
-static void extract_crng(__u8 out[CHACHA20_BLOCK_SIZE])
+static void extract_crng(u8 out[CHACHA20_BLOCK_SIZE])
 {
 	_extract_crng(select_crng(), out);
 }
@@ -1042,26 +1043,26 @@ static void extract_crng(__u8 out[CHACHA
  * enough) to mutate the CRNG key to provide backtracking protection.
  */
 static void _crng_backtrack_protect(struct crng_state *crng,
-				    __u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+				    u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 {
 	unsigned long	flags;
-	__u32		*s, *d;
+	u32		*s, *d;
 	int		i;
 
-	used = round_up(used, sizeof(__u32));
+	used = round_up(used, sizeof(u32));
 	if (used + CHACHA20_KEY_SIZE > CHACHA20_BLOCK_SIZE) {
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
 
-static void crng_backtrack_protect(__u8 tmp[CHACHA20_BLOCK_SIZE], int used)
+static void crng_backtrack_protect(u8 tmp[CHACHA20_BLOCK_SIZE], int used)
 {
 	_crng_backtrack_protect(select_crng(), tmp, used);
 }
@@ -1069,7 +1070,7 @@ static void crng_backtrack_protect(__u8
 static ssize_t extract_crng_user(void __user *buf, size_t nbytes)
 {
 	ssize_t ret = 0, i = CHACHA20_BLOCK_SIZE;
-	__u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
+	u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
 	int large_request = (nbytes > 256);
 
 	while (nbytes) {
@@ -1157,8 +1158,8 @@ static void add_timer_randomness(struct
 	struct entropy_store	*r;
 	struct {
 		long jiffies;
-		unsigned cycles;
-		unsigned num;
+		unsigned int cycles;
+		unsigned int num;
 	} sample;
 	long delta, delta2, delta3;
 
@@ -1240,15 +1241,15 @@ static void add_interrupt_bench(cycles_t
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
@@ -1262,8 +1263,8 @@ void add_interrupt_randomness(int irq)
 	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
 	cycles_t		cycles = random_get_entropy();
-	__u32			c_high, j_high;
-	__u64			ip;
+	u32			c_high, j_high;
+	u64			ip;
 
 	if (cycles == 0)
 		cycles = get_reg(fast_pool, regs);
@@ -1281,8 +1282,7 @@ void add_interrupt_randomness(int irq)
 
 	if (unlikely(crng_init == 0)) {
 		if ((fast_pool->count >= 64) &&
-		    crng_fast_load((char *) fast_pool->pool,
-				   sizeof(fast_pool->pool))) {
+		    crng_fast_load((u8 *)fast_pool->pool, sizeof(fast_pool->pool)) > 0) {
 			fast_pool->count = 0;
 			fast_pool->last = now;
 		}
@@ -1379,7 +1379,7 @@ retry:
  *
  * Note: we assume that .poolwords is a multiple of 16 words.
  */
-static void extract_buf(struct entropy_store *r, __u8 *out)
+static void extract_buf(struct entropy_store *r, u8 *out)
 {
 	struct blake2s_state state __aligned(__alignof__(unsigned long));
 	u8 hash[BLAKE2S_HASH_SIZE];
@@ -1429,7 +1429,7 @@ static ssize_t _extract_entropy(struct e
 				size_t nbytes, int fips)
 {
 	ssize_t ret = 0, i;
-	__u8 tmp[EXTRACT_SIZE];
+	u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
 	while (nbytes) {
@@ -1467,7 +1467,7 @@ static ssize_t _extract_entropy(struct e
 static ssize_t extract_entropy(struct entropy_store *r, void *buf,
 				 size_t nbytes, int min, int reserved)
 {
-	__u8 tmp[EXTRACT_SIZE];
+	u8 tmp[EXTRACT_SIZE];
 	unsigned long flags;
 
 	/* if last_data isn't primed, we need EXTRACT_SIZE extra bytes */
@@ -1529,7 +1529,7 @@ static void _warn_unseeded_randomness(co
  */
 static void _get_random_bytes(void *buf, int nbytes)
 {
-	__u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
+	u8 tmp[CHACHA20_BLOCK_SIZE] __aligned(4);
 
 	trace_get_random_bytes(nbytes, _RET_IP_);
 
@@ -1663,7 +1663,7 @@ EXPORT_SYMBOL(del_random_ready_callback)
 int __must_check get_random_bytes_arch(void *buf, int nbytes)
 {
 	int left = nbytes;
-	char *p = buf;
+	u8 *p = buf;
 
 	trace_get_random_bytes_arch(left, _RET_IP_);
 	while (left) {
@@ -1805,7 +1805,7 @@ static int
 write_pool(struct entropy_store *r, const char __user *buffer, size_t count)
 {
 	size_t bytes;
-	__u32 t, buf[16];
+	u32 t, buf[16];
 	const char __user *p = buffer;
 
 	while (count > 0) {
@@ -1815,7 +1815,7 @@ write_pool(struct entropy_store *r, cons
 		if (copy_from_user(&buf, p, bytes))
 			return -EFAULT;
 
-		for (b = bytes ; b > 0 ; b -= sizeof(__u32), i++) {
+		for (b = bytes; b > 0; b -= sizeof(u32), i++) {
 			if (!arch_get_random_int(&t))
 				break;
 			buf[i] ^= t;


