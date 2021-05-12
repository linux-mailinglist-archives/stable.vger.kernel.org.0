Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5572D37D253
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236716AbhELSIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:08:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352186AbhELSCs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FB556142D;
        Wed, 12 May 2021 18:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842500;
        bh=vl1vOu33I/RXXgQL9kciLWCSnKrL1nsrA9Ha0qHy+jA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QldyYYPdlD28GDEeV3sWdr4LNoAw7ORrkf/ZhEvAq+61x/Ab3zCzdcZoA7ykpYxzh
         6zcdmduCqsoq4O37Nqdc4FKy1rSq45IUxCy6pjGdRmZ9kfUW8u+vdNru46lNGHIeTC
         2AQ6R2g0gzQyYwUshtPs7nvlgMxQYMfF04NtgdNISu/dwq8bhjkRyz5mU8uP42dYcX
         qgtxjHJ+gvM2jHActEfVoFewHj0a6HjunVDoZpZBcwf0J7u/700AE04nEjV8usCP+C
         JSHpqV71k1y8GwA704e21YTIVI6+9G4g0mvgDFOoHXH8sV4QCAyIw0g6JqHL8cCZ4t
         EJb0SxeN3YezQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 24/37] ceph: don't clobber i_snap_caps on non-I_NEW inode
Date:   Wed, 12 May 2021 14:00:51 -0400
Message-Id: <20210512180104.664121-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180104.664121-1-sashal@kernel.org>
References: <20210512180104.664121-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

