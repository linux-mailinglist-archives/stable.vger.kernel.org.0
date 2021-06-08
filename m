Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666AC3A039E
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238144AbhFHTTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237556AbhFHTQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:16:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCAB66197D;
        Tue,  8 Jun 2021 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178282;
        bh=vAPH0TNGLrjtCoRIcq5nfXMuSLVkb6lKfxUQIrkhNrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2htL8Bn3VSijtMFBskiNs64UgjNjlgSSFrcCxZ5rFUmuj05eZj0w50v20nSwThke
         LJ3UIC05c21gZpN7B4NK9wgksSVqQT2wLkAxIpkI26bvVTdkHekF0ybfPKjHLM2iA3
         KD5lnE0R5yUAksi/Vibk3QCE4D/1Bs6SQUCTocpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Qu Wenruo <wqu@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.12 144/161] btrfs: check error value from btrfs_update_inode in tree log
Date:   Tue,  8 Jun 2021 20:27:54 +0200
Message-Id: <20210608175950.317992821@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit f96d44743a44e3332f75d23d2075bb8270900e1d upstream.

Error injection testing uncovered a case where we ended up with invalid
link counts on an inode.  This happened because we failed to notice an
error when updating the inode while replaying the tree log, and
committed the transaction with an invalid file system.

Fix this by checking the return value of btrfs_update_inode.  This
resolved the link count errors I was seeing, and we already properly
handle passing up the error values in these paths.

CC: stable@vger.kernel.org # 4.4+
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-log.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1574,7 +1574,9 @@ static noinline int add_inode_ref(struct
 			if (ret)
 				goto out;
 
-			btrfs_update_inode(trans, root, BTRFS_I(inode));
+			ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
+			if (ret)
+				goto out;
 		}
 
 		ref_ptr = (unsigned long)(ref_ptr + ref_struct_size) + namelen;
@@ -1749,7 +1751,9 @@ static noinline int fixup_inode_link_cou
 
 	if (nlink != inode->i_nlink) {
 		set_nlink(inode, nlink);
-		btrfs_update_inode(trans, root, BTRFS_I(inode));
+		ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
+		if (ret)
+			goto out;
 	}
 	BTRFS_I(inode)->index_cnt = (u64)-1;
 


