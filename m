Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA36A13349A
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727382AbgAGU6b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:58:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgAGU6b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:58:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03EE12467F;
        Tue,  7 Jan 2020 20:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430710;
        bh=TcwWpdi0xErU0FU0JJw/NBlXPqoxzclBK4i83rAtDSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1hbp2bopiubHPi2ynNMW6PX61Ms7IBgNHpEtQvlH3JmxUJYDGAq900PXVmjC/aYMG
         fwny1UKNrOTrcQy/Iwr++OsK9WINAl5lmuUPR/fJiBbfwNNMCV5ZvwvCjUCu0XNo6V
         oPMzVVLlMSNESdY2cZnZjpYVy9ErfiADsesIJvSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>,
        linux-fsdevel@vger.kernel.org,
        syzbot+2b9e54155c8c25d8d165@syzkaller.appspotmail.com,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 064/191] block: add bio_truncate to fix guard_bio_eod
Date:   Tue,  7 Jan 2020 21:53:04 +0100
Message-Id: <20200107205336.418785245@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 85a8ce62c2eabe28b9d76ca4eecf37922402df93 ]

Some filesystem, such as vfat, may send bio which crosses device boundary,
and the worse thing is that the IO request starting within device boundaries
can contain more than one segment past EOD.

Commit dce30ca9e3b6 ("fs: fix guard_bio_eod to check for real EOD errors")
tries to fix this issue by returning -EIO for this situation. However,
this way lets fs user code lose chance to handle -EIO, then sync_inodes_sb()
may hang for ever.

Also the current truncating on last segment is dangerous by updating the
last bvec, given bvec table becomes not immutable any more, and fs bio
users may not retrieve the truncated pages via bio_for_each_segment_all() in
its .end_io callback.

Fixes this issue by supporting multi-segment truncating. And the
approach is simpler:

- just update bio size since block layer can make correct bvec with
the updated bio size. Then bvec table becomes really immutable.

- zero all truncated segments for read bio

Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
Fixed-by: dce30ca9e3b6 ("fs: fix guard_bio_eod to check for real EOD errors")
Reported-by: syzbot+2b9e54155c8c25d8d165@syzkaller.appspotmail.com
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c         | 39 +++++++++++++++++++++++++++++++++++++++
 fs/buffer.c         | 25 +------------------------
 include/linux/bio.h |  1 +
 3 files changed, 41 insertions(+), 24 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 43df756b68c4..c822ceb7c4de 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -535,6 +535,45 @@ void zero_fill_bio_iter(struct bio *bio, struct bvec_iter start)
 }
 EXPORT_SYMBOL(zero_fill_bio_iter);
 
+void bio_truncate(struct bio *bio, unsigned new_size)
+{
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	unsigned int done = 0;
+	bool truncated = false;
+
+	if (new_size >= bio->bi_iter.bi_size)
+		return;
+
+	if (bio_data_dir(bio) != READ)
+		goto exit;
+
+	bio_for_each_segment(bv, bio, iter) {
+		if (done + bv.bv_len > new_size) {
+			unsigned offset;
+
+			if (!truncated)
+				offset = new_size - done;
+			else
+				offset = 0;
+			zero_user(bv.bv_page, offset, bv.bv_len - offset);
+			truncated = true;
+		}
+		done += bv.bv_len;
+	}
+
+ exit:
+	/*
+	 * Don't touch bvec table here and make it really immutable, since
+	 * fs bio user has to retrieve all pages via bio_for_each_segment_all
+	 * in its .end_bio() callback.
+	 *
+	 * It is enough to truncate bio by updating .bi_size since we can make
+	 * correct bvec with the updated .bi_size for drivers.
+	 */
+	bio->bi_iter.bi_size = new_size;
+}
+
 /**
  * bio_put - release a reference to a bio
  * @bio:   bio to release reference to
diff --git a/fs/buffer.c b/fs/buffer.c
index 86a38b979323..7744488f7bde 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2994,8 +2994,6 @@ static void end_bio_bh_io_sync(struct bio *bio)
 void guard_bio_eod(int op, struct bio *bio)
 {
 	sector_t maxsector;
-	struct bio_vec *bvec = bio_last_bvec_all(bio);
-	unsigned truncated_bytes;
 	struct hd_struct *part;
 
 	rcu_read_lock();
@@ -3021,28 +3019,7 @@ void guard_bio_eod(int op, struct bio *bio)
 	if (likely((bio->bi_iter.bi_size >> 9) <= maxsector))
 		return;
 
-	/* Uhhuh. We've got a bio that straddles the device size! */
-	truncated_bytes = bio->bi_iter.bi_size - (maxsector << 9);
-
-	/*
-	 * The bio contains more than one segment which spans EOD, just return
-	 * and let IO layer turn it into an EIO
-	 */
-	if (truncated_bytes > bvec->bv_len)
-		return;
-
-	/* Truncate the bio.. */
-	bio->bi_iter.bi_size -= truncated_bytes;
-	bvec->bv_len -= truncated_bytes;
-
-	/* ..and clear the end of the buffer for reads */
-	if (op == REQ_OP_READ) {
-		struct bio_vec bv;
-
-		mp_bvec_last_segment(bvec, &bv);
-		zero_user(bv.bv_page, bv.bv_offset + bv.bv_len,
-				truncated_bytes);
-	}
+	bio_truncate(bio, maxsector << 9);
 }
 
 static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 3cdb84cdc488..853d92ceee64 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -470,6 +470,7 @@ extern struct bio *bio_copy_user_iov(struct request_queue *,
 				     gfp_t);
 extern int bio_uncopy_user(struct bio *);
 void zero_fill_bio_iter(struct bio *bio, struct bvec_iter iter);
+void bio_truncate(struct bio *bio, unsigned new_size);
 
 static inline void zero_fill_bio(struct bio *bio)
 {
-- 
2.20.1



