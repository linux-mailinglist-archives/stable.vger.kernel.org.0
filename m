Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5DB838A15E
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbhETJao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231502AbhETJ2o (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:28:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41416613BD;
        Thu, 20 May 2021 09:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502819;
        bh=dwoVuCUb3J9GHo+Zcez2ZhInblxN2QMERSoBVJmSQoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VAPcj0Ug6ISCEN8WTYhOjjjfqiuX5yW6Rp8cK+h5iz90gIDOPBLVUmXEeaF2lZWDx
         vzO9XPYGp5LVPAavCUrS9LUXWi7Z9ahBRNwQev00jaZdNb5San/UM5xVd4x/0H8i9l
         FyRN8e8yd+qPNotG7iG2xcN0FC3D0IUTaIYMFb6E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/47] ceph: dont clobber i_snap_caps on non-I_NEW inode
Date:   Thu, 20 May 2021 11:22:26 +0200
Message-Id: <20210520092054.458435183@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
References: <20210520092053.559923764@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit d3c51ae1b8cce5bdaf91a1ce32b33cf5626075dc ]

We want the snapdir to mirror the non-snapped directory's attributes for
most things, but i_snap_caps represents the caps granted on the snapshot
directory by the MDS itself. A misbehaving MDS could issue different
caps for the snapdir and we lose them here.

Only reset i_snap_caps when the inode is I_NEW. Also, move the setting
of i_op and i_fop inside the if block since they should never change
anyway.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/inode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 6bd2a6ced22a..790433cb849e 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -87,14 +87,15 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	inode->i_mtime = parent->i_mtime;
 	inode->i_ctime = parent->i_ctime;
 	inode->i_atime = parent->i_atime;
-	inode->i_op = &ceph_snapdir_iops;
-	inode->i_fop = &ceph_snapdir_fops;
-	ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
 	ci->i_rbytes = 0;
 	ci->i_btime = ceph_inode(parent)->i_btime;
 
-	if (inode->i_state & I_NEW)
+	if (inode->i_state & I_NEW) {
+		inode->i_op = &ceph_snapdir_iops;
+		inode->i_fop = &ceph_snapdir_fops;
+		ci->i_snap_caps = CEPH_CAP_PIN; /* so we can open */
 		unlock_new_inode(inode);
+	}
 
 	return inode;
 }
-- 
2.30.2



