Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37C720624C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392754AbgFWU6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392358AbgFWUlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:41:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB20E20702;
        Tue, 23 Jun 2020 20:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944900;
        bh=EYfUsqhOZJT8+dBNddJKWqsHTg77cxZyUh/xaChIzeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R1vL4UI/65HUJg40Q/Hln13rESiJZozUUV9LUzZcl/ijMq4dqGcyvhBjCHpnamZG2
         Y1BYTCPEMiiZ31k6+cdTRt7CPDz17V5FYEjfhtKHt+WLHs0hj8h+3BPgjESvAinAk5
         +Wmvh2DnyRVULylgqjUWoR9zhLdq2u2d+jVE2tXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 169/206] afs: afs_write_end() should change i_size under the right lock
Date:   Tue, 23 Jun 2020 21:58:17 +0200
Message-Id: <20200623195325.332439399@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 1f32ef79897052ef7d3d154610d8d6af95abde83 ]

Fix afs_write_end() to change i_size under vnode->cb_lock rather than
->wb_lock so that it doesn't race with afs_vnode_commit_status() and
afs_getattr().

The ->wb_lock is only meant to guard access to ->wb_keys which isn't
accessed by that piece of code.

Fixes: 4343d00872e1 ("afs: Get rid of the afs_writeback record")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 53f329f61cc37..ec8d27cf92a5c 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -188,11 +188,11 @@ int afs_write_end(struct file *file, struct address_space *mapping,
 
 	i_size = i_size_read(&vnode->vfs_inode);
 	if (maybe_i_size > i_size) {
-		spin_lock(&vnode->wb_lock);
+		write_seqlock(&vnode->cb_lock);
 		i_size = i_size_read(&vnode->vfs_inode);
 		if (maybe_i_size > i_size)
 			i_size_write(&vnode->vfs_inode, maybe_i_size);
-		spin_unlock(&vnode->wb_lock);
+		write_sequnlock(&vnode->cb_lock);
 	}
 
 	if (!PageUptodate(page)) {
-- 
2.25.1



