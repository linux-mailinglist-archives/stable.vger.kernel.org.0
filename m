Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497B43C51C4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347323AbhGLHn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347783AbhGLHkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CE076193F;
        Mon, 12 Jul 2021 07:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075371;
        bh=s+FQXnMSp5R28L6o2VwwhnmnHan3x7+oy+lqwEb4Lhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NI4lXqgsMygbiFpAR4dQ2DplRdDZLdzxT0XM9VYkBIzVWpswdH5pfNHR10sipX3Bg
         ahys2RVMmEPehCaqZDp49doEnCVKdKE6SQ48NieQAellTmYfwVDgXXpmzeNHYM8LiB
         /gGg2U222gvdNtJjvw7riqy9YuFxzF3M68vE+0SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 196/800] btrfs: abort transaction if we fail to update the delayed inode
Date:   Mon, 12 Jul 2021 08:03:39 +0200
Message-Id: <20210712060940.729497646@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index 3091540fc22a..3bb8b919d2c1 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1050,6 +1050,14 @@ err_out:
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



