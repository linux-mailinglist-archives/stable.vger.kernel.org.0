Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDACEEEE2
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389254AbfKDWCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:60586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389239AbfKDWCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:02:18 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1906920650;
        Mon,  4 Nov 2019 22:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904936;
        bh=J7DWm/MkD3ZkOtimVRVrecFAfLiQAyHECZtzD/l+wNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NYTB3t6X7n0Mv6yAxdLNnpX6bxOVKbUcmOVlGiJlCnQL6umhPSDh8MbZNJEXq5XGG
         Xzepg8JUmvPFEZtnC4ZWcJo+dYti5uhjz49DC2OA6x2by1O6FHcDNKaDFuSvrH4uYm
         uiubhc5J/d2SlmPQ9YU4Ae7KvaCMsNNJ0T+EES0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia Guo <guojia12@huawei.com>,
        Yiwen Jiang <jiangyiwen@huawei.com>,
        Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <joseph.qi@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/149] ocfs2: clear zero in unaligned direct IO
Date:   Mon,  4 Nov 2019 22:44:38 +0100
Message-Id: <20191104212142.519464337@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212126.090054740@linuxfoundation.org>
References: <20191104212126.090054740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia Guo <guojia12@huawei.com>

[ Upstream commit 7a243c82ea527cd1da47381ad9cd646844f3b693 ]

Unused portion of a part-written fs-block-sized block is not set to zero
in unaligned append direct write.This can lead to serious data
inconsistencies.

Ocfs2 manage disk with cluster size(for example, 1M), part-written in
one cluster will change the cluster state from UN-WRITTEN to WRITTEN,
VFS(function dio_zero_block) doesn't do the cleaning because bh's state
is not set to NEW in function ocfs2_dio_wr_get_block when we write a
WRITTEN cluster.  For example, the cluster size is 1M, file size is 8k
and we direct write from 14k to 15k, then 12k~14k and 15k~16k will
contain dirty data.

We have to deal with two cases:
 1.The starting position of direct write is outside the file.
 2.The starting position of direct write is located in the file.

We need set bh's state to NEW in the first case.  In the second case, we
need mapped twice because bh's state of area out file should be set to
NEW while area in file not.

[akpm@linux-foundation.org: coding style fixes]
Link: http://lkml.kernel.org/r/5292e287-8f1a-fd4a-1a14-661e555e0bed@huawei.com
Signed-off-by: Jia Guo <guojia12@huawei.com>
Reviewed-by: Yiwen Jiang <jiangyiwen@huawei.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/aops.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index 7578bd507c70b..dc773e163132c 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2153,13 +2153,30 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	struct ocfs2_dio_write_ctxt *dwc = NULL;
 	struct buffer_head *di_bh = NULL;
 	u64 p_blkno;
-	loff_t pos = iblock << inode->i_sb->s_blocksize_bits;
+	unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
+	loff_t pos = iblock << i_blkbits;
+	sector_t endblk = (i_size_read(inode) - 1) >> i_blkbits;
 	unsigned len, total_len = bh_result->b_size;
 	int ret = 0, first_get_block = 0;
 
 	len = osb->s_clustersize - (pos & (osb->s_clustersize - 1));
 	len = min(total_len, len);
 
+	/*
+	 * bh_result->b_size is count in get_more_blocks according to write
+	 * "pos" and "end", we need map twice to return different buffer state:
+	 * 1. area in file size, not set NEW;
+	 * 2. area out file size, set  NEW.
+	 *
+	 *		   iblock    endblk
+	 * |--------|---------|---------|---------
+	 * |<-------area in file------->|
+	 */
+
+	if ((iblock <= endblk) &&
+	    ((iblock + ((len - 1) >> i_blkbits)) > endblk))
+		len = (endblk - iblock + 1) << i_blkbits;
+
 	mlog(0, "get block of %lu at %llu:%u req %u\n",
 			inode->i_ino, pos, len, total_len);
 
@@ -2243,6 +2260,9 @@ static int ocfs2_dio_wr_get_block(struct inode *inode, sector_t iblock,
 	if (desc->c_needs_zero)
 		set_buffer_new(bh_result);
 
+	if (iblock > endblk)
+		set_buffer_new(bh_result);
+
 	/* May sleep in end_io. It should not happen in a irq context. So defer
 	 * it to dio work queue. */
 	set_buffer_defer_completion(bh_result);
-- 
2.20.1



