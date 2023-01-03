Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5789B65BBB5
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 09:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbjACIPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 03:15:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236994AbjACIPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 03:15:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C06DE86
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 00:14:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35A4F611DD
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 08:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC43C433D2;
        Tue,  3 Jan 2023 08:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672733694;
        bh=bLQMNidN0VK7ZnObnOkDFRxYFpp+vvWQ0Wrj3m7fxpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhBnVZdcA/cAI96lnFikmy2l0tIBCyax30GtxNajSUD6HtQNqfGPpywfpgnMDAYQF
         B8QdsFZ5CD9oREz17LQVHWCHyuv4ZTwQIl2BWyOtFMeMU87sINV4NfWmOXuqKtf7yI
         +IPO2wQiUfpUXjG2jJ/Zkqrp5kTqtMzho8JMLdGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 02/63] iov_iter: add helper to save iov_iter state
Date:   Tue,  3 Jan 2023 09:13:32 +0100
Message-Id: <20230103081308.699550936@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230103081308.548338576@linuxfoundation.org>
References: <20230103081308.548338576@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 8fb0f47a9d7acf620d0fd97831b69da9bc5e22ed ]

In an ideal world, when someone is passed an iov_iter and returns X bytes,
then X bytes would have been consumed/advanced from the iov_iter. But we
have use cases that always consume the entire iterator, a few examples
of that are iomap and bdev O_DIRECT. This means we cannot rely on the
state of the iov_iter once we've called ->read_iter() or ->write_iter().

This would be easier if we didn't always have to deal with truncate of
the iov_iter, as rewinding would be trivial without that. We recently
added a commit to track the truncate state, but that grew the iov_iter
by 8 bytes and wasn't the best solution.

Implement a helper to save enough of the iov_iter state to sanely restore
it after we've called the read/write iterator helpers. This currently
only works for IOVEC/BVEC/KVEC as that's all we need, support for other
iterator types are left as an exercise for the reader.

Link: https://lore.kernel.org/linux-fsdevel/CAHk-=wiacKV4Gh-MYjteU0LwNBSGpWrK-Ov25HdqB1ewinrFPg@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/uio.h |   15 +++++++++++++++
 lib/iov_iter.c      |   52 +++++++++++++++++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 19 deletions(-)

--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -26,6 +26,12 @@ enum iter_type {
 	ITER_DISCARD = 64,
 };
 
+struct iov_iter_state {
+	size_t iov_offset;
+	size_t count;
+	unsigned long nr_segs;
+};
+
 struct iov_iter {
 	/*
 	 * Bit 0 is the read/write bit, set if we're writing.
@@ -55,6 +61,14 @@ static inline enum iter_type iov_iter_ty
 	return i->type & ~(READ | WRITE);
 }
 
+static inline void iov_iter_save_state(struct iov_iter *iter,
+				       struct iov_iter_state *state)
+{
+	state->iov_offset = iter->iov_offset;
+	state->count = iter->count;
+	state->nr_segs = iter->nr_segs;
+}
+
 static inline bool iter_is_iovec(const struct iov_iter *i)
 {
 	return iov_iter_type(i) == ITER_IOVEC;
@@ -226,6 +240,7 @@ ssize_t iov_iter_get_pages(struct iov_it
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
+void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags);
 
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1836,24 +1836,38 @@ int import_single_range(int rw, void __u
 }
 EXPORT_SYMBOL(import_single_range);
 
-int iov_iter_for_each_range(struct iov_iter *i, size_t bytes,
-			    int (*f)(struct kvec *vec, void *context),
-			    void *context)
+/**
+ * iov_iter_restore() - Restore a &struct iov_iter to the same state as when
+ *     iov_iter_save_state() was called.
+ *
+ * @i: &struct iov_iter to restore
+ * @state: state to restore from
+ *
+ * Used after iov_iter_save_state() to bring restore @i, if operations may
+ * have advanced it.
+ *
+ * Note: only works on ITER_IOVEC, ITER_BVEC, and ITER_KVEC
+ */
+void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
 {
-	struct kvec w;
-	int err = -EINVAL;
-	if (!bytes)
-		return 0;
-
-	iterate_all_kinds(i, bytes, v, -EINVAL, ({
-		w.iov_base = kmap(v.bv_page) + v.bv_offset;
-		w.iov_len = v.bv_len;
-		err = f(&w, context);
-		kunmap(v.bv_page);
-		err;}), ({
-		w = v;
-		err = f(&w, context);})
-	)
-	return err;
+	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i)) &&
+			 !iov_iter_is_kvec(i))
+		return;
+	i->iov_offset = state->iov_offset;
+	i->count = state->count;
+	/*
+	 * For the *vec iters, nr_segs + iov is constant - if we increment
+	 * the vec, then we also decrement the nr_segs count. Hence we don't
+	 * need to track both of these, just one is enough and we can deduct
+	 * the other from that. ITER_KVEC and ITER_IOVEC are the same struct
+	 * size, so we can just increment the iov pointer as they are unionzed.
+	 * ITER_BVEC _may_ be the same size on some archs, but on others it is
+	 * not. Be safe and handle it separately.
+	 */
+	BUILD_BUG_ON(sizeof(struct iovec) != sizeof(struct kvec));
+	if (iov_iter_is_bvec(i))
+		i->bvec -= state->nr_segs - i->nr_segs;
+	else
+		i->iov -= state->nr_segs - i->nr_segs;
+	i->nr_segs = state->nr_segs;
 }
-EXPORT_SYMBOL(iov_iter_for_each_range);


