Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDDF27C4CD
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbgI2LQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:33430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgI2LQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:16:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B98120848;
        Tue, 29 Sep 2020 11:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378204;
        bh=z3CnQpLSazu4y5j7Uw1l44E9lc2MBeidORc47uiA/DY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFLCQZiPpWeHENNr68DKlpa9HXqWG8TrQxKJIPimM2WaizyxdPZLxWnH2NzhtGIJf
         dAgJ2j8Ryhs6ycBIYwvWh+SuoUYfIWjqVrz2LMKPLepsD2ClS6L/wTQlZdH1n7FAmn
         g1XfkPRWewNT/qvh2D0oOfxRp4cnaMG+JmOE9xac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xianting Tian <xianting_tian@126.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, yubin@h3c.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 099/166] mm/filemap.c: clear page error before actual read
Date:   Tue, 29 Sep 2020 13:00:11 +0200
Message-Id: <20200929105940.156422288@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xianting Tian <xianting_tian@126.com>

[ Upstream commit faffdfa04fa11ccf048cebdde73db41ede0679e0 ]

Mount failure issue happens under the scenario: Application forked dozens
of threads to mount the same number of cramfs images separately in docker,
but several mounts failed with high probability.  Mount failed due to the
checking result of the page(read from the superblock of loop dev) is not
uptodate after wait_on_page_locked(page) returned in function cramfs_read:

   wait_on_page_locked(page);
   if (!PageUptodate(page)) {
      ...
   }

The reason of the checking result of the page not uptodate: systemd-udevd
read the loopX dev before mount, because the status of loopX is Lo_unbound
at this time, so loop_make_request directly trigger the calling of io_end
handler end_buffer_async_read, which called SetPageError(page).  So It
caused the page can't be set to uptodate in function
end_buffer_async_read:

   if(page_uptodate && !PageError(page)) {
      SetPageUptodate(page);
   }

Then mount operation is performed, it used the same page which is just
accessed by systemd-udevd above, Because this page is not uptodate, it
will launch a actual read via submit_bh, then wait on this page by calling
wait_on_page_locked(page).  When the I/O of the page done, io_end handler
end_buffer_async_read is called, because no one cleared the page
error(during the whole read path of mount), which is caused by
systemd-udevd reading, so this page is still in "PageError" status, which
can't be set to uptodate in function end_buffer_async_read, then caused
mount failure.

But sometimes mount succeed even through systemd-udeved read loopX dev
just before, The reason is systemd-udevd launched other loopX read just
between step 3.1 and 3.2, the steps as below:

1, loopX dev default status is Lo_unbound;
2, systemd-udved read loopX dev (page is set to PageError);
3, mount operation
   1) set loopX status to Lo_bound;
   ==>systemd-udevd read loopX dev<==
   2) read loopX dev(page has no error)
   3) mount succeed

As the loopX dev status is set to Lo_bound after step 3.1, so the other
loopX dev read by systemd-udevd will go through the whole I/O stack, part
of the call trace as below:

   SYS_read
      vfs_read
          do_sync_read
              blkdev_aio_read
                 generic_file_aio_read
                     do_generic_file_read:
                        ClearPageError(page);
                        mapping->a_ops->readpage(filp, page);

here, mapping->a_ops->readpage() is blkdev_readpage.  In latest kernel,
some function name changed, the call trace as below:

   blkdev_read_iter
      generic_file_read_iter
         generic_file_buffered_read:
            /*
             * A previous I/O error may have been due to temporary
             * failures, eg. mutipath errors.
             * Pg_error will be set again if readpage fails.
             */
            ClearPageError(page);
            /* Start the actual read. The read will unlock the page*/
            error=mapping->a_ops->readpage(flip, page);

We can see ClearPageError(page) is called before the actual read,
then the read in step 3.2 succeed.

This patch is to add the calling of ClearPageError just before the actual
read of read path of cramfs mount.  Without the patch, the call trace as
below when performing cramfs mount:

   do_mount
      cramfs_read
         cramfs_blkdev_read
            read_cache_page
               do_read_cache_page:
                  filler(data, page);
                  or
                  mapping->a_ops->readpage(data, page);

With the patch, the call trace as below when performing mount:

   do_mount
      cramfs_read
         cramfs_blkdev_read
            read_cache_page:
               do_read_cache_page:
                  ClearPageError(page); <== new add
                  filler(data, page);
                  or
                  mapping->a_ops->readpage(data, page);

With the patch, mount operation trigger the calling of
ClearPageError(page) before the actual read, the page has no error if no
additional page error happen when I/O done.

Signed-off-by: Xianting Tian <xianting_tian@126.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: <yubin@h3c.com>
Link: http://lkml.kernel.org/r/1583318844-22971-1-git-send-email-xianting_tian@126.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index a30dbf93de992..471f8091d782a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2774,6 +2774,14 @@ filler:
 		unlock_page(page);
 		goto out;
 	}
+
+	/*
+	 * A previous I/O error may have been due to temporary
+	 * failures.
+	 * Clear page error before actual read, PG_error will be
+	 * set again if read page fails.
+	 */
+	ClearPageError(page);
 	goto filler;
 
 out:
-- 
2.25.1



