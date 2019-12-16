Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB99121306
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbfLPR6J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:58:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfLPR6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:58:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1CB5206B7;
        Mon, 16 Dec 2019 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519088;
        bh=8NeGkRWnW/JfCOlPSnmQiqjjVtKxoXbqxNWWSoVFY5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nVcAAMTMWi90DMpdbegPtLnJAZVt7uHWbTktIl+mQZj27yQ7tQxeBT9czdQ+6RZ5U
         AXWqPHCrPXsVv2HRX7/vAnEY5loznk6od8vA6nvXHCcET16wdHkYfOuUSx35GznuVK
         OtHaQGvp0EBxUZJVm6jfMC0Ld5ruhgGzpdSurkJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+991400e8eba7e00a26e1@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4.14 150/267] iomap: Fix pipe page leakage during splicing
Date:   Mon, 16 Dec 2019 18:47:56 +0100
Message-Id: <20191216174910.702182080@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 419e9c38aa075ed0cd3c13d47e15954b686bcdb6 upstream.

When splicing using iomap_dio_rw() to a pipe, we may leak pipe pages
because bio_iov_iter_get_pages() records that the pipe will have full
extent worth of data however if file size is not block size aligned
iomap_dio_rw() returns less than what bio_iov_iter_get_pages() set up
and splice code gets confused leaking a pipe page with the file tail.

Handle the situation similarly to the old direct IO implementation and
revert iter to actually returned read amount which makes iter consistent
with value returned from iomap_dio_rw() and thus the splice code is
happy.

Fixes: ff6a9292e6f6 ("iomap: implement direct I/O")
CC: stable@vger.kernel.org
Reported-by: syzbot+991400e8eba7e00a26e1@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/iomap.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1053,8 +1053,15 @@ iomap_dio_rw(struct kiocb *iocb, struct
 		}
 		pos += ret;
 
-		if (iov_iter_rw(iter) == READ && pos >= dio->i_size)
+		if (iov_iter_rw(iter) == READ && pos >= dio->i_size) {
+			/*
+			 * We only report that we've read data up to i_size.
+			 * Revert iter to a state corresponding to that as
+			 * some callers (such as splice code) rely on it.
+			 */
+			iov_iter_revert(iter, pos - dio->i_size);
 			break;
+		}
 	} while ((count = iov_iter_count(iter)) > 0);
 	blk_finish_plug(&plug);
 


