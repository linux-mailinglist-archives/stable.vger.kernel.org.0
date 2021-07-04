Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8D13BB14B
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhGDXLW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:11:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232434AbhGDXKW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A53C561474;
        Sun,  4 Jul 2021 23:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440066;
        bh=GeLV7MXhGJlzEIXUxEdmRAGvCyJSUmieVB1v6u/xxqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LVTsXBgg3KwfRNDdOIUY5/MzKm21HxC0hhsB6lZ/BRnUrSEh6R6AY/WRFtATjjWUs
         R9MI9Wzv5hxKs0+OcmyIZXz94ET+O8O92I6Jh2fsnFqM8DQdAiumonB3TJ9fku61jA
         lBYCL5P4ZuELAap0wiAnuO1HmVQeh85u2Mc0kAfB3huBnyrZaQESfjWmjnHt78lQur
         mHKMml7EYfzWW7dtp3P4dI96vOS2UCy31Zx39U5r/Ha+fUcaIwIZcEYkd7JJfsfVCz
         vYOBqEA+5Jrk1lp/QfUx7epgY3923fWh+hs7avy94GwgTXxWhvu+ipgRvNJj1YLzvE
         rhQkHblHW44Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 67/80] btrfs: abort transaction if we fail to update the delayed inode
Date:   Sun,  4 Jul 2021 19:06:03 -0400
Message-Id: <20210704230616.1489200-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230616.1489200-1-sashal@kernel.org>
References: <20210704230616.1489200-1-sashal@kernel.org>
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
index 2f73846d712f..55dad12a5ce0 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1066,6 +1066,14 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
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

