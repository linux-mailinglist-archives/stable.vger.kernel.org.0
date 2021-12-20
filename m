Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F7D47AF9E
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238293AbhLTPQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:16:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237307AbhLTPO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:14:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CA6C004398;
        Mon, 20 Dec 2021 06:57:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1269FB80ED1;
        Mon, 20 Dec 2021 14:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E05FC36AE7;
        Mon, 20 Dec 2021 14:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012253;
        bh=Di6yf7dCm4hlgRJOR7op1UGK2vAFQIXXGJKleknwAB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcaHgYUl41ljW3co6k5yM13BzqLT3xuxW2SITKdWKsLZwO8sfADXMpEs/nXlX5pdS
         YIPDrHF79K1dxQxCGy3yvjtDsva9vFEcAyZIaWV0N7icYwk+7vBRxncBWPakxKH4Bd
         LQBMdP+xFx7SElpBZsT1ZvGUEgEeEbweZdMNj78w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.15 134/177] btrfs: check WRITE_ERR when trying to read an extent buffer
Date:   Mon, 20 Dec 2021 15:34:44 +0100
Message-Id: <20211220143044.589554659@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit 651740a502411793327e2f0741104749c4eedcd1 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -6547,6 +6547,14 @@ int read_extent_buffer_pages(struct exte
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
 


