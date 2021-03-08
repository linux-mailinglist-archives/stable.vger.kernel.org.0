Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29763330E2C
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 13:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhCHMfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 07:35:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232127AbhCHMfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 07:35:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 82EBF64EBC;
        Mon,  8 Mar 2021 12:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615206916;
        bh=/deGr9Mnn5LBqI2w/zNfMGMTuJ2ozKZpFlyPbvb7kqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wz1eu6sLLQDMdtOB4g43fxL+IuaXk+Nw8WYuFqAirB45XfDU6craEOEy+Dn5//ScL
         Cdc6dEF3tTjBiXFpw9ottf7izfOOXnO764vF0ICqQUAGrMvdAQ96w8sYSNlzlE1q4c
         DH08mBOvZnHLTmRM49ZyoAPuMMQrk19jemRsSdVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 14/42] btrfs: unlock extents in btrfs_zero_range in case of quota reservation errors
Date:   Mon,  8 Mar 2021 13:30:40 +0100
Message-Id: <20210308122718.835648943@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308122718.120213856@linuxfoundation.org>
References: <20210308122718.120213856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

commit 4f6a49de64fd1b1dba5229c02047376da7cf24fd upstream.

If btrfs_qgroup_reserve_data returns an error (i.e quota limit reached)
the handling logic directly goes to the 'out' label without first
unlocking the extent range between lockstart, lockend. This results in
deadlocks as other processes try to lock the same extent.

Fixes: a7f8b1c2ac21 ("btrfs: file: reserve qgroup space after the hole punch range is locked")
CC: stable@vger.kernel.org # 5.10+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/file.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -3236,8 +3236,11 @@ reserve_space:
 			goto out;
 		ret = btrfs_qgroup_reserve_data(BTRFS_I(inode), &data_reserved,
 						alloc_start, bytes_to_reserve);
-		if (ret)
+		if (ret) {
+			unlock_extent_cached(&BTRFS_I(inode)->io_tree, lockstart,
+					     lockend, &cached_state);
 			goto out;
+		}
 		ret = btrfs_prealloc_file_range(inode, mode, alloc_start,
 						alloc_end - alloc_start,
 						i_blocksize(inode),


