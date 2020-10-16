Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8AA290164
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394998AbgJPJOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:14:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405796AbgJPJLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:11:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 431A020789;
        Fri, 16 Oct 2020 09:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839466;
        bh=JDYK2fvaEMqe0ctZcXUeHNpGFMH5xFt6jfhJEhdIJms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSDB6tFw686nUEcb5AVHMA2VtKoDlqQv2W/CNe6M3SgABH64NYhs6IZT9nLTjtdcn
         WHKa1T3YBCG8NgQVYydXXfl1/RL/ubgKLqCnlb3J5455FeHb5OOe182xDLWQpIP5mI
         2+69Uzr67nttywP2PNHdB3rLlUzOZycU2X4bf+HU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+9b33c9b118d77ff59b6f@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.8 14/14] reiserfs: Fix oops during mount
Date:   Fri, 16 Oct 2020 11:07:59 +0200
Message-Id: <20201016090437.856364597@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.153175229@linuxfoundation.org>
References: <20201016090437.153175229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit c2bb80b8bdd04dfe32364b78b61b6a47f717af52 upstream.

With suitably crafted reiserfs image and mount command reiserfs will
crash when trying to verify that XATTR_ROOT directory can be looked up
in / as that recurses back to xattr code like:

 xattr_lookup+0x24/0x280 fs/reiserfs/xattr.c:395
 reiserfs_xattr_get+0x89/0x540 fs/reiserfs/xattr.c:677
 reiserfs_get_acl+0x63/0x690 fs/reiserfs/xattr_acl.c:209
 get_acl+0x152/0x2e0 fs/posix_acl.c:141
 check_acl fs/namei.c:277 [inline]
 acl_permission_check fs/namei.c:309 [inline]
 generic_permission+0x2ba/0x550 fs/namei.c:353
 do_inode_permission fs/namei.c:398 [inline]
 inode_permission+0x234/0x4a0 fs/namei.c:463
 lookup_one_len+0xa6/0x200 fs/namei.c:2557
 reiserfs_lookup_privroot+0x85/0x1e0 fs/reiserfs/xattr.c:972
 reiserfs_fill_super+0x2b51/0x3240 fs/reiserfs/super.c:2176
 mount_bdev+0x24f/0x360 fs/super.c:1417

Fix the problem by bailing from reiserfs_xattr_get() when xattrs are not
yet initialized.

CC: stable@vger.kernel.org
Reported-by: syzbot+9b33c9b118d77ff59b6f@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/xattr.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -674,6 +674,13 @@ reiserfs_xattr_get(struct inode *inode,
 	if (get_inode_sd_version(inode) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
+	/*
+	 * priv_root needn't be initialized during mount so allow initial
+	 * lookups to succeed.
+	 */
+	if (!REISERFS_SB(inode->i_sb)->priv_root)
+		return 0;
+
 	dentry = xattr_lookup(inode, name, XATTR_REPLACE);
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);


