Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4B81056C1
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 17:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUQPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 11:15:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:55646 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726293AbfKUQPl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 11:15:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6574CB391;
        Thu, 21 Nov 2019 16:15:39 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D8F961E4360; Thu, 21 Nov 2019 17:15:38 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Bobrowski <mbobrowski@mbobrowski.org>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] iomap: Fix pipe page leakage during splicing
Date:   Thu, 21 Nov 2019 17:15:34 +0100
Message-Id: <20191121161538.18445-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191121161144.30802-1-jack@suse.cz>
References: <20191121161144.30802-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/iomap/direct-io.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 1fc28c2da279..30189652c560 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -497,8 +497,15 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		}
 		pos += ret;
 
-		if (iov_iter_rw(iter) == READ && pos >= dio->i_size)
+		if (iov_iter_rw(iter) == READ && pos >= dio->i_size) {
+			/*
+			 * We will report we've read data only upto i_size.
+			 * Revert iter to a state corresponding to that as
+			 * some callers (such as splice code) rely on it.
+			 */
+			iov_iter_revert(iter, pos - dio->i_size);
 			break;
+		}
 	} while ((count = iov_iter_count(iter)) > 0);
 	blk_finish_plug(&plug);
 
-- 
2.16.4

