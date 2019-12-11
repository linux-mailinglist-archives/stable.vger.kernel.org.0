Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F7C11B71B
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbfLKQF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbfLKPMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B66124683;
        Wed, 11 Dec 2019 15:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077168;
        bh=AYCKDEj7tCppYmTX/i7HqzmL1YG16MndjEzUSKcYsA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzMfoyfB612bzquUkTbTtH0MMYZX1WdSzfb6wyROUbdaVjmTKO1sDWLLm7pd1Pzph
         7HVI4NI/Jf5nzTMY4Jn4/YE/ICAvkfDzRlLq9aO+AzGjyejcBz1KGwDad5lhGWYETa
         1yutuBHx8ons3mSM38w4L4H6fUw2nkE+SbRhemCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 041/105] afs: Fix race in commit bulk status fetch
Date:   Wed, 11 Dec 2019 16:05:30 +0100
Message-Id: <20191211150237.770839148@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit a28f239e296767ebf4ec4ae8a9ecb57d0d444b3f ]

When a lookup is done, the afs filesystem will perform a bulk status-fetch
operation on the requested vnode (file) plus the next 49 other vnodes from
the directory list (in AFS, directory contents are downloaded as blobs and
parsed locally).  When the results are received, it will speculatively
populate the inode cache from the extra data.

However, if the lookup races with another lookup on the same directory, but
for a different file - one that's in the 49 extra fetches, then if the bulk
status-fetch operation finishes first, it will try and update the inode
from the other lookup.

If this other inode is still in the throes of being created, however, this
will cause an assertion failure in afs_apply_status():

	BUG_ON(test_bit(AFS_VNODE_UNSET, &vnode->flags));

on or about fs/afs/inode.c:175 because it expects data to be there already
that it can compare to.

Fix this by skipping the update if the inode is being created as the
creator will presumably set up the inode with the same information.

Fixes: 39db9815da48 ("afs: Fix application of the results of a inline bulk status fetch")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 139b4e3cc9464..f4fdf3eaa5709 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -803,7 +803,12 @@ success:
 			continue;
 
 		if (cookie->inodes[i]) {
-			afs_vnode_commit_status(&fc, AFS_FS_I(cookie->inodes[i]),
+			struct afs_vnode *iv = AFS_FS_I(cookie->inodes[i]);
+
+			if (test_bit(AFS_VNODE_UNSET, &iv->flags))
+				continue;
+
+			afs_vnode_commit_status(&fc, iv,
 						scb->cb_break, NULL, scb);
 			continue;
 		}
-- 
2.20.1



