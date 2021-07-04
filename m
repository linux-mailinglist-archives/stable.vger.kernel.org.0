Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D90473BB31C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhGDXRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234127AbhGDXOy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B4E8619B7;
        Sun,  4 Jul 2021 23:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440278;
        bh=436KjXPDUAyaRo0vyJMFZ7Eo5h0pkw77g6hLestQpYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6D9CQJ6hg9z/NdBggD2iJ/A21vdsgN7SlhbY/fVMPhw7Z80Hcb7OvZIlzus7XBat
         Oa1uLU0fwgwMO+FR+OTxBLS0OeSA6xl0RZZCxN8r6+4IXG85H+icp/j+iUKqvlHdnQ
         xA86iw52j1MQgwJ8QCPZZxA3kv6XotM5z098yBXVTOXIX8IaSpvOwF0xPwrp9aQf6n
         hjkC+h3MU5IupcmBmV1gkCdTiGIN5cf8AkNA3fIOI//P0bvALWMHH388QzP+vvoZvW
         7y1eDY35EbYRjbuwTlhPdNGTqKU7B/o2FfOxHDlDiMjt0uMd7qQrpDWq5YRPZ90P63
         2UpDvdkrFeJjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 27/31] btrfs: abort transaction if we fail to update the delayed inode
Date:   Sun,  4 Jul 2021 19:10:39 -0400
Message-Id: <20210704231043.1491209-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
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
index f3994ee1a6e6..1fbe2dee1e70 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1071,6 +1071,14 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
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

