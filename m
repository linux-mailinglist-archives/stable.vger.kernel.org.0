Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD8D4D886
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfFTSFA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727948AbfFTSE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:04:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E59742168B;
        Thu, 20 Jun 2019 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053897;
        bh=xU+BtTdGagfZ3V0Qjo0BVdC7AiKUCZEwsrR52cvNAuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPsn5gFiJaUFKWRir4LQTtOhE99JzakWSnuXIJxlHxjOaJ2vP4ixdznom0vTRa9jV
         42XGcAbc/ZLdUczG3UlmnAmXMvG4sp+iRSPYZnxPGL/HQOkkwBr41vTq8y2g/c3Wli
         VDDnjWfZI2I4/Q/PNveW1QnuvXE/P91IPOT6vFlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Rolf Fokkens <rolf@rolffokkens.nl>,
        Pierre JUHEN <pierre.juhen@orange.fr>,
        Shenghui Wang <shhuiw@foxmail.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Nix <nix@esperi.org.uk>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 065/117] bcache: fix stack corruption by PRECEDING_KEY()
Date:   Thu, 20 Jun 2019 19:56:39 +0200
Message-Id: <20190620174356.726325530@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bset.c |   16 +++++++++++++---
 drivers/md/bcache/bset.h |   34 ++++++++++++++++++++--------------
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


