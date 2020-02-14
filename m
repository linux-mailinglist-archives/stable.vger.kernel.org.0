Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D493415EB0E
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391906AbgBNRSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 12:18:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391714AbgBNQLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1887624695;
        Fri, 14 Feb 2020 16:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696667;
        bh=6T5ViOIkP+d7Ypkb1zR2zObz0C6HvxruVNw+UyKl8xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f6UZO0OXuczz1X+20rBpwuLij8wYDAjoMFad/ItOdbaULTLV9VmzXXaSlXqUUNVyi
         Lh8LCFusyyE8OoGXwySxM7OhrwggSHHtZ/1huaocb64kgHyNhzv3BJjdNgafriDZ0V
         80A0j6RP1+VOBIyKmoC0B4h8SvP1XQ/xYOmbJ4K0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Coly Li <colyli@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-bcache@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 438/459] bcache: fix incorrect data type usage in btree_flush_write()
Date:   Fri, 14 Feb 2020 11:01:28 -0500
Message-Id: <20200214160149.11681-438-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

[ Upstream commit d1c3cc34f5a78b38d2b809b289d912c3560545df ]

Dan Carpenter points out that from commit 2aa8c529387c ("bcache: avoid
unnecessary btree nodes flushing in btree_flush_write()"), there is a
incorrect data type usage which leads to the following static checker
warning:
	drivers/md/bcache/journal.c:444 btree_flush_write()
	warn: 'ref_nr' unsigned <= 0

drivers/md/bcache/journal.c
   422  static void btree_flush_write(struct cache_set *c)
   423  {
   424          struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
   425          unsigned int i, nr, ref_nr;
                                    ^^^^^^

   426          atomic_t *fifo_front_p, *now_fifo_front_p;
   427          size_t mask;
   428
   429          if (c->journal.btree_flushing)
   430                  return;
   431
   432          spin_lock(&c->journal.flush_write_lock);
   433          if (c->journal.btree_flushing) {
   434                  spin_unlock(&c->journal.flush_write_lock);
   435                  return;
   436          }
   437          c->journal.btree_flushing = true;
   438          spin_unlock(&c->journal.flush_write_lock);
   439
   440          /* get the oldest journal entry and check its refcount */
   441          spin_lock(&c->journal.lock);
   442          fifo_front_p = &fifo_front(&c->journal.pin);
   443          ref_nr = atomic_read(fifo_front_p);
   444          if (ref_nr <= 0) {
                    ^^^^^^^^^^^
Unsigned can't be less than zero.

   445                  /*
   446                   * do nothing if no btree node references
   447                   * the oldest journal entry
   448                   */
   449                  spin_unlock(&c->journal.lock);
   450                  goto out;
   451          }
   452          spin_unlock(&c->journal.lock);

As the warning information indicates, local varaible ref_nr in unsigned
int type is wrong, which does not matche atomic_read() and the "<= 0"
checking.

This patch fixes the above error by defining local variable ref_nr as
int type.

Fixes: 2aa8c529387c ("bcache: avoid unnecessary btree nodes flushing in btree_flush_write()")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/journal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 33ddc5269e8dc..6730820780b06 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -422,7 +422,8 @@ int bch_journal_replay(struct cache_set *s, struct list_head *list)
 static void btree_flush_write(struct cache_set *c)
 {
 	struct btree *b, *t, *btree_nodes[BTREE_FLUSH_NR];
-	unsigned int i, nr, ref_nr;
+	unsigned int i, nr;
+	int ref_nr;
 	atomic_t *fifo_front_p, *now_fifo_front_p;
 	size_t mask;
 
-- 
2.20.1

