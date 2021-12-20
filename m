Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84F247A9D9
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 13:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhLTMor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 07:44:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51172 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhLTMoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 07:44:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5678F60FEE
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 12:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3692FC36AE8;
        Mon, 20 Dec 2021 12:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640004285;
        bh=HomozG0O63NluQEx+yLLqYsnQQn9cxe8hX2bQmkwP4k=;
        h=Subject:To:Cc:From:Date:From;
        b=LMlcIuBFKp4seOmN8OZYK07wQHHckIg4pIj2qJWNkObzvFWK7wUYCiNGvS8uEXYPa
         eQ+hZYIIDTsz5Af5USkzUnf4SP3cgqfhJDzbwxrz5+pWzJ/3C0I6wQAM+yxUbIfb44
         cItZTsHnxKc3j0jxXs+P/9BT0XOaYRCPuhR48jwQ=
Subject: FAILED: patch "[PATCH] btrfs: check WRITE_ERR when trying to read an extent buffer" failed to apply to 5.10-stable tree
To:     josef@toxicpanda.com, dsterba@suse.com, fdmanana@suse.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Dec 2021 13:44:35 +0100
Message-ID: <1640004275174112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 651740a502411793327e2f0741104749c4eedcd1 Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 13 Dec 2021 14:22:33 -0500
Subject: [PATCH] btrfs: check WRITE_ERR when trying to read an extent buffer

Filipe reported a hang when we have errors on btrfs.  This turned out to
be a side-effect of my fix c2e39305299f01 ("btrfs: clear extent buffer
uptodate when we fail to write it") which made it so we clear
EXTENT_BUFFER_UPTODATE on an eb when we fail to write it out.

Below is a paste of Filipe's analysis he got from using drgn to debug
the hang

"""
btree readahead code calls read_extent_buffer_pages(), sets ->io_pages to
a value while writeback of all pages has not yet completed:
   --> writeback for the first 3 pages finishes, we clear
       EXTENT_BUFFER_UPTODATE from eb on the first page when we get an
       error.
   --> at this point eb->io_pages is 1 and we cleared Uptodate bit from the
       first 3 pages
   --> read_extent_buffer_pages() does not see EXTENT_BUFFER_UPTODATE() so
       it continues, it's able to lock the pages since we obviously don't
       hold the pages locked during writeback
   --> read_extent_buffer_pages() then computes 'num_reads' as 3, and sets
       eb->io_pages to 3, since only the first page does not have Uptodate
       bit set at this point
   --> writeback for the remaining page completes, we ended decrementing
       eb->io_pages by 1, resulting in eb->io_pages == 2, and therefore
       never calling end_extent_buffer_writeback(), so
       EXTENT_BUFFER_WRITEBACK remains in the eb's flags
   --> of course, when the read bio completes, it doesn't and shouldn't
       call end_extent_buffer_writeback()
   --> we should clear EXTENT_BUFFER_UPTODATE only after all pages of
       the eb finished writeback?  or maybe make the read pages code
       wait for writeback of all pages of the eb to complete before
       checking which pages need to be read, touch ->io_pages, submit
       read bio, etc

writeback bit never cleared means we can hang when aborting a
transaction, at:

    btrfs_cleanup_one_transaction()
       btrfs_destroy_marked_extents()
         wait_on_extent_buffer_writeback()
"""

This is a problem because our writes are not synchronized with reads in
any way.  We clear the UPTODATE flag and then we can easily come in and
try to read the EB while we're still waiting on other bio's to
complete.

We have two options here, we could lock all the pages, and then check to
see if eb->io_pages != 0 to know if we've already got an outstanding
write on the eb.

Or we can simply check to see if we have WRITE_ERR set on this extent
buffer.  We set this bit _before_ we clear UPTODATE, so if the read gets
triggered because we aren't UPTODATE because of a write error we're
guaranteed to have WRITE_ERR set, and in this case we can simply return
-EIO.  This will fix the reported hang.

Reported-by: Filipe Manana <fdmanana@suse.com>
Fixes: c2e39305299f01 ("btrfs: clear extent buffer uptodate when we fail to write it")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3258b6f01e85..9234d96a7fd5 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -6611,6 +6611,14 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int wait, int mirror_num)
 	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
 		return 0;
 
+	/*
+	 * We could have had EXTENT_BUFFER_UPTODATE cleared by the write
+	 * operation, which could potentially still be in flight.  In this case
+	 * we simply want to return an error.
+	 */
+	if (unlikely(test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)))
+		return -EIO;
+
 	if (eb->fs_info->sectorsize < PAGE_SIZE)
 		return read_extent_buffer_subpage(eb, wait, mirror_num);
 

