Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD7140025
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390536AbgAPXUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390520AbgAPXUA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CF4D2072B;
        Thu, 16 Jan 2020 23:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216799;
        bh=VHDMOVKY2KfdkiAkN5SrQec/XY+J+CAactGKTcT7Y2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JhK+Z5ipUJLe3hUYTVSf+msQ2QQ225WCaEevYJUMjPKPEJ2VJGOd+ltalh9cA+jbs
         K8aSfnap/0f+HeI90bE12uWh0ocKbWJjoqUkUd+Z16w1Wc1NB2VRZyi4shP78tdaOE
         093AC3WZwm2nU1gDVmmkRCF779NALgq66jkRDULw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>,
        linux-fsdevel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 024/203] fs: move guard_bio_eod() after bio_set_op_attrs
Date:   Fri, 17 Jan 2020 00:15:41 +0100
Message-Id: <20200116231746.615182367@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 83c9c547168e8b914ea6398430473a4de68c52cc upstream.

Commit 85a8ce62c2ea ("block: add bio_truncate to fix guard_bio_eod")
adds bio_truncate() for handling bio EOD. However, bio_truncate()
doesn't use the passed 'op' parameter from guard_bio_eod's callers.

So bio_trunacate() may retrieve wrong 'op', and zering pages may
not be done for READ bio.

Fixes this issue by moving guard_bio_eod() after bio_set_op_attrs()
in submit_bh_wbc() so that bio_truncate() can always retrieve correct
op info.

Meantime remove the 'op' parameter from guard_bio_eod() because it isn't
used any more.

Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Fixes: 85a8ce62c2ea ("block: add bio_truncate to fix guard_bio_eod")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Fold in kerneldoc and bio_op() change.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---
 block/bio.c   |   12 +++++++++++-
 fs/buffer.c   |    8 ++++----
 fs/internal.h |    2 +-
 fs/mpage.c    |    2 +-
 4 files changed, 17 insertions(+), 7 deletions(-)

--- a/block/bio.c
+++ b/block/bio.c
@@ -535,6 +535,16 @@ void zero_fill_bio_iter(struct bio *bio,
 }
 EXPORT_SYMBOL(zero_fill_bio_iter);
 
+/**
+ * bio_truncate - truncate the bio to small size of @new_size
+ * @bio:	the bio to be truncated
+ * @new_size:	new size for truncating the bio
+ *
+ * Description:
+ *   Truncate the bio to new size of @new_size. If bio_op(bio) is
+ *   REQ_OP_READ, zero the truncated part. This function should only
+ *   be used for handling corner cases, such as bio eod.
+ */
 void bio_truncate(struct bio *bio, unsigned new_size)
 {
 	struct bio_vec bv;
@@ -545,7 +555,7 @@ void bio_truncate(struct bio *bio, unsig
 	if (new_size >= bio->bi_iter.bi_size)
 		return;
 
-	if (bio_data_dir(bio) != READ)
+	if (bio_op(bio) != REQ_OP_READ)
 		goto exit;
 
 	bio_for_each_segment(bv, bio, iter) {
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2991,7 +2991,7 @@ static void end_bio_bh_io_sync(struct bi
  * errors, this only handles the "we need to be able to
  * do IO at the final sector" case.
  */
-void guard_bio_eod(int op, struct bio *bio)
+void guard_bio_eod(struct bio *bio)
 {
 	sector_t maxsector;
 	struct hd_struct *part;
@@ -3055,15 +3055,15 @@ static int submit_bh_wbc(int op, int op_
 	bio->bi_end_io = end_bio_bh_io_sync;
 	bio->bi_private = bh;
 
-	/* Take care of bh's that straddle the end of the device */
-	guard_bio_eod(op, bio);
-
 	if (buffer_meta(bh))
 		op_flags |= REQ_META;
 	if (buffer_prio(bh))
 		op_flags |= REQ_PRIO;
 	bio_set_op_attrs(bio, op, op_flags);
 
+	/* Take care of bh's that straddle the end of the device */
+	guard_bio_eod(bio);
+
 	if (wbc) {
 		wbc_init_bio(wbc, bio);
 		wbc_account_cgroup_owner(wbc, bh->b_page, bh->b_size);
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -38,7 +38,7 @@ static inline int __sync_blockdev(struct
 /*
  * buffer.c
  */
-extern void guard_bio_eod(int rw, struct bio *bio);
+extern void guard_bio_eod(struct bio *bio);
 extern int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
 		get_block_t *get_block, struct iomap *iomap);
 
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -62,7 +62,7 @@ static struct bio *mpage_bio_submit(int
 {
 	bio->bi_end_io = mpage_end_io;
 	bio_set_op_attrs(bio, op, op_flags);
-	guard_bio_eod(op, bio);
+	guard_bio_eod(bio);
 	submit_bio(bio);
 	return NULL;
 }


