Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1424148192
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390993AbgAXLVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391007AbgAXLVF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:21:05 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84E4F20702;
        Fri, 24 Jan 2020 11:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864864;
        bh=cEaiigIRC+oQi2bGiOCmq13x7YNUr+eb0hcx3dQmyD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnYuzVSAe5YOxc6DDMW9HbjL+iwvV8u3bvJrz3v8VCRNvqCr37+Ry8QA3WDHrWlbS
         dI5o4UpUPdHtm1ePSSUF0C/KvgwN3v92DzQ0EfzeSnFRcXarLKfeEG/sCeuZy/buEp
         T9WafxWI655bAwAOO9Ch5NxwuNYS8duxZ2txXMZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 375/639] afs: Fix key leak in afs_release() and afs_evict_inode()
Date:   Fri, 24 Jan 2020 10:29:05 +0100
Message-Id: <20200124093133.996498676@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 843d3b970b845..0bd78df6a64e6 100644
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
index 0726e40db0f8b..718fab2f151a1 100644
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



