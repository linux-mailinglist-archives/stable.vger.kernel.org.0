Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AE145BB1D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242203AbhKXMQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243639AbhKXMOm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:14:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8E6C61175;
        Wed, 24 Nov 2021 12:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755775;
        bh=2Fsm3nztAYtX6C8ybsZoeJWKl/AV67cfZiLxQEht6OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0P/erWULetu9/fKhu6oR4Ug1xlVlgv4uaOTm5Pu+bsM8s8pUNer/9VFa/jcqqNwpk
         TI3xj+G/66NuWRg6Khoj9LN4jaRgtxiJztQ8tgWejd3EFv0YZC9meTEbhlZ4zXPHLu
         lQHoiDFZMYKI0UxKBcKovilSaRLj8bxXLQZWX/54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 4.9 051/207] quota: check block number when reading the block in quota file
Date:   Wed, 24 Nov 2021 12:55:22 +0100
Message-Id: <20211124115705.580974669@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
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
@@ -487,6 +487,13 @@ static int remove_tree(struct qtree_mem_
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
@@ -586,6 +593,13 @@ static loff_t find_tree_dqentry(struct q
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


