Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0B63BB09E
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbhGDXJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:09:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230312AbhGDXId (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:08:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 930706144E;
        Sun,  4 Jul 2021 23:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439957;
        bh=gqGBzck34BEkVkHDOZOaqwSNwL8eNePvLSHbK4K9Jx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d+y5HaHObdcKWQ+dho+NVpXESl12Eygiv/bhJ5ViJoVd2N9ShprFI0biEU8nScHVN
         Jm6vawxU8+NXj1EoDIZggwuiuipWF9R0zQ/tgGaCz5Dfr1e/hv3/xyEr3Qb3ueceST
         1V5u2vVAPfrSIR6I+yBffoLuxBJn0jsSuEWX1L92xgEHp2R9AYW8VMfGdBv/u6ruVG
         Ge9WR+AehhuDKjCMRs6U8jvIoWZ2da/7pP2kPjWz1BYqk5WcXNRBWUkBRbVRZ19gCF
         5fLnP6EnMAzxOSAo30gqwLJotNZWO0PLz7d1wMgmzAczS7F/KuIhkNO60tR9kzjgxc
         9jvyE0Kh6sTeg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 71/85] btrfs: abort transaction if we fail to update the delayed inode
Date:   Sun,  4 Jul 2021 19:04:06 -0400
Message-Id: <20210704230420.1488358-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
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
index 3091540fc22a..3bb8b919d2c1 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1050,6 +1050,14 @@ static int __btrfs_update_delayed_inode(struct btrfs_trans_handle *trans,
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

