Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE69137D2A7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353219AbhELSK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240842AbhELSEx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:04:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E5EB61444;
        Wed, 12 May 2021 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842622;
        bh=dwoVuCUb3J9GHo+Zcez2ZhInblxN2QMERSoBVJmSQoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVojfN5w4zXK96cauSY7b6XAWfkAgLv8CbC5+q52iqlFkp1pN7ZOxs2UPpGGdMuDK
         T1lgo06Cfr0QBajV4ZbW4KyDvhleC+OXVBPJgiNS3H57fujewpoG7I4tfa6gQKb8Ve
         wO5aCzZ7iqm5fqW81MasXbclu9cD3pJkJt24En/d31wrxHTVhZd02oLZAjK5lSK3r9
         UkfZ5e40bxAmPHUnGd8iftp4Re9ZBb03hUgmKJ45p3S6e0pITlEwMrjsJpCQx9ZczK
         s7aJYh2cqYcGUiZWc58owq9dr4vgEMBCWxaWRy7OtyGEo0jiOKQ09j/KIx8c7XRh/S
         vbuCBMWe3AH6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 21/34] ceph: don't clobber i_snap_caps on non-I_NEW inode
Date:   Wed, 12 May 2021 14:02:52 -0400
Message-Id: <20210512180306.664925-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180306.664925-1-sashal@kernel.org>
References: <20210512180306.664925-1-sashal@kernel.org>
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

