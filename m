Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A144A449A
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344116AbiAaLbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377535AbiAaL0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:26:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D85C033278;
        Mon, 31 Jan 2022 03:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DF88B82A64;
        Mon, 31 Jan 2022 11:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A467AC340EF;
        Mon, 31 Jan 2022 11:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627786;
        bh=qtLzw/kPPtrKxD0Js8hAC1GVIUEVQ8FVkEn0M0zlAIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1JioznHaRj9tcd5eTvosEsBF05D+fPOFI/LTFSuVnSR6pkIkVc+Vv91+TQNF3SFsS
         e5uQEJ//6nF7uD2aeHZSy3VIEQHU38B1n8JcPpGuLqN48DMlUx2nxdmTeftf+xO71I
         ehGbtVY8E5q/tKFdb4R0mmHX6xJiNDtWEc8/OChg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.16 007/200] btrfs: add back missing dirty page rate limiting to defrag
Date:   Mon, 31 Jan 2022 11:54:30 +0100
Message-Id: <20220131105233.807140830@linuxfoundation.org>
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

commit 3c9d31c715948aaff0ee6d322a91a2dec07770bf upstream.

A defrag operation can dirty a lot of pages, specially if operating on
the entire file or a large file range. Any task dirtying pages should
periodically call balance_dirty_pages_ratelimited(), as stated in that
function's comments, otherwise they can leave too many dirty pages in
the system. This is what we did before the refactoring in 5.16, and
it should have remained, just like in the buffered write path and
relocation. So restore that behaviour.

Fixes: 7b508037d4cac3 ("btrfs: defrag: use defrag_one_cluster() to implement btrfs_defrag_file()")
CC: stable@vger.kernel.org # 5.16
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1553,6 +1553,7 @@ int btrfs_defrag_file(struct inode *inod
 	}
 
 	while (cur < last_byte) {
+		const unsigned long prev_sectors_defragged = sectors_defragged;
 		u64 cluster_end;
 
 		/* The cluster size 256K should always be page aligned */
@@ -1584,6 +1585,10 @@ int btrfs_defrag_file(struct inode *inod
 				cluster_end + 1 - cur, extent_thresh,
 				newer_than, do_compress,
 				&sectors_defragged, max_to_defrag);
+
+		if (sectors_defragged > prev_sectors_defragged)
+			balance_dirty_pages_ratelimited(inode->i_mapping);
+
 		btrfs_inode_unlock(inode, 0);
 		if (ret < 0)
 			break;


