Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148DF3BB397
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhGDXSZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233105AbhGDXOM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D06836198E;
        Sun,  4 Jul 2021 23:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440163;
        bh=jPgYzCeIi1fumnDhz8oWqd0fLbrhk13En1QRKcKWYx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AG0PDHBSfKXW6Z0Rkm/Gb7dFpep9dNZEnpoUGek9+CnPbesq/sztzLJOoUoeTQ8Hf
         aNMeSCvMaf2Nf53Ds0RuiXvHWIgd2vL1aCnNriiujmFQeGs6wJXqCNxaDfA/arBEw3
         tKYh1ctpG0bx5BhNxr87O7hRmoFkMxYiYLe0s1kiGsVR+vQ+KsaulJOrl0FyKjzGjZ
         aD1LDNM0gfVn4sawJ/E5HvJrL1L/hV0k/W1pP90kItjWKJLhdrh08dNZyF4bRikBQZ
         oi2vK6MZS9NQb9j5Bq48tnLhJME1hXVYBy9QiukdAoQnvPW98+Kmx4lcjnv66PuRh7
         ZCxlKWXa0Pe9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 59/70] btrfs: abort transaction if we fail to update the delayed inode
Date:   Sun,  4 Jul 2021 19:07:52 -0400
Message-Id: <20210704230804.1490078-59-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230804.1490078-1-sashal@kernel.org>
References: <20210704230804.1490078-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 04587ad9bef6ce9d510325b4ba9852b6129eebdb ]

If we fail to update the delayed inode we need to abort the transaction,
because we could leave an inode with the improper counts or some other
such corruption behind.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 3af06ef98b12..04422d929c23 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1073,6 +1073,14 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	btrfs_delayed_inode_release_metadata(fs_info, node, (ret < 0));
 	btrfs_release_delayed_inode(node);
 
+	/*
+	 * If we fail to update the delayed inode we need to abort the
+	 * transaction, because we could leave the inode with the improper
+	 * counts behind.
+	 */
+	if (ret && ret != -ENOENT)
+		btrfs_abort_transaction(trans, ret);
+
 	return ret;
 
 search:
-- 
2.30.2

