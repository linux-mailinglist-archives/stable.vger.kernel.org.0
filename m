Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A99F79C
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbfD3Lp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730397AbfD3Lp1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:45:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D53E21734;
        Tue, 30 Apr 2019 11:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624726;
        bh=it4y10QxzMYL79fRr888y34aBF6kHIuMRynzRyZCdRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X+wcKkOcbZ9ba29yxulSy+WZ0rI+X3TOSUGyCVt14eeJkcXkluG3nGHvq33otPILE
         G0k2DwxZyfU24Bx2GqFiQQnpoK7qNj0L81Y2QpU//Boc7851GRxKkMw04pfwknhiwf
         6qOwKZOv88XESLfOI2Hz9BEV7wRDQHc+VecGTK5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 014/100] ext4: fix some error pointer dereferences
Date:   Tue, 30 Apr 2019 13:37:43 +0200
Message-Id: <20190430113609.275098560@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7159a986b4202343f6cca3bb8079ecace5816fd6 ]

We can't pass error pointers to brelse().

Fixes: fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c0ba5206cd9d..006c277dc22e 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -829,6 +829,7 @@ int ext4_get_inode_usage(struct inode *inode, qsize_t *usage)
 		bh = ext4_sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl, REQ_PRIO);
 		if (IS_ERR(bh)) {
 			ret = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 
@@ -2907,6 +2908,7 @@ int ext4_xattr_delete_inode(handle_t *handle, struct inode *inode,
 			if (error == -EIO)
 				EXT4_ERROR_INODE(inode, "block %llu read error",
 						 EXT4_I(inode)->i_file_acl);
+			bh = NULL;
 			goto cleanup;
 		}
 		error = ext4_xattr_check_block(inode, bh);
@@ -3063,6 +3065,7 @@ ext4_xattr_block_cache_find(struct inode *inode,
 		if (IS_ERR(bh)) {
 			if (PTR_ERR(bh) == -ENOMEM)
 				return NULL;
+			bh = NULL;
 			EXT4_ERROR_INODE(inode, "block %lu read error",
 					 (unsigned long)ce->e_value);
 		} else if (ext4_xattr_cmp(header, BHDR(bh)) == 0) {
-- 
2.19.1



