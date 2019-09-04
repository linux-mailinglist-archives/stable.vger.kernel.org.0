Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6ED1A8E3D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbfIDR4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:34324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387711AbfIDR4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB8B22CEA;
        Wed,  4 Sep 2019 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619810;
        bh=IcaIFbPlFXRovpM/g2hpMZDnoRTvZYQ1J3vX81aC6XU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxWyN72sFUpq3OqVWDUEtHQkd2CEpuHmTXL64ynb7ZDSx3xw+FvZnov/fzAY1GYM5
         zaXNnmNoYCz0Ch2xq0AIvpIjQZQO47cxrEL0e+P2aF2DOtbOF0XIj7jYsn9LD2aTPt
         E1O7L4TJn4pTJpcFUxja+fiOooo9dQvh1bEG+vdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        David Laight <David.Laight@aculab.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 42/77] siphash: add cryptographically secure PRF
Date:   Wed,  4 Sep 2019 19:53:29 +0200
Message-Id: <20190904175307.495842373@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2c956a60778cbb6a27e0c7a8a52a91378c90e1d1 upstream.

SipHash is a 64-bit keyed hash function that is actually a
cryptographically secure PRF, like HMAC. Except SipHash is super fast,
and is meant to be used as a hashtable keyed lookup function, or as a
general PRF for short input use cases, such as sequence numbers or RNG
chaining.

For the first usage:

There are a variety of attacks known as "hashtable poisoning" in which an
attacker forms some data such that the hash of that data will be the
same, and then preceeds to fill up all entries of a hashbucket. This is
a realistic and well-known denial-of-service vector. Currently
hashtables use jhash, which is fast but not secure, and some kind of
rotating key scheme (or none at all, which isn't good). SipHash is meant
as a replacement for jhash in these cases.

There are a modicum of places in the kernel that are vulnerable to
hashtable poisoning attacks, either via userspace vectors or network
vectors, and there's not a reliable mechanism inside the kernel at the
moment to fix it. The first step toward fixing these issues is actually
getting a secure primitive into the kernel for developers to use. Then
we can, bit by bit, port things over to it as deemed appropriate.

While SipHash is extremely fast for a cryptographically secure function,
it is likely a bit slower than the insecure jhash, and so replacements
will be evaluated on a case-by-case basis based on whether or not the
difference in speed is negligible and whether or not the current jhash usage
poses a real security risk.

For the second usage:

A few places in the kernel are using MD5 or SHA1 for creating secure
sequence numbers, syn cookies, port numbers, or fast random numbers.
SipHash is a faster and more fitting, and more secure replacement for MD5
in those situations. Replacing MD5 and SHA1 with SipHash for these uses is
obvious and straight-forward, and so is submitted along with this patch
series. There shouldn't be much of a debate over its efficacy.

Dozens of languages are already using this internally for their hash
tables and PRFs. Some of the BSDs already use this in their kernels.
SipHash is a widely known high-speed solution to a widely known set of
problems, and it's time we catch-up.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Biggers <ebiggers3@gmail.com>
Cc: David Laight <David.Laight@aculab.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Backported to 4.4 as dependency of commits df453700e8d8 "inet: switch
 IP ID generator to siphash" and 3c79107631db "netfilter: ctnetlink: don't
 use conntrack/expect object addresses as id":
 - Adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/siphash.txt | 100 ++++++++++++++++
 MAINTAINERS               |   7 ++
 include/linux/siphash.h   |  85 ++++++++++++++
 lib/Kconfig.debug         |  10 ++
 lib/Makefile              |   3 +-
 lib/siphash.c             | 232 ++++++++++++++++++++++++++++++++++++++
 lib/test_siphash.c        | 131 +++++++++++++++++++++
 7 files changed, 567 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/siphash.txt
 create mode 100644 include/linux/siphash.h
 create mode 100644 lib/siphash.c
 create mode 100644 lib/test_siphash.c

diff --git a/Documentation/siphash.txt b/Documentation/siphash.txt
new file mode 100644
index 0000000000000..e8e6ddbbaab47
--- /dev/null
+++ b/Documentation/siphash.txt
@@ -0,0 +1,100 @@
+         SipHash - a short input PRF
+-----------------------------------------------
+Written by Jason A. Donenfeld <jason@zx2c4.com>
+
+SipHash is a cryptographically secure PRF -- a keyed hash function -- that
+performs very well for short inputs, hence the name. It was designed by
+cryptographers Daniel J. Bernstein and Jean-Philippe Aumasson. It is intended
+as a replacement for some uses of: `jhash`, `md5_transform`, `sha_transform`,
+and so forth.
+
+SipHash takes a secret key filled with randomly generated numbers and either
+an input buffer or several input integers. It spits out an integer that is
+indistinguishable from random. You may then use that integer as part of secure
+sequence numbers, secure cookies, or mask it off for use in a hash table.
+
+1. Generating a key
+
+Keys should always be generated from a cryptographically secure source of
+random numbers, either using get_random_bytes or get_random_once:
+
+siphash_key_t key;
+get_random_bytes(&key, sizeof(key));
+
+If you're not deriving your key from here, you're doing it wrong.
+
+2. Using the functions
+
+There are two variants of the function, one that takes a list of integers, and
+one that takes a buffer:
+
+u64 siphash(const void *data, size_t len, const siphash_key_t *key);
+
+And:
+
+u64 siphash_1u64(u64, const siphash_key_t *key);
+u64 siphash_2u64(u64, u64, const siphash_key_t *key);
+u64 siphash_3u64(u64, u64, u64, const siphash_key_t *key);
+u64 siphash_4u64(u64, u64, u64, u64, const siphash_key_t *key);
+u64 siphash_1u32(u32, const siphash_key_t *key);
+u64 siphash_2u32(u32, u32, const siphash_key_t *key);
+u64 siphash_3u32(u32, u32, u32, const siphash_key_t *key);
+u64 siphash_4u32(u32, u32, u32, u32, const siphash_key_t *key);
+
+If you pass the generic siphash function something of a constant length, it
+will constant fold at compile-time and automatically choose one of the
+optimized functions.
+
+3. Hashtable key function usage:
+
+struct some_hashtable {
+	DECLARE_HASHTABLE(hashtable, 8);
+	siphash_key_t key;
+};
+
+void init_hashtable(struct some_hashtable *table)
+{
+	get_random_bytes(&table->key, sizeof(table->key));
+}
+
+static inline hlist_head *some_hashtable_bucket(struct some_hashtable *table, struct interesting_input *input)
+{
+	return &table->hashtable[siphash(input, sizeof(*input), &table->key) & (HASH_SIZE(table->hashtable) - 1)];
+}
+
+You may then iterate like usual over the returned hash bucket.
+
+4. Security
+
+SipHash has a very high security margin, with its 128-bit key. So long as the
+key is kept secret, it is impossible for an attacker to guess the outputs of
+the function, even if being able to observe many outputs, since 2^128 outputs
+is significant.
+
+Linux implements the "2-4" variant of SipHash.
+
+5. Struct-passing Pitfalls
+
+Often times the XuY functions will not be large enough, and instead you'll
+want to pass a pre-filled struct to siphash. When doing this, it's important
+to always ensure the struct has no padding holes. The easiest way to do this
+is to simply arrange the members of the struct in descending order of size,
+and to use offsetendof() instead of sizeof() for getting the size. For
+performance reasons, if possible, it's probably a good thing to align the
+struct to the right boundary. Here's an example:
+
+const struct {
+	struct in6_addr saddr;
+	u32 counter;
+	u16 dport;
+} __aligned(SIPHASH_ALIGNMENT) combined = {
+	.saddr = *(struct in6_addr *)saddr,
+	.counter = counter,
+	.dport = dport
+};
+u64 h = siphash(&combined, offsetofend(typeof(combined), dport), &secret);
+
+6. Resources
+
+Read the SipHash paper if you're interested in learning more:
+https://131002.net/siphash/siphash.pdf
diff --git a/MAINTAINERS b/MAINTAINERS
index f4d4a5544dc10..20a31b3579299 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9749,6 +9749,13 @@ F:	arch/arm/mach-s3c24xx/mach-bast.c
 F:	arch/arm/mach-s3c24xx/bast-ide.c
 F:	arch/arm/mach-s3c24xx/bast-irq.c
 
+SIPHASH PRF ROUTINES
+M:	Jason A. Donenfeld <Jason@zx2c4.com>
+S:	Maintained
+F:	lib/siphash.c
+F:	lib/test_siphash.c
+F:	include/linux/siphash.h
+
 TI DAVINCI MACHINE SUPPORT
 M:	Sekhar Nori <nsekhar@ti.com>
 M:	Kevin Hilman <khilman@deeprootsystems.com>
diff --git a/include/linux/siphash.h b/include/linux/siphash.h
new file mode 100644
index 0000000000000..feeb29cd113ed
--- /dev/null
+++ b/include/linux/siphash.h
@@ -0,0 +1,85 @@
+/* Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.
+ *
+ * SipHash: a fast short-input PRF
+ * https://131002.net/siphash/
+ *
+ * This implementation is specifically for SipHash2-4.
+ */
+
+#ifndef _LINUX_SIPHASH_H
+#define _LINUX_SIPHASH_H
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+
+#define SIPHASH_ALIGNMENT __alignof__(u64)
+typedef struct {
+	u64 key[2];
+} siphash_key_t;
+
+u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key);
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key);
+#endif
+
+u64 siphash_1u64(const u64 a, const siphash_key_t *key);
+u64 siphash_2u64(const u64 a, const u64 b, const siphash_key_t *key);
+u64 siphash_3u64(const u64 a, const u64 b, const u64 c,
+		 const siphash_key_t *key);
+u64 siphash_4u64(const u64 a, const u64 b, const u64 c, const u64 d,
+		 const siphash_key_t *key);
+u64 siphash_1u32(const u32 a, const siphash_key_t *key);
+u64 siphash_3u32(const u32 a, const u32 b, const u32 c,
+		 const siphash_key_t *key);
+
+static inline u64 siphash_2u32(const u32 a, const u32 b,
+			       const siphash_key_t *key)
+{
+	return siphash_1u64((u64)b << 32 | a, key);
+}
+static inline u64 siphash_4u32(const u32 a, const u32 b, const u32 c,
+			       const u32 d, const siphash_key_t *key)
+{
+	return siphash_2u64((u64)b << 32 | a, (u64)d << 32 | c, key);
+}
+
+
+static inline u64 ___siphash_aligned(const __le64 *data, size_t len,
+				     const siphash_key_t *key)
+{
+	if (__builtin_constant_p(len) && len == 4)
+		return siphash_1u32(le32_to_cpup((const __le32 *)data), key);
+	if (__builtin_constant_p(len) && len == 8)
+		return siphash_1u64(le64_to_cpu(data[0]), key);
+	if (__builtin_constant_p(len) && len == 16)
+		return siphash_2u64(le64_to_cpu(data[0]), le64_to_cpu(data[1]),
+				    key);
+	if (__builtin_constant_p(len) && len == 24)
+		return siphash_3u64(le64_to_cpu(data[0]), le64_to_cpu(data[1]),
+				    le64_to_cpu(data[2]), key);
+	if (__builtin_constant_p(len) && len == 32)
+		return siphash_4u64(le64_to_cpu(data[0]), le64_to_cpu(data[1]),
+				    le64_to_cpu(data[2]), le64_to_cpu(data[3]),
+				    key);
+	return __siphash_aligned(data, len, key);
+}
+
+/**
+ * siphash - compute 64-bit siphash PRF value
+ * @data: buffer to hash
+ * @size: size of @data
+ * @key: the siphash key
+ */
+static inline u64 siphash(const void *data, size_t len,
+			  const siphash_key_t *key)
+{
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (!IS_ALIGNED((unsigned long)data, SIPHASH_ALIGNMENT))
+		return __siphash_unaligned(data, len, key);
+#endif
+	return ___siphash_aligned(data, len, key);
+}
+
+#endif /* _LINUX_SIPHASH_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index f0602beeba26d..fd1205a3dbdbc 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1706,6 +1706,16 @@ config TEST_RHASHTABLE
 
 	  If unsure, say N.
 
+config TEST_HASH
+	tristate "Perform selftest on hash functions"
+	default n
+	help
+	  Enable this option to test the kernel's siphash (<linux/siphash.h>)
+	  hash functions on boot (or module load).
+
+	  This is intended to help people writing architecture-specific
+	  optimized versions.  If unsure, say N.
+
 endmenu # runtime tests
 
 config PROVIDE_OHCI1394_DMA_INIT
diff --git a/lib/Makefile b/lib/Makefile
index cb4f6aa95013e..6c6c1fb2fa04e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o argv_split.o \
 	 proportions.o flex_proportions.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o seq_buf.o nmi_backtrace.o
+	 earlycpio.o seq_buf.o siphash.o nmi_backtrace.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
@@ -35,6 +35,7 @@ obj-$(CONFIG_TEST_HEXDUMP) += test-hexdump.o
 obj-y += kstrtox.o
 obj-$(CONFIG_TEST_BPF) += test_bpf.o
 obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
+obj-$(CONFIG_TEST_HASH) += test_siphash.o
 obj-$(CONFIG_TEST_KASAN) += test_kasan.o
 obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
 obj-$(CONFIG_TEST_LKM) += test_module.o
diff --git a/lib/siphash.c b/lib/siphash.c
new file mode 100644
index 0000000000000..c43cf406e71b2
--- /dev/null
+++ b/lib/siphash.c
@@ -0,0 +1,232 @@
+/* Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.
+ *
+ * SipHash: a fast short-input PRF
+ * https://131002.net/siphash/
+ *
+ * This implementation is specifically for SipHash2-4.
+ */
+
+#include <linux/siphash.h>
+#include <asm/unaligned.h>
+
+#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG == 64
+#include <linux/dcache.h>
+#include <asm/word-at-a-time.h>
+#endif
+
+#define SIPROUND \
+	do { \
+	v0 += v1; v1 = rol64(v1, 13); v1 ^= v0; v0 = rol64(v0, 32); \
+	v2 += v3; v3 = rol64(v3, 16); v3 ^= v2; \
+	v0 += v3; v3 = rol64(v3, 21); v3 ^= v0; \
+	v2 += v1; v1 = rol64(v1, 17); v1 ^= v2; v2 = rol64(v2, 32); \
+	} while (0)
+
+#define PREAMBLE(len) \
+	u64 v0 = 0x736f6d6570736575ULL; \
+	u64 v1 = 0x646f72616e646f6dULL; \
+	u64 v2 = 0x6c7967656e657261ULL; \
+	u64 v3 = 0x7465646279746573ULL; \
+	u64 b = ((u64)(len)) << 56; \
+	v3 ^= key->key[1]; \
+	v2 ^= key->key[0]; \
+	v1 ^= key->key[1]; \
+	v0 ^= key->key[0];
+
+#define POSTAMBLE \
+	v3 ^= b; \
+	SIPROUND; \
+	SIPROUND; \
+	v0 ^= b; \
+	v2 ^= 0xff; \
+	SIPROUND; \
+	SIPROUND; \
+	SIPROUND; \
+	SIPROUND; \
+	return (v0 ^ v1) ^ (v2 ^ v3);
+
+u64 __siphash_aligned(const void *data, size_t len, const siphash_key_t *key)
+{
+	const u8 *end = data + len - (len % sizeof(u64));
+	const u8 left = len & (sizeof(u64) - 1);
+	u64 m;
+	PREAMBLE(len)
+	for (; data != end; data += sizeof(u64)) {
+		m = le64_to_cpup(data);
+		v3 ^= m;
+		SIPROUND;
+		SIPROUND;
+		v0 ^= m;
+	}
+#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG == 64
+	if (left)
+		b |= le64_to_cpu((__force __le64)(load_unaligned_zeropad(data) &
+						  bytemask_from_count(left)));
+#else
+	switch (left) {
+	case 7: b |= ((u64)end[6]) << 48;
+	case 6: b |= ((u64)end[5]) << 40;
+	case 5: b |= ((u64)end[4]) << 32;
+	case 4: b |= le32_to_cpup(data); break;
+	case 3: b |= ((u64)end[2]) << 16;
+	case 2: b |= le16_to_cpup(data); break;
+	case 1: b |= end[0];
+	}
+#endif
+	POSTAMBLE
+}
+EXPORT_SYMBOL(__siphash_aligned);
+
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_t *key)
+{
+	const u8 *end = data + len - (len % sizeof(u64));
+	const u8 left = len & (sizeof(u64) - 1);
+	u64 m;
+	PREAMBLE(len)
+	for (; data != end; data += sizeof(u64)) {
+		m = get_unaligned_le64(data);
+		v3 ^= m;
+		SIPROUND;
+		SIPROUND;
+		v0 ^= m;
+	}
+#if defined(CONFIG_DCACHE_WORD_ACCESS) && BITS_PER_LONG == 64
+	if (left)
+		b |= le64_to_cpu((__force __le64)(load_unaligned_zeropad(data) &
+						  bytemask_from_count(left)));
+#else
+	switch (left) {
+	case 7: b |= ((u64)end[6]) << 48;
+	case 6: b |= ((u64)end[5]) << 40;
+	case 5: b |= ((u64)end[4]) << 32;
+	case 4: b |= get_unaligned_le32(end); break;
+	case 3: b |= ((u64)end[2]) << 16;
+	case 2: b |= get_unaligned_le16(end); break;
+	case 1: b |= end[0];
+	}
+#endif
+	POSTAMBLE
+}
+EXPORT_SYMBOL(__siphash_unaligned);
+#endif
+
+/**
+ * siphash_1u64 - compute 64-bit siphash PRF value of a u64
+ * @first: first u64
+ * @key: the siphash key
+ */
+u64 siphash_1u64(const u64 first, const siphash_key_t *key)
+{
+	PREAMBLE(8)
+	v3 ^= first;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= first;
+	POSTAMBLE
+}
+EXPORT_SYMBOL(siphash_1u64);
+
+/**
+ * siphash_2u64 - compute 64-bit siphash PRF value of 2 u64
+ * @first: first u64
+ * @second: second u64
+ * @key: the siphash key
+ */
+u64 siphash_2u64(const u64 first, const u64 second, const siphash_key_t *key)
+{
+	PREAMBLE(16)
+	v3 ^= first;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= first;
+	v3 ^= second;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= second;
+	POSTAMBLE
+}
+EXPORT_SYMBOL(siphash_2u64);
+
+/**
+ * siphash_3u64 - compute 64-bit siphash PRF value of 3 u64
+ * @first: first u64
+ * @second: second u64
+ * @third: third u64
+ * @key: the siphash key
+ */
+u64 siphash_3u64(const u64 first, const u64 second, const u64 third,
+		 const siphash_key_t *key)
+{
+	PREAMBLE(24)
+	v3 ^= first;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= first;
+	v3 ^= second;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= second;
+	v3 ^= third;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= third;
+	POSTAMBLE
+}
+EXPORT_SYMBOL(siphash_3u64);
+
+/**
+ * siphash_4u64 - compute 64-bit siphash PRF value of 4 u64
+ * @first: first u64
+ * @second: second u64
+ * @third: third u64
+ * @forth: forth u64
+ * @key: the siphash key
+ */
+u64 siphash_4u64(const u64 first, const u64 second, const u64 third,
+		 const u64 forth, const siphash_key_t *key)
+{
+	PREAMBLE(32)
+	v3 ^= first;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= first;
+	v3 ^= second;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= second;
+	v3 ^= third;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= third;
+	v3 ^= forth;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= forth;
+	POSTAMBLE
+}
+EXPORT_SYMBOL(siphash_4u64);
+
+u64 siphash_1u32(const u32 first, const siphash_key_t *key)
+{
+	PREAMBLE(4)
+	b |= first;
+	POSTAMBLE
+}
+EXPORT_SYMBOL(siphash_1u32);
+
+u64 siphash_3u32(const u32 first, const u32 second, const u32 third,
+		 const siphash_key_t *key)
+{
+	u64 combined = (u64)second << 32 | first;
+	PREAMBLE(12)
+	v3 ^= combined;
+	SIPROUND;
+	SIPROUND;
+	v0 ^= combined;
+	b |= third;
+	POSTAMBLE
+}
+EXPORT_SYMBOL(siphash_3u32);
diff --git a/lib/test_siphash.c b/lib/test_siphash.c
new file mode 100644
index 0000000000000..d972acfc15e4a
--- /dev/null
+++ b/lib/test_siphash.c
@@ -0,0 +1,131 @@
+/* Test cases for siphash.c
+ *
+ * Copyright (C) 2016 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.
+ *
+ * SipHash: a fast short-input PRF
+ * https://131002.net/siphash/
+ *
+ * This implementation is specifically for SipHash2-4.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/siphash.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+
+/* Test vectors taken from official reference source available at:
+ *     https://131002.net/siphash/siphash24.c
+ */
+
+static const siphash_key_t test_key_siphash =
+	{{ 0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL }};
+
+static const u64 test_vectors_siphash[64] = {
+	0x726fdb47dd0e0e31ULL, 0x74f839c593dc67fdULL, 0x0d6c8009d9a94f5aULL,
+	0x85676696d7fb7e2dULL, 0xcf2794e0277187b7ULL, 0x18765564cd99a68dULL,
+	0xcbc9466e58fee3ceULL, 0xab0200f58b01d137ULL, 0x93f5f5799a932462ULL,
+	0x9e0082df0ba9e4b0ULL, 0x7a5dbbc594ddb9f3ULL, 0xf4b32f46226bada7ULL,
+	0x751e8fbc860ee5fbULL, 0x14ea5627c0843d90ULL, 0xf723ca908e7af2eeULL,
+	0xa129ca6149be45e5ULL, 0x3f2acc7f57c29bdbULL, 0x699ae9f52cbe4794ULL,
+	0x4bc1b3f0968dd39cULL, 0xbb6dc91da77961bdULL, 0xbed65cf21aa2ee98ULL,
+	0xd0f2cbb02e3b67c7ULL, 0x93536795e3a33e88ULL, 0xa80c038ccd5ccec8ULL,
+	0xb8ad50c6f649af94ULL, 0xbce192de8a85b8eaULL, 0x17d835b85bbb15f3ULL,
+	0x2f2e6163076bcfadULL, 0xde4daaaca71dc9a5ULL, 0xa6a2506687956571ULL,
+	0xad87a3535c49ef28ULL, 0x32d892fad841c342ULL, 0x7127512f72f27cceULL,
+	0xa7f32346f95978e3ULL, 0x12e0b01abb051238ULL, 0x15e034d40fa197aeULL,
+	0x314dffbe0815a3b4ULL, 0x027990f029623981ULL, 0xcadcd4e59ef40c4dULL,
+	0x9abfd8766a33735cULL, 0x0e3ea96b5304a7d0ULL, 0xad0c42d6fc585992ULL,
+	0x187306c89bc215a9ULL, 0xd4a60abcf3792b95ULL, 0xf935451de4f21df2ULL,
+	0xa9538f0419755787ULL, 0xdb9acddff56ca510ULL, 0xd06c98cd5c0975ebULL,
+	0xe612a3cb9ecba951ULL, 0xc766e62cfcadaf96ULL, 0xee64435a9752fe72ULL,
+	0xa192d576b245165aULL, 0x0a8787bf8ecb74b2ULL, 0x81b3e73d20b49b6fULL,
+	0x7fa8220ba3b2eceaULL, 0x245731c13ca42499ULL, 0xb78dbfaf3a8d83bdULL,
+	0xea1ad565322a1a0bULL, 0x60e61c23a3795013ULL, 0x6606d7e446282b93ULL,
+	0x6ca4ecb15c5f91e1ULL, 0x9f626da15c9625f3ULL, 0xe51b38608ef25f57ULL,
+	0x958a324ceb064572ULL
+};
+
+static int __init siphash_test_init(void)
+{
+	u8 in[64] __aligned(SIPHASH_ALIGNMENT);
+	u8 in_unaligned[65] __aligned(SIPHASH_ALIGNMENT);
+	u8 i;
+	int ret = 0;
+
+	for (i = 0; i < 64; ++i) {
+		in[i] = i;
+		in_unaligned[i + 1] = i;
+		if (siphash(in, i, &test_key_siphash) !=
+						test_vectors_siphash[i]) {
+			pr_info("siphash self-test aligned %u: FAIL\n", i + 1);
+			ret = -EINVAL;
+		}
+		if (siphash(in_unaligned + 1, i, &test_key_siphash) !=
+						test_vectors_siphash[i]) {
+			pr_info("siphash self-test unaligned %u: FAIL\n", i + 1);
+			ret = -EINVAL;
+		}
+	}
+	if (siphash_1u64(0x0706050403020100ULL, &test_key_siphash) !=
+						test_vectors_siphash[8]) {
+		pr_info("siphash self-test 1u64: FAIL\n");
+		ret = -EINVAL;
+	}
+	if (siphash_2u64(0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL,
+			 &test_key_siphash) != test_vectors_siphash[16]) {
+		pr_info("siphash self-test 2u64: FAIL\n");
+		ret = -EINVAL;
+	}
+	if (siphash_3u64(0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL,
+			 0x1716151413121110ULL, &test_key_siphash) !=
+						test_vectors_siphash[24]) {
+		pr_info("siphash self-test 3u64: FAIL\n");
+		ret = -EINVAL;
+	}
+	if (siphash_4u64(0x0706050403020100ULL, 0x0f0e0d0c0b0a0908ULL,
+			 0x1716151413121110ULL, 0x1f1e1d1c1b1a1918ULL,
+			 &test_key_siphash) != test_vectors_siphash[32]) {
+		pr_info("siphash self-test 4u64: FAIL\n");
+		ret = -EINVAL;
+	}
+	if (siphash_1u32(0x03020100U, &test_key_siphash) !=
+						test_vectors_siphash[4]) {
+		pr_info("siphash self-test 1u32: FAIL\n");
+		ret = -EINVAL;
+	}
+	if (siphash_2u32(0x03020100U, 0x07060504U, &test_key_siphash) !=
+						test_vectors_siphash[8]) {
+		pr_info("siphash self-test 2u32: FAIL\n");
+		ret = -EINVAL;
+	}
+	if (siphash_3u32(0x03020100U, 0x07060504U,
+			 0x0b0a0908U, &test_key_siphash) !=
+						test_vectors_siphash[12]) {
+		pr_info("siphash self-test 3u32: FAIL\n");
+		ret = -EINVAL;
+	}
+	if (siphash_4u32(0x03020100U, 0x07060504U,
+			 0x0b0a0908U, 0x0f0e0d0cU, &test_key_siphash) !=
+						test_vectors_siphash[16]) {
+		pr_info("siphash self-test 4u32: FAIL\n");
+		ret = -EINVAL;
+	}
+	if (!ret)
+		pr_info("self-tests: pass\n");
+	return ret;
+}
+
+static void __exit siphash_test_exit(void)
+{
+}
+
+module_init(siphash_test_init);
+module_exit(siphash_test_exit);
+
+MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.20.1



