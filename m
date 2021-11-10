Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499A244C765
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 19:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbhKJSuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 13:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232895AbhKJSte (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Nov 2021 13:49:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D7D0611C9;
        Wed, 10 Nov 2021 18:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636569990;
        bh=/VzR6fTrF7cg/rn0LeHhBXa/700fkIa8fGD0E1bGZoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkuDnfsLyY3KzeTM44Rl73LYAbYc/XVkfpAHzy1+hVN/VNG/fQLVK9nLxSyhStxtc
         jQNE6iLthA+HXC6rlKHpQIhx359sIIGLHWaRR+ihisKkydjYQ67EkIu6R8BSEqB4uf
         G0612FHlpxs+VY6L3Ka7wJSVhO154yAuGZA+W4+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Zubin Mithra <zsm@chromium.org>
Subject: [PATCH 4.19 01/16] block: introduce multi-page bvec helpers
Date:   Wed, 10 Nov 2021 19:43:34 +0100
Message-Id: <20211110182002.041203616@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110182001.994215976@linuxfoundation.org>
References: <20211110182001.994215976@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 3d75ca0adef4280650c6690a0c4702a74a6f3c95 upstream.

This patch introduces helpers of 'mp_bvec_iter_*' for multi-page bvec
support.

The introduced helpers treate one bvec as real multi-page segment,
which may include more than one pages.

The existed helpers of bvec_iter_* are interfaces for supporting current
bvec iterator which is thought as single-page by drivers, fs, dm and
etc. These introduced helpers will build single-page bvec in flight, so
this way won't break current bio/bvec users, which needn't any change.

Follows some multi-page bvec background:

- bvecs stored in bio->bi_io_vec is always multi-page style

- bvec(struct bio_vec) represents one physically contiguous I/O
  buffer, now the buffer may include more than one page after
  multi-page bvec is supported, and all these pages represented
  by one bvec is physically contiguous. Before multi-page bvec
  support, at most one page is included in one bvec, we call it
  single-page bvec.

- .bv_page of the bvec points to the 1st page in the multi-page bvec

- .bv_offset of the bvec is the offset of the buffer in the bvec

The effect on the current drivers/filesystem/dm/bcache/...:

- almost everyone supposes that one bvec only includes one single
  page, so we keep the sp interface not changed, for example,
  bio_for_each_segment() still returns single-page bvec

- bio_for_each_segment_all() will return single-page bvec too

- during iterating, iterator variable(struct bvec_iter) is always
  updated in multi-page bvec style, and bvec_iter_advance() is kept
  not changed

- returned(copied) single-page bvec is built in flight by bvec
  helpers from the stored multi-page bvec

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Omar Sandoval <osandov@fb.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bvec.h |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/mm.h>
 
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
@@ -52,16 +53,39 @@ struct bvec_iter {
  */
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
-#define bvec_iter_page(bvec, iter)				\
+/* multi-page (mp_bvec) helpers */
+#define mp_bvec_iter_page(bvec, iter)				\
 	(__bvec_iter_bvec((bvec), (iter))->bv_page)
 
-#define bvec_iter_len(bvec, iter)				\
+#define mp_bvec_iter_len(bvec, iter)				\
 	min((iter).bi_size,					\
 	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
 
-#define bvec_iter_offset(bvec, iter)				\
+#define mp_bvec_iter_offset(bvec, iter)				\
 	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
 
+#define mp_bvec_iter_page_idx(bvec, iter)			\
+	(mp_bvec_iter_offset((bvec), (iter)) / PAGE_SIZE)
+
+#define mp_bvec_iter_bvec(bvec, iter)				\
+((struct bio_vec) {						\
+	.bv_page	= mp_bvec_iter_page((bvec), (iter)),	\
+	.bv_len		= mp_bvec_iter_len((bvec), (iter)),	\
+	.bv_offset	= mp_bvec_iter_offset((bvec), (iter)),	\
+})
+
+/* For building single-page bvec in flight */
+ #define bvec_iter_offset(bvec, iter)				\
+	(mp_bvec_iter_offset((bvec), (iter)) % PAGE_SIZE)
+
+#define bvec_iter_len(bvec, iter)				\
+	min_t(unsigned, mp_bvec_iter_len((bvec), (iter)),		\
+	      PAGE_SIZE - bvec_iter_offset((bvec), (iter)))
+
+#define bvec_iter_page(bvec, iter)				\
+	nth_page(mp_bvec_iter_page((bvec), (iter)),		\
+		 mp_bvec_iter_page_idx((bvec), (iter)))
+
 #define bvec_iter_bvec(bvec, iter)				\
 ((struct bio_vec) {						\
 	.bv_page	= bvec_iter_page((bvec), (iter)),	\


