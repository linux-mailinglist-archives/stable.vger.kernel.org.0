Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338C63CDAB3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244235AbhGSOh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244947AbhGSOfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43ACF60720;
        Mon, 19 Jul 2021 15:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707790;
        bh=c9FPzrAZJ4DPglSf/wv9oOPPMbR8tL55X3iSkGq5r6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6AgjRhj1ehuJf4385jIXlHDyZfIVHx200lmG73Mr1KjGz2hC/HRqo2gN2acHH/5y
         YQOC5OP+KyoJHS1CcyN5j3XQyRmb/b6LmXBImRHKb/QYLejFH8uF2sIkn7cKY/I+Nm
         O0+G3J+tohm3opb9yK07IGGDI4kIRedcaINkDuoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 057/315] btrfs: abort transaction if we fail to update the delayed inode
Date:   Mon, 19 Jul 2021 16:49:06 +0200
Message-Id: <20210719144944.735148307@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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
index 3631154d8245..9f276d1dd29c 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1105,6 +1105,14 @@ err_out:
 	btrfs_delayed_inode_release_metadata(fs_info, node);
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



