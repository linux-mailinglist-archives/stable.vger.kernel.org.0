Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DD53BB33C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233183AbhGDXRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234345AbhGDXPE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:15:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3454E61946;
        Sun,  4 Jul 2021 23:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440337;
        bh=BhsteIw3l4AE00L1oLCXZfn5zTp3Wjasw3aFgNRw/hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ND9kTSHMUUAc8gIsrnQeJrkD37+LGib/FQSVl/K9h/wS+GaFNtZ6MG3kJcqiFXQ1H
         OHamTcqmCBUh7LTkgxFx2ExVJDtafbJLmCFYnj749+hDVVpINCxbpIL/1jnI7Q4reN
         E1M2pi0y9tnJD7/XHg+eSeU8jA57BqFuIBaXZKcKtz2+RKFroNUdhPzopFCeomxvFr
         LuxGfJcTBqG6xYhS8f5cyOi20wuVDYFtB7rjMcp3D23hzZP1gXaFP011vjBzt6Gg+r
         zMGYhT22y3TYVA0aWS5RmkIGcIowaD+2rrhy2K0AL1lUr4xR2KwLqkKc3cr5LFu9CL
         3b+mTxDM8Hgcg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 17/20] btrfs: abort transaction if we fail to update the delayed inode
Date:   Sun,  4 Jul 2021 19:11:52 -0400
Message-Id: <20210704231155.1491795-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231155.1491795-1-sashal@kernel.org>
References: <20210704231155.1491795-1-sashal@kernel.org>
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
index 4d8f8a8c9c90..29e75fba5376 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1076,6 +1076,14 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
 	btrfs_delayed_inode_release_metadata(root, node);
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

