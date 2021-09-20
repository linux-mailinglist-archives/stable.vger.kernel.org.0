Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7C8412014
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349527AbhITRs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:48:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353290AbhITRqe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:46:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BA8660F5D;
        Mon, 20 Sep 2021 17:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157824;
        bh=zmujfcg/S43l/GipazkgY5u9+IvjFg27fVvmmnAhJOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sjUC2oD9Q841TThuggiwRyQE/9TvoFwwA+zwJ7xQBohHfbOaeOV81fSQt3t60mQ05
         bT1J0Y8Vw+woSUew5Sv06w1+Skdls328BS2eIvdRACN0g8uQq0rM4KEFsFF0ElnYk8
         MsIsxnJrkAdNiKYCaNzcWh1+39WhWudH1AhgF8Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Jeff Layton <jlayton@redhat.com>, linux-cachefs@redhat.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 167/293] fscache: Fix cookie key hashing
Date:   Mon, 20 Sep 2021 18:42:09 +0200
Message-Id: <20210920163939.007798664@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 35b72573e977ed6b18b094136a4fa3e0ffb13603 ]

The current hash algorithm used for hashing cookie keys is really bad,
producing almost no dispersion (after a test kernel build, ~30000 files
were split over just 18 out of the 32768 hash buckets).

Borrow the full_name_hash() hash function into fscache to do the hashing
for cookie keys and, in the future, volume keys.

I don't want to use full_name_hash() as-is because I want the hash value to
be consistent across arches and over time as the hash value produced may
get used on disk.

I can also optimise parts of it away as the key will always be a padded
array of aligned 32-bit words.

Fixes: ec0328e46d6e ("fscache: Maintain a catalogue of allocated cookies")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
cc: linux-cachefs@redhat.com
Link: https://lore.kernel.org/r/162431201844.2908479.8293647220901514696.stgit@warthog.procyon.org.uk/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fscache/cookie.c   | 14 +-------------
 fs/fscache/internal.h |  2 ++
 fs/fscache/main.c     | 39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index c550512ce335..2ff05adfc22a 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -78,10 +78,8 @@ void fscache_free_cookie(struct fscache_cookie *cookie)
 static int fscache_set_key(struct fscache_cookie *cookie,
 			   const void *index_key, size_t index_key_len)
 {
-	unsigned long long h;
 	u32 *buf;
 	int bufs;
-	int i;
 
 	bufs = DIV_ROUND_UP(index_key_len, sizeof(*buf));
 
@@ -95,17 +93,7 @@ static int fscache_set_key(struct fscache_cookie *cookie,
 	}
 
 	memcpy(buf, index_key, index_key_len);
-
-	/* Calculate a hash and combine this with the length in the first word
-	 * or first half word
-	 */
-	h = (unsigned long)cookie->parent;
-	h += index_key_len + cookie->type;
-
-	for (i = 0; i < bufs; i++)
-		h += buf[i];
-
-	cookie->key_hash = h ^ (h >> 32);
+	cookie->key_hash = fscache_hash(0, buf, bufs);
 	return 0;
 }
 
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index d6209022e965..cc87288a5448 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -101,6 +101,8 @@ extern struct workqueue_struct *fscache_object_wq;
 extern struct workqueue_struct *fscache_op_wq;
 DECLARE_PER_CPU(wait_queue_head_t, fscache_object_cong_wait);
 
+extern unsigned int fscache_hash(unsigned int salt, unsigned int *data, unsigned int n);
+
 static inline bool fscache_object_congested(void)
 {
 	return workqueue_congested(WORK_CPU_UNBOUND, fscache_object_wq);
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 30ad89db1efc..aa49234e9520 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -98,6 +98,45 @@ static struct ctl_table fscache_sysctls_root[] = {
 };
 #endif
 
+/*
+ * Mixing scores (in bits) for (7,20):
+ * Input delta: 1-bit      2-bit
+ * 1 round:     330.3     9201.6
+ * 2 rounds:   1246.4    25475.4
+ * 3 rounds:   1907.1    31295.1
+ * 4 rounds:   2042.3    31718.6
+ * Perfect:    2048      31744
+ *            (32*64)   (32*31/2 * 64)
+ */
+#define HASH_MIX(x, y, a)	\
+	(	x ^= (a),	\
+	y ^= x,	x = rol32(x, 7),\
+	x += y,	y = rol32(y,20),\
+	y *= 9			)
+
+static inline unsigned int fold_hash(unsigned long x, unsigned long y)
+{
+	/* Use arch-optimized multiply if one exists */
+	return __hash_32(y ^ __hash_32(x));
+}
+
+/*
+ * Generate a hash.  This is derived from full_name_hash(), but we want to be
+ * sure it is arch independent and that it doesn't change as bits of the
+ * computed hash value might appear on disk.  The caller also guarantees that
+ * the hashed data will be a series of aligned 32-bit words.
+ */
+unsigned int fscache_hash(unsigned int salt, unsigned int *data, unsigned int n)
+{
+	unsigned int a, x = 0, y = salt;
+
+	for (; n; n--) {
+		a = *data++;
+		HASH_MIX(x, y, a);
+	}
+	return fold_hash(x, y);
+}
+
 /*
  * initialise the fs caching module
  */
-- 
2.30.2



