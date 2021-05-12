Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5019337D27A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 20:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349786AbhELSKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 14:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:51784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352641AbhELSDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 14:03:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBE0961438;
        Wed, 12 May 2021 18:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620842563;
        bh=5MN9HffFvufeYdH7PbM0Tw3wI13Ccqot2r2gf4cvmwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKl6U8+C6mfRBPw4khWqQBE2TidmEQzfmyK9hSdgGFsSZN6DaDvXw6AM70vgIUy+V
         YZh2ftSmlQBugiGwnB/YdzFOS5wlK+aF5ROIcmLTxZMKQutinoCC7kSv25nTEAq4E5
         xp1eDLCokoyvoPZzv8SX+k/ffT0p9i1uwglTAOIoAYQz9iiraAIsPIk695DENL5onT
         8ZWIxKlsBEoXZuLbRHPmY7zcQDL1cl4dLrVrw/RfvhDhYqVEpxiwYXgqZDkTnhE/hN
         SoX4PQ5NUU2DCACdAueEQS1HO9yva3cvEdff8bKz0MSyFcol/7ThPvxOYbVx9LuCAJ
         Bak0URyKiXlqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 22/35] ceph: don't clobber i_snap_caps on non-I_NEW inode
Date:   Wed, 12 May 2021 14:01:52 -0400
Message-Id: <20210512180206.664536-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210512180206.664536-1-sashal@kernel.org>
References: <20210512180206.664536-1-sashal@kernel.org>
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
index 2caa6df0bcdf..5eb7eeab3828 100644
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

