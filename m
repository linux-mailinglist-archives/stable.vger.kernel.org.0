Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6647B38A0F0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhETJ1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhETJ0l (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:26:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D33861244;
        Thu, 20 May 2021 09:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502720;
        bh=vl1vOu33I/RXXgQL9kciLWCSnKrL1nsrA9Ha0qHy+jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5bY6zw8Dm0mMC99bsjiQKBy2iETwMrc4cg3e1fVhnAT40L9sdVnnRAnoCocuArRS
         w8cWtfbjGgOen1VDG27kL76G0qDMJk+sbyAGK6ohF7c1/K+KuIV+zS2PEg1BGArCQF
         SVdY1eHQdRa/2QXzE+VE0BStfG7ZeRO9Atqr5qPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 28/45] ceph: dont clobber i_snap_caps on non-I_NEW inode
Date:   Thu, 20 May 2021 11:22:16 +0200
Message-Id: <20210520092054.441218228@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092053.516042993@linuxfoundation.org>
References: <20210520092053.516042993@linuxfoundation.org>
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
index 4418d4be2907..2fd1c48ac5d7 100644
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



