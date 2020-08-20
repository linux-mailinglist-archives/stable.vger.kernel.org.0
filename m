Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925B924BD83
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgHTJiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728871AbgHTJiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF5A020724;
        Thu, 20 Aug 2020 09:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916288;
        bh=OtKfn/HlWE2VGNAHgPxYKsaEjKVIIibS5w9DplZNHZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EV6VwD5wiDNZeSetZa6kNrQBmEhTA3H0pyZhcSlspYTwwcm3KyLROL/hpeAEtL4gY
         JSqKqFxTyHFB/gL0yPTO8KQ+EEJ0Yr+GL0f4Pz8UIbd8UwY5126fPXKquPeluv11aG
         SMMsdKPUx5dVkbuCeEO91sNS9hW1+J+AxSGjyOj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 059/204] bcache: allocate meta data pages as compound pages
Date:   Thu, 20 Aug 2020 11:19:16 +0200
Message-Id: <20200820091609.217109868@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 5fe48867856367142d91a82f2cbf7a57a24cbb70 upstream.

There are some meta data of bcache are allocated by multiple pages,
and they are used as bio bv_page for I/Os to the cache device. for
example cache_set->uuids, cache->disk_buckets, journal_write->data,
bset_tree->data.

For such meta data memory, all the allocated pages should be treated
as a single memory block. Then the memory management and underlying I/O
code can treat them more clearly.

This patch adds __GFP_COMP flag to all the location allocating >0 order
pages for the above mentioned meta data. Then their pages are treated
as compound pages now.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/bset.c    |    2 +-
 drivers/md/bcache/btree.c   |    2 +-
 drivers/md/bcache/journal.c |    4 ++--
 drivers/md/bcache/super.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -322,7 +322,7 @@ int bch_btree_keys_alloc(struct btree_ke
 
 	b->page_order = page_order;
 
-	t->data = (void *) __get_free_pages(gfp, b->page_order);
+	t->data = (void *) __get_free_pages(__GFP_COMP|gfp, b->page_order);
 	if (!t->data)
 		goto err;
 
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -785,7 +785,7 @@ int bch_btree_cache_alloc(struct cache_s
 	mutex_init(&c->verify_lock);
 
 	c->verify_ondisk = (void *)
-		__get_free_pages(GFP_KERNEL, ilog2(bucket_pages(c)));
+		__get_free_pages(GFP_KERNEL|__GFP_COMP, ilog2(bucket_pages(c)));
 
 	c->verify_data = mca_bucket_alloc(c, &ZERO_KEY, GFP_KERNEL);
 
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -999,8 +999,8 @@ int bch_journal_alloc(struct cache_set *
 	j->w[1].c = c;
 
 	if (!(init_fifo(&j->pin, JOURNAL_PIN, GFP_KERNEL)) ||
-	    !(j->w[0].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)) ||
-	    !(j->w[1].data = (void *) __get_free_pages(GFP_KERNEL, JSET_BITS)))
+	    !(j->w[0].data = (void *) __get_free_pages(GFP_KERNEL|__GFP_COMP, JSET_BITS)) ||
+	    !(j->w[1].data = (void *) __get_free_pages(GFP_KERNEL|__GFP_COMP, JSET_BITS)))
 		return -ENOMEM;
 
 	return 0;
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1775,7 +1775,7 @@ void bch_cache_set_unregister(struct cac
 }
 
 #define alloc_bucket_pages(gfp, c)			\
-	((void *) __get_free_pages(__GFP_ZERO|gfp, ilog2(bucket_pages(c))))
+	((void *) __get_free_pages(__GFP_ZERO|__GFP_COMP|gfp, ilog2(bucket_pages(c))))
 
 struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 {


