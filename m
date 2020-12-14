Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2822D9DEE
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 18:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502382AbgLNRjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 12:39:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:49942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502375AbgLNRjJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:39:09 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 5.9 099/105] zonefs: fix page reference and BIO leak
Date:   Mon, 14 Dec 2020 18:29:13 +0100
Message-Id: <20201214172600.048551286@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit 6bea0225a4bf14a58af71cb9677a756921469e46 upstream.

In zonefs_file_dio_append(), the pages obtained using
bio_iov_iter_get_pages() are not released on completion of the
REQ_OP_APPEND BIO, nor when bio_iov_iter_get_pages() fails.
Furthermore, a call to bio_put() is missing when
bio_iov_iter_get_pages() fails.

Fix these resource leaks by adding BIO resource release code (bio_put()i
and bio_release_pages()) at the end of the function after the BIO
execution and add a jump to this resource cleanup code in case of
bio_iov_iter_get_pages() failure.

While at it, also fix the call to task_io_account_write() to be passed
the correct BIO size instead of bio_iov_iter_get_pages() return value.

Reported-by: Christoph Hellwig <hch@lst.de>
Fixes: 02ef12a663c7 ("zonefs: use REQ_OP_ZONE_APPEND for sync DIO")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/zonefs/super.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -628,21 +628,23 @@ static ssize_t zonefs_file_dio_append(st
 		bio->bi_opf |= REQ_FUA;
 
 	ret = bio_iov_iter_get_pages(bio, from);
-	if (unlikely(ret)) {
-		bio_io_error(bio);
-		return ret;
-	}
+	if (unlikely(ret))
+		goto out_release;
+
 	size = bio->bi_iter.bi_size;
-	task_io_account_write(ret);
+	task_io_account_write(size);
 
 	if (iocb->ki_flags & IOCB_HIPRI)
 		bio_set_polled(bio, iocb);
 
 	ret = submit_bio_wait(bio);
 
+	zonefs_file_write_dio_end_io(iocb, size, ret, 0);
+
+out_release:
+	bio_release_pages(bio, false);
 	bio_put(bio);
 
-	zonefs_file_write_dio_end_io(iocb, size, ret, 0);
 	if (ret >= 0) {
 		iocb->ki_pos += size;
 		return size;


