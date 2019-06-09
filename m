Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD7F3AC53
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 00:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfFIWPF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 18:15:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:36578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729306AbfFIWPF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 18:15:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4966ADD2;
        Sun,  9 Jun 2019 22:15:02 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        rolf@rolffokkens.nl, pierre.juhen@orange.fr,
        Coly Li <colyli@suse.de>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, stable@vger.kernel.org
Subject: [PATCH 1/2] bcache: fix stack corruption by PRECEDING_KEY()
Date:   Mon, 10 Jun 2019 06:13:34 +0800
Message-Id: <20190609221335.24616-2-colyli@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190609221335.24616-1-colyli@suse.de>
References: <20190609221335.24616-1-colyli@suse.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
Changlog:
V2: Fix a pointer assignment problem in preceding_key(), which is
    pointed by Rolf Fokkens and Pierre JUHEN.
V1: Initial RFC patch for review and comment.

 drivers/md/bcache/bset.c | 16 +++++++++++++---
 drivers/md/bcache/bset.h | 34 ++++++++++++++++++++--------------
 2 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 8f07fa6e1739..268f1b685084 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -887,12 +887,22 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
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
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index bac76aabca6d..c71365e7c1fa 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -434,20 +434,26 @@ static inline bool bch_cut_back(const struct bkey *where, struct bkey *k)
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
-- 
2.16.4

