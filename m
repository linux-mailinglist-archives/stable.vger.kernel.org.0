Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E60D451339
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347948AbhKOTtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245500AbhKOTUk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D223363553;
        Mon, 15 Nov 2021 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001342;
        bh=W26zB9E6EDd7hH8yizdM0dWEaX7T3fJN9qCMPqJPU4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BT80yejrgpPPR4hzT+AQdDncY3mVMCjBOrQt0NM7agaEYTWXCAf95cKss8RHtWWsG
         4IaRDe9xFadDfy+0l7sJNR9h47+bpsjP/mc2Qv5an/DsJtF4WKrfBVYKowSyQNBqX3
         YAjY/eGdRKY2dqxi5lQSCZ9bEu5PTTnwaNZiopGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        stable@kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 154/917] quota: check block number when reading the block in quota file
Date:   Mon, 15 Nov 2021 17:54:09 +0100
Message-Id: <20211115165433.987993175@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
@@ -479,6 +479,13 @@ static int remove_tree(struct qtree_mem_
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
@@ -578,6 +585,13 @@ static loff_t find_tree_dqentry(struct q
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


