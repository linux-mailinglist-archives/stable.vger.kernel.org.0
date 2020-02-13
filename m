Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737ED15C164
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgBMPW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgBMPW6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:58 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2FBBB246AD;
        Thu, 13 Feb 2020 15:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607377;
        bh=5vpayylQ5L8TSaMoVAmKJe6qWNe1UkGUWEOO4aWF4JY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ulhPLrkAzpw1DeHAEzEp4TGPJAQcwWSHOpw6Vht1vesaK+VoXivNDZ65UprFvlsto
         S/A9LSLxgT/GM9OcVYh8Mm2vvnafVksov10XElZ1V6JKLcXaNLIiZA7MlUJmDCNnca
         KYzUBZ/ao61dBwNcVxrl8Jo3X9MsIg8Kv0ak1jXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 72/91] btrfs: flush write bio if we loop in extent_write_cache_pages
Date:   Thu, 13 Feb 2020 07:20:29 -0800
Message-Id: <20200213151850.217987705@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 96bf313ecb33567af4cb53928b0c951254a02759 ]

There exists a deadlock with range_cyclic that has existed forever.  If
we loop around with a bio already built we could deadlock with a writer
who has the page locked that we're attempting to write but is waiting on
a page in our bio to be written out.  The task traces are as follows

  PID: 1329874  TASK: ffff889ebcdf3800  CPU: 33  COMMAND: "kworker/u113:5"
   #0 [ffffc900297bb658] __schedule at ffffffff81a4c33f
   #1 [ffffc900297bb6e0] schedule at ffffffff81a4c6e3
   #2 [ffffc900297bb6f8] io_schedule at ffffffff81a4ca42
   #3 [ffffc900297bb708] __lock_page at ffffffff811f145b
   #4 [ffffc900297bb798] __process_pages_contig at ffffffff814bc502
   #5 [ffffc900297bb8c8] lock_delalloc_pages at ffffffff814bc684
   #6 [ffffc900297bb900] find_lock_delalloc_range at ffffffff814be9ff
   #7 [ffffc900297bb9a0] writepage_delalloc at ffffffff814bebd0
   #8 [ffffc900297bba18] __extent_writepage at ffffffff814bfbf2
   #9 [ffffc900297bba98] extent_write_cache_pages at ffffffff814bffbd

  PID: 2167901  TASK: ffff889dc6a59c00  CPU: 14  COMMAND:
  "aio-dio-invalid"
   #0 [ffffc9003b50bb18] __schedule at ffffffff81a4c33f
   #1 [ffffc9003b50bba0] schedule at ffffffff81a4c6e3
   #2 [ffffc9003b50bbb8] io_schedule at ffffffff81a4ca42
   #3 [ffffc9003b50bbc8] wait_on_page_bit at ffffffff811f24d6
   #4 [ffffc9003b50bc60] prepare_pages at ffffffff814b05a7
   #5 [ffffc9003b50bcd8] btrfs_buffered_write at ffffffff814b1359
   #6 [ffffc9003b50bdb0] btrfs_file_write_iter at ffffffff814b5933
   #7 [ffffc9003b50be38] new_sync_write at ffffffff8128f6a8
   #8 [ffffc9003b50bec8] vfs_write at ffffffff81292b9d
   #9 [ffffc9003b50bf00] ksys_pwrite64 at ffffffff81293032

I used drgn to find the respective pages we were stuck on

page_entry.page 0xffffea00fbfc7500 index 8148 bit 15 pid 2167901
page_entry.page 0xffffea00f9bb7400 index 7680 bit 0 pid 1329874

As you can see the kworker is waiting for bit 0 (PG_locked) on index
7680, and aio-dio-invalid is waiting for bit 15 (PG_writeback) on index
8148.  aio-dio-invalid has 7680, and the kworker epd looks like the
following

  crash> struct extent_page_data ffffc900297bbbb0
  struct extent_page_data {
    bio = 0xffff889f747ed830,
    tree = 0xffff889eed6ba448,
    extent_locked = 0,
    sync_io = 0
  }

Probably worth mentioning as well that it waits for writeback of the
page to complete while holding a lock on it (at prepare_pages()).

Using drgn I walked the bio pages looking for page
0xffffea00fbfc7500 which is the one we're waiting for writeback on

  bio = Object(prog, 'struct bio', address=0xffff889f747ed830)
  for i in range(0, bio.bi_vcnt.value_()):
      bv = bio.bi_io_vec[i]
      if bv.bv_page.value_() == 0xffffea00fbfc7500:
	  print("FOUND IT")

which validated what I suspected.

The fix for this is simple, flush the epd before we loop back around to
the beginning of the file during writeout.

Fixes: b293f02e1423 ("Btrfs: Add writepages support")
CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6f5563ca70c1b..2c86c472f670d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4164,6 +4164,14 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 		 */
 		scanned = 1;
 		index = 0;
+
+		/*
+		 * If we're looping we could run into a page that is locked by a
+		 * writer and that writer could be waiting on writeback for a
+		 * page in our current bio, and thus deadlock, so flush the
+		 * write bio here.
+		 */
+		flush_write_bio(data);
 		goto retry;
 	}
 	btrfs_add_delayed_iput(inode);
-- 
2.20.1



