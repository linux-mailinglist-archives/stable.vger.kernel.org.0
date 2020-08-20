Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DCB24BBE6
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgHTMf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:35:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729545AbgHTJsL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:48:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C37812078D;
        Thu, 20 Aug 2020 09:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916890;
        bh=e/9H8fbVPvZQZK6O/dKJii+CSircMQEFTYMDaaOMrak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdiTNVwSZcg9GXn0d/mMLeilx4lipJFpzP/X8AO5h4p4QkDr97MRHl4hLQrrKBgQr
         m1RWgL7G06NrKVCq/4qwHWLXDDljUbozax55bwvG7W+1OzL5kG74E5d+WrKiHYzq8d
         6CqnTWg7BJCtYHtOrTZo4fDn2DVaoK9AUFcdyvFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Marshall <hubcap@omnibond.com>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH 5.4 075/152] orangefs: get rid of knob code...
Date:   Thu, 20 Aug 2020 11:20:42 +0200
Message-Id: <20200820091557.578194646@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marshall <hubcap@omnibond.com>

commit ec95f1dedc9c64ac5a8b0bdb7c276936c70fdedd upstream.

Christoph Hellwig sent in a reversion of "orangefs: remember count
when reading." because:

  ->read_iter calls can race with each other and one or
  more ->flush calls. Remove the the scheme to store the read
  count in the file private data as is is completely racy and
  can cause use after free or double free conditions

Christoph's reversion caused Orangefs not to work or to compile. I
added a patch that fixed that, but intel's kbuild test robot pointed
out that sending Christoph's patch followed by my patch upstream, it
would break bisection because of the failure to compile. So I have
combined the reversion plus my patch... here's the commit message
that was in my patch:

  Logically, optimal Orangefs "pages" are 4 megabytes. Reading
  large Orangefs files 4096 bytes at a time is like trying to
  kick a dead whale down the beach. Before Christoph's "Revert
  orangefs: remember count when reading." I tried to give users
  a knob whereby they could, for example, use "count" in
  read(2) or bs with dd(1) to get whatever they considered an
  appropriate amount of bytes at a time from Orangefs and fill
  as many page cache pages as they could at once.

  Without the racy code that Christoph reverted Orangefs won't
  even compile, much less work. So this replaces the logic that
  used the private file data that Christoph reverted with
  a static number of bytes to read from Orangefs.

  I ran tests like the following to determine what a
  reasonable static number of bytes might be:

  dd if=/pvfsmnt/asdf of=/dev/null count=128 bs=4194304
  dd if=/pvfsmnt/asdf of=/dev/null count=256 bs=2097152
  dd if=/pvfsmnt/asdf of=/dev/null count=512 bs=1048576
                            .
                            .
                            .
  dd if=/pvfsmnt/asdf of=/dev/null count=4194304 bs=128

  Reads seem faster using the static number, so my "knob code"
  wasn't just racy, it wasn't even a good idea...

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/orangefs/file.c            |   26 +-------------------------
 fs/orangefs/inode.c           |   39 ++++++---------------------------------
 fs/orangefs/orangefs-kernel.h |    4 ----
 3 files changed, 7 insertions(+), 62 deletions(-)

--- a/fs/orangefs/file.c
+++ b/fs/orangefs/file.c
@@ -311,23 +311,8 @@ static ssize_t orangefs_file_read_iter(s
     struct iov_iter *iter)
 {
 	int ret;
-	struct orangefs_read_options *ro;
-
 	orangefs_stats.reads++;
 
-	/*
-	 * Remember how they set "count" in read(2) or pread(2) or whatever -
-	 * users can use count as a knob to control orangefs io size and later
-	 * we can try to help them fill as many pages as possible in readpage.
-	 */
-	if (!iocb->ki_filp->private_data) {
-		iocb->ki_filp->private_data = kmalloc(sizeof *ro, GFP_KERNEL);
-		if (!iocb->ki_filp->private_data)
-			return(ENOMEM);
-		ro = iocb->ki_filp->private_data;
-		ro->blksiz = iter->count;
-	}
-
 	down_read(&file_inode(iocb->ki_filp)->i_rwsem);
 	ret = orangefs_revalidate_mapping(file_inode(iocb->ki_filp));
 	if (ret)
@@ -615,12 +600,6 @@ static int orangefs_lock(struct file *fi
 	return rc;
 }
 
-static int orangefs_file_open(struct inode * inode, struct file *file)
-{
-	file->private_data = NULL;
-	return generic_file_open(inode, file);
-}
-
 static int orangefs_flush(struct file *file, fl_owner_t id)
 {
 	/*
@@ -634,9 +613,6 @@ static int orangefs_flush(struct file *f
 	struct inode *inode = file->f_mapping->host;
 	int r;
 
-	kfree(file->private_data);
-	file->private_data = NULL;
-
 	if (inode->i_state & I_DIRTY_TIME) {
 		spin_lock(&inode->i_lock);
 		inode->i_state &= ~I_DIRTY_TIME;
@@ -659,7 +635,7 @@ const struct file_operations orangefs_fi
 	.lock		= orangefs_lock,
 	.unlocked_ioctl	= orangefs_ioctl,
 	.mmap		= orangefs_file_mmap,
-	.open		= orangefs_file_open,
+	.open		= generic_file_open,
 	.flush		= orangefs_flush,
 	.release	= orangefs_file_release,
 	.fsync		= orangefs_fsync,
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -259,46 +259,19 @@ static int orangefs_readpage(struct file
 	pgoff_t index; /* which page */
 	struct page *next_page;
 	char *kaddr;
-	struct orangefs_read_options *ro = file->private_data;
 	loff_t read_size;
-	loff_t roundedup;
 	int buffer_index = -1; /* orangefs shared memory slot */
 	int slot_index;   /* index into slot */
 	int remaining;
 
 	/*
-	 * If they set some miniscule size for "count" in read(2)
-	 * (for example) then let's try to read a page, or the whole file
-	 * if it is smaller than a page. Once "count" goes over a page
-	 * then lets round up to the highest page size multiple that is
-	 * less than or equal to "count" and do that much orangefs IO and
-	 * try to fill as many pages as we can from it.
-	 *
-	 * "count" should be represented in ro->blksiz.
-	 *
-	 * inode->i_size = file size.
+	 * Get up to this many bytes from Orangefs at a time and try
+	 * to fill them into the page cache at once. Tests with dd made
+	 * this seem like a reasonable static number, if there was
+	 * interest perhaps this number could be made setable through
+	 * sysfs...
 	 */
-	if (ro) {
-		if (ro->blksiz < PAGE_SIZE) {
-			if (inode->i_size < PAGE_SIZE)
-				read_size = inode->i_size;
-			else
-				read_size = PAGE_SIZE;
-		} else {
-			roundedup = ((PAGE_SIZE - 1) & ro->blksiz) ?
-				((ro->blksiz + PAGE_SIZE) & ~(PAGE_SIZE -1)) :
-				ro->blksiz;
-			if (roundedup > inode->i_size)
-				read_size = inode->i_size;
-			else
-				read_size = roundedup;
-
-		}
-	} else {
-		read_size = PAGE_SIZE;
-	}
-	if (!read_size)
-		read_size = PAGE_SIZE;
+	read_size = 524288;
 
 	if (PageDirty(page))
 		orangefs_launder_page(page);
--- a/fs/orangefs/orangefs-kernel.h
+++ b/fs/orangefs/orangefs-kernel.h
@@ -239,10 +239,6 @@ struct orangefs_write_range {
 	kgid_t gid;
 };
 
-struct orangefs_read_options {
-	ssize_t blksiz;
-};
-
 extern struct orangefs_stats orangefs_stats;
 
 /*


