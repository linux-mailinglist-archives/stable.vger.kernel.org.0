Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3E224738E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388021AbgHQS5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:57:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730786AbgHQPuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:50:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD5A22075B;
        Mon, 17 Aug 2020 15:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679407;
        bh=7I7wMWfRX9r4SAflRbqpRzdFlV9XBamOheD4+rfJB1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GX2/vHITF8K0ScHokh8iLJcN3Yjl0I1FON8ss4tx8A9HUu8nTswRV4xCJavyXBxY7
         w8ruFWSASZtkCjNAbvvMGl/EA3/mZGoNUXUkKEBSq/t9q/H5YJV5kWMhvoGrX/Ve0f
         Jr+QSNur4DJ5+gImu9hn43fej0aD492mc1TzEifI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 201/393] kernfs: do not call fsnotify() with name without a parent
Date:   Mon, 17 Aug 2020 17:14:11 +0200
Message-Id: <20200817143829.375232400@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 9991bb84b27a2594187898f261866cfc50255454 ]

When creating an FS_MODIFY event on inode itself (not on parent)
the file_name argument should be NULL.

The change to send a non NULL name to inode itself was done on purpuse
as part of another commit, as Tejun writes: "...While at it, supply the
target file name to fsnotify() from kernfs_node->name.".

But this is wrong practice and inconsistent with inotify behavior when
watching a single file.  When a child is being watched (as opposed to the
parent directory) the inotify event should contain the watch descriptor,
but not the file name.

Fixes: df6a58c5c5aa ("kernfs: don't depend on d_find_any_alias()...")
Link: https://lore.kernel.org/r/20200708111156.24659-5-amir73il@gmail.com
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 34366db3620d6..2a1879a6e7957 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -912,7 +912,7 @@ static void kernfs_notify_workfn(struct work_struct *work)
 		}
 
 		fsnotify(inode, FS_MODIFY, inode, FSNOTIFY_EVENT_INODE,
-			 &name, 0);
+			 NULL, 0);
 		iput(inode);
 	}
 
-- 
2.25.1



