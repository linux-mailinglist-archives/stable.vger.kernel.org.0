Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDEB37CCB6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhELQqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:46:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243418AbhELQlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4423061E40;
        Wed, 12 May 2021 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835444;
        bh=PC13ywWpVSEdkAQdQke1wE+iKrDctwrGR6xcHC30ldg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PgxL2gzuw/akrmNygIdu7WB0VdsHu4x8Q9Et0bWvkJF408JzaD8qg0oRghA8WQXxH
         MfmQB7omoVefDHOa5A95SQ1jUNMfJ4/w+Dri5TrEv2/ZNpqf4H9YHq1Jkp/LStJey8
         ZfcZCGxY/xhJcQ3PaFw5lmx/eQlUUWeKfX+6OhCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 348/677] afs: Fix updating of i_mode due to 3rd party change
Date:   Wed, 12 May 2021 16:46:34 +0200
Message-Id: <20210512144848.873474197@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 6e1eb04a87f954eb06a89ee6034c166351dfff6e ]

Fix afs_apply_status() to mask off the irrelevant bits from status->mode
when OR'ing them into i_mode.  This can happen when a 3rd party chmod
occurs.

Also fix afs_inode_init_from_status() to mask off the mode bits when
initialising i_mode.

Fixes: 260a980317da ("[AFS]: Add "directory write" support.")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 12be88716e4c..5a70c09f5325 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -102,13 +102,13 @@ static int afs_inode_init_from_status(struct afs_operation *op,
 
 	switch (status->type) {
 	case AFS_FTYPE_FILE:
-		inode->i_mode	= S_IFREG | status->mode;
+		inode->i_mode	= S_IFREG | (status->mode & S_IALLUGO);
 		inode->i_op	= &afs_file_inode_operations;
 		inode->i_fop	= &afs_file_operations;
 		inode->i_mapping->a_ops	= &afs_fs_aops;
 		break;
 	case AFS_FTYPE_DIR:
-		inode->i_mode	= S_IFDIR | status->mode;
+		inode->i_mode	= S_IFDIR |  (status->mode & S_IALLUGO);
 		inode->i_op	= &afs_dir_inode_operations;
 		inode->i_fop	= &afs_dir_file_operations;
 		inode->i_mapping->a_ops	= &afs_dir_aops;
@@ -198,7 +198,7 @@ static void afs_apply_status(struct afs_operation *op,
 	if (status->mode != vnode->status.mode) {
 		mode = inode->i_mode;
 		mode &= ~S_IALLUGO;
-		mode |= status->mode;
+		mode |= status->mode & S_IALLUGO;
 		WRITE_ONCE(inode->i_mode, mode);
 	}
 
-- 
2.30.2



