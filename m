Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 016C8C91B5
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729955AbfJBTLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:11:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35754 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729292AbfJBTIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:15 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyr-00036K-Sm; Wed, 02 Oct 2019 20:08:09 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyo-0003eL-Tt; Wed, 02 Oct 2019 20:08:06 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Rolf Fokkens" <rolf@rolffokkens.nl>,
        "Shenghui Wang" <shhuiw@foxmail.com>,
        "Kent Overstreet" <kent.overstreet@gmail.com>,
        "Pierre JUHEN" <pierre.juhen@orange.fr>,
        "Coly Li" <colyli@suse.de>, "Jens Axboe" <axboe@kernel.dk>,
        "Nix" <nix@esperi.org.uk>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.30556179@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 56/87] bcache: fix stack corruption by PRECEDING_KEY()
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Coly Li <colyli@suse.de>

commit 31b90956b124240aa8c63250243ae1a53585c5e2 upstream.

Recently people report bcache code compiled with gcc9 is broken, one of
the buggy behavior I observe is that two adjacent 4KB I/Os should merge
into one but they don't. Finally it turns out to be a stack corruption
caused by macro PRECEDING_KEY().

See how PRECEDING_KEY() is defined in bset.h,
437 #define PRECEDING_KEY(_k)                                       \
438 ({                                                              \
439         struct bkey *_ret = NULL;                               \
440                                                                 \
441         if (KEY_INODE(_k) || KEY_OFFSET(_k)) {                  \
442                 _ret = &KEY(KEY_INODE(_k), KEY_OFFSET(_k), 0);  \
443                                                                 \
444                 if (!_ret->low)                                 \
445                         _ret->high--;                           \
446                 _ret->low--;                                    \
447         }                                                       \
448                                                                 \
449         _ret;                                                   \
450 })

At line 442, _ret points to address of a on-stack variable combined by
KEY(), the life range of this on-stack variable is in line 442-446,
once _ret is returned to bch_btree_insert_key(), the returned address
points to an invalid stack address and this address is overwritten in
the following called bch_btree_iter_init(). Then argument 'search' of
bch_btree_iter_init() points to some address inside stackframe of
bch_btree_iter_init(), exact address depends on how the compiler
allocates stack space. Now the stack is corrupted.

Fixes: 0eacac22034c ("bcache: PRECEDING_KEY()")
Signed-off-by: Coly Li <colyli@suse.de>
Reviewed-by: Rolf Fokkens <rolf@rolffokkens.nl>
Reviewed-by: Pierre JUHEN <pierre.juhen@orange.fr>
Tested-by: Shenghui Wang <shhuiw@foxmail.com>
Tested-by: Pierre JUHEN <pierre.juhen@orange.fr>
Cc: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Nix <nix@esperi.org.uk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/bcache/bset.c | 16 +++++++++++++---
 drivers/md/bcache/bset.h | 34 ++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 17 deletions(-)

--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -823,12 +823,22 @@ unsigned bch_btree_insert_key(struct btr
 	struct bset *i = bset_tree_last(b)->data;
 	struct bkey *m, *prev = NULL;
 	struct btree_iter iter;
+	struct bkey preceding_key_on_stack = ZERO_KEY;
+	struct bkey *preceding_key_p = &preceding_key_on_stack;
 
 	BUG_ON(b->ops->is_extents && !KEY_SIZE(k));
 
-	m = bch_btree_iter_init(b, &iter, b->ops->is_extents
-				? PRECEDING_KEY(&START_KEY(k))
-				: PRECEDING_KEY(k));
+	/*
+	 * If k has preceding key, preceding_key_p will be set to address
+	 *  of k's preceding key; otherwise preceding_key_p will be set
+	 * to NULL inside preceding_key().
+	 */
+	if (b->ops->is_extents)
+		preceding_key(&START_KEY(k), &preceding_key_p);
+	else
+		preceding_key(k, &preceding_key_p);
+
+	m = bch_btree_iter_init(b, &iter, preceding_key_p);
 
 	if (b->ops->insert_fixup(b, k, &iter, replace_key))
 		return status;
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -417,20 +417,26 @@ static inline bool bch_cut_back(const st
 	return __bch_cut_back(where, k);
 }
 
-#define PRECEDING_KEY(_k)					\
-({								\
-	struct bkey *_ret = NULL;				\
-								\
-	if (KEY_INODE(_k) || KEY_OFFSET(_k)) {			\
-		_ret = &KEY(KEY_INODE(_k), KEY_OFFSET(_k), 0);	\
-								\
-		if (!_ret->low)					\
-			_ret->high--;				\
-		_ret->low--;					\
-	}							\
-								\
-	_ret;							\
-})
+/*
+ * Pointer '*preceding_key_p' points to a memory object to store preceding
+ * key of k. If the preceding key does not exist, set '*preceding_key_p' to
+ * NULL. So the caller of preceding_key() needs to take care of memory
+ * which '*preceding_key_p' pointed to before calling preceding_key().
+ * Currently the only caller of preceding_key() is bch_btree_insert_key(),
+ * and it points to an on-stack variable, so the memory release is handled
+ * by stackframe itself.
+ */
+static inline void preceding_key(struct bkey *k, struct bkey **preceding_key_p)
+{
+	if (KEY_INODE(k) || KEY_OFFSET(k)) {
+		(**preceding_key_p) = KEY(KEY_INODE(k), KEY_OFFSET(k), 0);
+		if (!(*preceding_key_p)->low)
+			(*preceding_key_p)->high--;
+		(*preceding_key_p)->low--;
+	} else {
+		(*preceding_key_p) = NULL;
+	}
+}
 
 static inline bool bch_ptr_invalid(struct btree_keys *b, const struct bkey *k)
 {

