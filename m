Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92901E2B49
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390066AbgEZTDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391245AbgEZTDi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:03:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C6A220873;
        Tue, 26 May 2020 19:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519817;
        bh=pk+RbUHryKklL3wHebCtBVLElvjUtmNrFWmuel0RygE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kW2o/nc/PR7IobC+QL57C3WLEd2NdMExm8CYbF9CXnviWY8290JUUQeCycmeQzO3A
         rbAta6cVlcMnCYi9ZzFzGZ7pKqS8PVOEwahi6mrKGnPvZhyDwb5V8THl2Rs0LMsj7C
         4mp/q4A7gyq9X6eQ2gBZrEgpa4TprLhM+oDPgBY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/81] ubifs: remove broken lazytime support
Date:   Tue, 26 May 2020 20:52:46 +0200
Message-Id: <20200526183927.127913799@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183923.108515292@linuxfoundation.org>
References: <20200526183923.108515292@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit ecf84096a526f2632ee85c32a3d05de3fa60ce80 ]

When "ubifs: introduce UBIFS_ATIME_SUPPORT to ubifs" introduced atime
support to ubifs, it also added lazytime support.  As far as I can tell
the lazytime support is terminally broken, as it causes
mark_inode_dirty_sync to be called from __writeback_single_inode, which
will then trigger the locking assert in ubifs_dirty_inode.  Just remove
the broken lazytime support for now, it can be added back later,
especially as some infrastructure changes should make that easier soon.

Fixes: 8c1c5f263833 ("ubifs: introduce UBIFS_ATIME_SUPPORT to ubifs")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ubifs/file.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 65b4f63349c7..d7d2fdda4bbd 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1391,7 +1391,6 @@ int ubifs_update_time(struct inode *inode, struct timespec64 *time,
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 	struct ubifs_budget_req req = { .dirtied_ino = 1,
 			.dirtied_ino_d = ALIGN(ui->data_len, 8) };
-	int iflags = I_DIRTY_TIME;
 	int err, release;
 
 	err = ubifs_budget_space(c, &req);
@@ -1406,11 +1405,8 @@ int ubifs_update_time(struct inode *inode, struct timespec64 *time,
 	if (flags & S_MTIME)
 		inode->i_mtime = *time;
 
-	if (!(inode->i_sb->s_flags & SB_LAZYTIME))
-		iflags |= I_DIRTY_SYNC;
-
 	release = ui->dirty;
-	__mark_inode_dirty(inode, iflags);
+	__mark_inode_dirty(inode, I_DIRTY_SYNC);
 	mutex_unlock(&ui->ui_mutex);
 	if (release)
 		ubifs_release_budget(c, &req);
-- 
2.25.1



