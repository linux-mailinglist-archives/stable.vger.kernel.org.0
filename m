Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EB93CDA78
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245010AbhGSOgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245644AbhGSOev (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:34:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA6761283;
        Mon, 19 Jul 2021 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707676;
        bh=B5vxRINIZznjF8LwG/1vBkp1U3ghCxRMoSvKf/T0FhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEwgEUTOxwl49vznXNXM51/2+pD6m9+pTz6l0B6lqN+zDY6srlpwBz54XWuzje9Eq
         boAPU+t9GW+uoODnYXqtsqFWyWhUdzIA+cqdIlHnRrZxh5BF2o0su/prlJGt+3diFv
         ivL5a7AiESS1gzcIvUHb8D9fKqv42o8ukBCYuEhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Zhang Yi <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 013/315] ext4: cleanup in-core orphan list if ext4_truncate() failed to get a transaction handle
Date:   Mon, 19 Jul 2021 16:48:22 +0200
Message-Id: <20210719144943.313299181@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

commit b9a037b7f3c401d3c63e0423e56aef606b1ffaaf upstream.

In ext4_orphan_cleanup(), if ext4_truncate() failed to get a transaction
handle, it didn't remove the inode from the in-core orphan list, which
may probably trigger below error dump in ext4_destroy_inode() during the
final iput() and could lead to memory corruption on the later orphan
list changes.

 EXT4-fs (sda): Inode 6291467 (00000000b8247c67): orphan list check failed!
 00000000b8247c67: 0001f30a 00000004 00000000 00000023  ............#...
 00000000e24cde71: 00000006 014082a3 00000000 00000000  ......@.........
 0000000072c6a5ee: 00000000 00000000 00000000 00000000  ................
 ...

This patch fix this by cleanup in-core orphan list manually if
ext4_truncate() return error.

Cc: stable@kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210507071904.160808-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2614,8 +2614,15 @@ static void ext4_orphan_cleanup(struct s
 			inode_lock(inode);
 			truncate_inode_pages(inode->i_mapping, inode->i_size);
 			ret = ext4_truncate(inode);
-			if (ret)
+			if (ret) {
+				/*
+				 * We need to clean up the in-core orphan list
+				 * manually if ext4_truncate() failed to get a
+				 * transaction handle.
+				 */
+				ext4_orphan_del(NULL, inode);
 				ext4_std_error(inode->i_sb, ret);
+			}
 			inode_unlock(inode);
 			nr_truncates++;
 		} else {


