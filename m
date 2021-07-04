Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6A93BB37D
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbhGDXSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233791AbhGDXOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBB0861987;
        Sun,  4 Jul 2021 23:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440231;
        bh=dCj9ICJeg4mgXnknTYKWEMI6svp4hO0x0Yk8UiVoHH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDkcDY43KCjXJtBB5jXkJMJ4lqNQK6FeaWMmWQ9pBC1pEVfj4bAiQ5z+F7nuYmSe3
         aHrPNotnmJ/1x9n56crCOfJyvo/Y2KGXn4PHSCHWQPaWj29O2AJBmKnQ8hkk6aKgaW
         iAy2d4dd0KSdW5R1ADIsJi+gukeicT5EObCp81kysIT8GpaBnTRLYHEKLi55uO2/WP
         XdJ/j8MKot+Ec+0bJpoA62nuPdnUiYkgwxGAulN6O3KUI+CnNNKsQ8EMBlBIj7LZu5
         DVzaQQisl8ZPvYkpLIg1NCtZhlnov9KEDhUmrl3gOuLkGEu3507ZBZYnLN/Rg8cInl
         3fIX94qJ4tguQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 41/50] btrfs: abort transaction if we fail to update the delayed inode
Date:   Sun,  4 Jul 2021 19:09:29 -0400
Message-Id: <20210704230938.1490742-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230938.1490742-1-sashal@kernel.org>
References: <20210704230938.1490742-1-sashal@kernel.org>
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
index c93254c9d67a..3dccbbe4a658 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1074,6 +1074,14 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
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

