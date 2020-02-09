Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28562156A81
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbgBINII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:08:08 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45095 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727661AbgBINII (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:08:08 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4C4AA21EAF;
        Sun,  9 Feb 2020 08:08:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:08:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mjZYjB
        0B30aAaq0gfjaaocWaaJgwXFJ/8ukvQKNH8wU=; b=Rna8u8AYoxkfELZ09+TIu+
        19JcakPoZfafTQ3iN0TDq8+Te+N+2rXWq82juqPM+v3IYjOjw1GJUOf6d36mYOYN
        2P0sU82S7cAM80pzEfrUMJWTqD85SsBUECcvI7adbOOjQ4rF59RpbTG23wViunw/
        86Ufih/jA0buVw33BwhGRvDCIDSxdZFOdnnPY9HIFgrb2NonzIoKuWtLhHwmcDdn
        v1WW/Ht/ydF29qrv/0rUD2gYlo4tfctThXxYv/7wTRhA5NZCegnTAkR45eOAiITH
        AHAfBGCPrkRBuCqaT1K0ZaoWXLV2gNOGunZrIW3fiy28Wxc8ZhAawzhFLPF6HZpA
        ==
X-ME-Sender: <xms:NwRAXhi7Hj708s0q2OGjKP4vXIch68fHsdPjngHsBTGc8Btzzv1bUg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepudegne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NwRAXvVT14Omgx3QHBRbpEbcEkFhyc4Uhl1RuBwlUS_jeUh6VWdNAw>
    <xmx:NwRAXtecPnQ3Zn-LPOvmt4ZNp5dqe84c1tXTjp7I6knNs73YuC-GLg>
    <xmx:NwRAXt0RjmMhjFcXYtftPfTX0vMJb-clgrZabekcDr2SxfqWxusWYg>
    <xmx:NwRAXh-wA-pcitbW6PSPSOARaazDbS3_BCzsLKRDtFtcvRj4OnWSaw>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id A735930607B0;
        Sun,  9 Feb 2020 08:08:05 -0500 (EST)
Subject: FAILED: patch "[PATCH] btrfs: flush write bio if we loop in extent_write_cache_pages" failed to apply to 4.4-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:03:46 +0100
Message-ID: <15812498268201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 42ffb0bf584ae5b6b38f72259af1e0ee417ac77f Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 23 Jan 2020 15:33:02 -0500
Subject: [PATCH] btrfs: flush write bio if we loop in extent_write_cache_pages

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

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e2d30287e2d5..8ff17bc30d5a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4166,7 +4166,16 @@ static int extent_write_cache_pages(struct address_space *mapping,
 		 */
 		scanned = 1;
 		index = 0;
-		goto retry;
+
+		/*
+		 * If we're looping we could run into a page that is locked by a
+		 * writer and that writer could be waiting on writeback for a
+		 * page in our current bio, and thus deadlock, so flush the
+		 * write bio here.
+		 */
+		ret = flush_write_bio(epd);
+		if (!ret)
+			goto retry;
 	}
 
 	if (wbc->range_cyclic || (wbc->nr_to_write > 0 && range_whole))

