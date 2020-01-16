Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 037B713F563
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729950AbgAPSzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 13:55:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389187AbgAPRHa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:07:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69DD32081E;
        Thu, 16 Jan 2020 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194450;
        bh=9e5byxJIih88ju7Q5B5t6AA+zLK+ZzuP/KEvyl4o2mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjAHG8TUPKQ6ek3lDq8+EyVOwHb8G3C1NKEMFCaqib7D7MfUgpKrsgpglIxBYmBpS
         AYnTmMshOI9F2E4FJYUGpMVX+pv1G4ij+p+iMuGraHMzv/XIDdFpNmTvWav3MDp3i8
         NPM88Drkm274Yc5ag0McSrO/UrRqeM3qcad4tM78=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 360/671] afs: Fix key leak in afs_release() and afs_evict_inode()
Date:   Thu, 16 Jan 2020 11:59:58 -0500
Message-Id: <20200116170509.12787-97-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit a1b879eefc2b34cd3f17187ef6fc1cf3960e9518 ]

Fix afs_release() to go through the cleanup part of the function if
FMODE_WRITE is set rather than exiting through vfs_fsync() (which skips the
cleanup).  The cleanup involves discarding the refs on the key used for
file ops and the writeback key record.

Also fix afs_evict_inode() to clean up any left over wb keys attached to
the inode/vnode when it is removed.

Fixes: 5a8132761609 ("afs: Do better accretion of small writes on newly created content")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/file.c  | 7 ++++---
 fs/afs/inode.c | 1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index 843d3b970b84..0bd78df6a64e 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -169,11 +169,12 @@ int afs_release(struct inode *inode, struct file *file)
 {
 	struct afs_vnode *vnode = AFS_FS_I(inode);
 	struct afs_file *af = file->private_data;
+	int ret = 0;
 
 	_enter("{%x:%u},", vnode->fid.vid, vnode->fid.vnode);
 
 	if ((file->f_mode & FMODE_WRITE))
-		return vfs_fsync(file, 0);
+		ret = vfs_fsync(file, 0);
 
 	file->private_data = NULL;
 	if (af->wb)
@@ -181,8 +182,8 @@ int afs_release(struct inode *inode, struct file *file)
 	key_put(af->key);
 	kfree(af);
 	afs_prune_wb_keys(vnode);
-	_leave(" = 0");
-	return 0;
+	_leave(" = %d", ret);
+	return ret;
 }
 
 /*
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 0726e40db0f8..718fab2f151a 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -541,6 +541,7 @@ void afs_evict_inode(struct inode *inode)
 	}
 #endif
 
+	afs_prune_wb_keys(vnode);
 	afs_put_permits(rcu_access_pointer(vnode->permit_cache));
 	key_put(vnode->lock_key);
 	vnode->lock_key = NULL;
-- 
2.20.1

