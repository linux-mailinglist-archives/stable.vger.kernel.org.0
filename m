Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8673CDCF1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239106AbhGSOyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243828AbhGSOv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:51:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D584C61220;
        Mon, 19 Jul 2021 15:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708730;
        bh=edYhVhPBZ6nLQwgbhCWYZLK8ZxOLO/7MzDwLQn6qqXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ri6X6qVvF6EuKccK5zs6kzrxRpu6x0a6aWW5neU0VWDN/5N2Yfjq59czXeUGgKiFT
         WRbBqX9kclMJXvxeFaXs5kSScE/b5n9i5osWznmPVN0AaKSB+M4+/Nky/aYuJIJBja
         +aiMowRQlAtI33KV9+JjTAusL5Fq4uasvwCaY86E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/421] btrfs: abort transaction if we fail to update the delayed inode
Date:   Mon, 19 Jul 2021 16:48:05 +0200
Message-Id: <20210719144948.720099337@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -1071,6 +1071,14 @@ err_out:
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



