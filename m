Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620A6450B2F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236942AbhKORU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:20:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237282AbhKORTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:19:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 471476324E;
        Mon, 15 Nov 2021 17:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996435;
        bh=0UJsD+MpjVUuJ9H0NfNrgQGtobz3JnXpkSNS+zVVtQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acpI8vT6r/aVe6nSDwMMXMzES1z7qWzhagwa3FGS4D4krK2vH2sePMkOEBEbGZUpW
         dmsu+INgQdyVucG+8QyYdH1aH8uGTyOZEBlhNGScNURUnv4OiS/DNoEX33aljdKdZ3
         4DixHtqjGSwZjJwffg+YrYs6rCKJeitEt7i0VA+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 105/355] quota: check block number when reading the block in quota file
Date:   Mon, 15 Nov 2021 18:00:29 +0100
Message-Id: <20211115165317.201466963@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Yi <yi.zhang@huawei.com>

commit 9bf3d20331295b1ecb81f4ed9ef358c51699a050 upstream.

The block number in the quota tree on disk should be smaller than the
v2_disk_dqinfo.dqi_blocks. If the quota file was corrupted, we may be
allocating an 'allocated' block and that would lead to a loop in a tree,
which will probably trigger oops later. This patch adds a check for the
block number in the quota tree to prevent such potential issue.

Link: https://lore.kernel.org/r/20211008093821.1001186-2-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Cc: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/quota/quota_tree.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/quota/quota_tree.c
+++ b/fs/quota/quota_tree.c
@@ -488,6 +488,13 @@ static int remove_tree(struct qtree_mem_
 		goto out_buf;
 	}
 	newblk = le32_to_cpu(ref[get_index(info, dquot->dq_id, depth)]);
+	if (newblk < QT_TREEOFF || newblk >= info->dqi_blocks) {
+		quota_error(dquot->dq_sb, "Getting block too big (%u >= %u)",
+			    newblk, info->dqi_blocks);
+		ret = -EUCLEAN;
+		goto out_buf;
+	}
+
 	if (depth == info->dqi_qtree_depth - 1) {
 		ret = free_dqentry(info, dquot, newblk);
 		newblk = 0;
@@ -587,6 +594,13 @@ static loff_t find_tree_dqentry(struct q
 	blk = le32_to_cpu(ref[get_index(info, dquot->dq_id, depth)]);
 	if (!blk)	/* No reference? */
 		goto out_buf;
+	if (blk < QT_TREEOFF || blk >= info->dqi_blocks) {
+		quota_error(dquot->dq_sb, "Getting block too big (%u >= %u)",
+			    blk, info->dqi_blocks);
+		ret = -EUCLEAN;
+		goto out_buf;
+	}
+
 	if (depth < info->dqi_qtree_depth - 1)
 		ret = find_tree_dqentry(info, dquot, blk, depth+1);
 	else


