Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4EB4A4346
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377569AbiAaLUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:20:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35628 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376824AbiAaLQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:16:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71006B82A5F;
        Mon, 31 Jan 2022 11:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9303FC340E8;
        Mon, 31 Jan 2022 11:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627789;
        bh=gmPK/npHsN/H2bxF8vKX300kzqc94NfnneRn0xilyw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQiulh2kqrq4VMvBCrLz1fSFe7O7nMd5Qf91QdpOk933UEX4w04kFWh9+4Abd4WBu
         fH3n/JeHcBuMxp4KTFaYRsJS2w/kJgI0xhGpe7aDh1OnZaMm3R8sr2nrbDtiFnsbiD
         U/HgBr9fe88oZvBg0HaRAhDqHgKrf7eN3CX+3bmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 008/200] btrfs: update writeback index when starting defrag
Date:   Mon, 31 Jan 2022 11:54:31 +0100
Message-Id: <20220131105233.838548740@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 27cdfde181bcacd226c230b2fd831f6f5b8c215f upstream.

When starting a defrag, we should update the writeback index of the
inode's mapping in case it currently has a value beyond the start of the
range we are defragging. This can help performance and often result in
getting less extents after writeback - for e.g., if the current value
of the writeback index sits somewhere in the middle of a range that
gets dirty by the defrag, then after writeback we can get two smaller
extents instead of a single, larger extent.

We used to have this before the refactoring in 5.16, but it was removed
without any reason to do so. Originally it was added in kernel 3.1, by
commit 2a0f7f5769992b ("Btrfs: fix recursive auto-defrag"), in order to
fix a loop with autodefrag resulting in dirtying and writing pages over
and over, but some testing on current code did not show that happening,
at least with the test described in that commit.

So add back the behaviour, as at the very least it is a nice to have
optimization.

Fixes: 7b508037d4cac3 ("btrfs: defrag: use defrag_one_cluster() to implement btrfs_defrag_file()")
CC: stable@vger.kernel.org # 5.16
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1511,6 +1511,7 @@ int btrfs_defrag_file(struct inode *inod
 	int compress_type = BTRFS_COMPRESS_ZLIB;
 	int ret = 0;
 	u32 extent_thresh = range->extent_thresh;
+	pgoff_t start_index;
 
 	if (isize == 0)
 		return 0;
@@ -1552,6 +1553,14 @@ int btrfs_defrag_file(struct inode *inod
 			file_ra_state_init(ra, inode->i_mapping);
 	}
 
+	/*
+	 * Make writeback start from the beginning of the range, so that the
+	 * defrag range can be written sequentially.
+	 */
+	start_index = cur >> PAGE_SHIFT;
+	if (start_index < inode->i_mapping->writeback_index)
+		inode->i_mapping->writeback_index = start_index;
+
 	while (cur < last_byte) {
 		const unsigned long prev_sectors_defragged = sectors_defragged;
 		u64 cluster_end;


