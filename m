Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0C8F6FF
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbfD3LuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731122AbfD3LuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6958121783;
        Tue, 30 Apr 2019 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625006;
        bh=xbKEgOhDb/KeV2EQJ1W78kNHva9NY2Y2U0+Mturycfg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BNXcJY/Gs0z2Lhg9Zymz0JLTZ9Lc1xdKdckpNwAU9D8lZ3/oNU0sq8icHK6T7UvJV
         eWjLOztLw+HNSFJEjC/FzZh3q5yU6jhLRl0OiUsAqeVurqEHqe/FukvmPn9Guw5D/R
         1mrg5pjWTIy0PvZIuV28MJYW6zw4C1rONwpo3q5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.0 48/89] ext4: fix some error pointer dereferences
Date:   Tue, 30 Apr 2019 13:38:39 +0200
Message-Id: <20190430113611.965705103@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 7159a986b4202343f6cca3bb8079ecace5816fd6 upstream.

We can't pass error pointers to brelse().

Fixes: fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/xattr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -829,6 +829,7 @@ int ext4_get_inode_usage(struct inode *i
 		bh = ext4_sb_bread(inode->i_sb, EXT4_I(inode)->i_file_acl, REQ_PRIO);
 		if (IS_ERR(bh)) {
 			ret = PTR_ERR(bh);
+			bh = NULL;
 			goto out;
 		}
 
@@ -2903,6 +2904,7 @@ int ext4_xattr_delete_inode(handle_t *ha
 			if (error == -EIO)
 				EXT4_ERROR_INODE(inode, "block %llu read error",
 						 EXT4_I(inode)->i_file_acl);
+			bh = NULL;
 			goto cleanup;
 		}
 		error = ext4_xattr_check_block(inode, bh);
@@ -3059,6 +3061,7 @@ ext4_xattr_block_cache_find(struct inode
 		if (IS_ERR(bh)) {
 			if (PTR_ERR(bh) == -ENOMEM)
 				return NULL;
+			bh = NULL;
 			EXT4_ERROR_INODE(inode, "block %lu read error",
 					 (unsigned long)ce->e_value);
 		} else if (ext4_xattr_cmp(header, BHDR(bh)) == 0) {


