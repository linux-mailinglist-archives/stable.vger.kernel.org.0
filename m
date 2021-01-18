Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974392F9F86
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391404AbhARM0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:26:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390846AbhARLpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF88C22D70;
        Mon, 18 Jan 2021 11:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970319;
        bh=Zgk/19i1yMlq4oz+1uWUniWM+GHBsARsGPeYHZlzWAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UArGULIYhKd3EtDFlPVWoFQghGR2diheLiXWDZlv7ejIn509A1JregSx35C96NNqy
         1Knyzmlu82KTMORR/dLupAjr4fGkz/IMg+HDH/ZRUqxv/l7ztCe8t4VGjUSvrhSu+6
         XJx2ZWktZqZWRjgZ5lpPJuJERYap0HnKDCxJcMVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 129/152] NFS: nfs_delegation_find_inode_server must first reference the superblock
Date:   Mon, 18 Jan 2021 12:35:04 +0100
Message-Id: <20210118113358.906826201@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 113aac6d567bda783af36d08f73bfda47d8e9a40 upstream.

Before referencing the inode, we must ensure that the superblock can be
referenced. Otherwise, we can end up with iput() calling superblock
operations that are no longer valid or accessible.

Fixes: e39d8a186ed0 ("NFSv4: Fix an Oops during delegation callbacks")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/delegation.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/nfs/delegation.c
+++ b/fs/nfs/delegation.c
@@ -1011,22 +1011,24 @@ nfs_delegation_find_inode_server(struct
 				 const struct nfs_fh *fhandle)
 {
 	struct nfs_delegation *delegation;
-	struct inode *freeme, *res = NULL;
+	struct super_block *freeme = NULL;
+	struct inode *res = NULL;
 
 	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
 		spin_lock(&delegation->lock);
 		if (delegation->inode != NULL &&
 		    !test_bit(NFS_DELEGATION_REVOKED, &delegation->flags) &&
 		    nfs_compare_fh(fhandle, &NFS_I(delegation->inode)->fh) == 0) {
-			freeme = igrab(delegation->inode);
-			if (freeme && nfs_sb_active(freeme->i_sb))
-				res = freeme;
+			if (nfs_sb_active(server->super)) {
+				freeme = server->super;
+				res = igrab(delegation->inode);
+			}
 			spin_unlock(&delegation->lock);
 			if (res != NULL)
 				return res;
 			if (freeme) {
 				rcu_read_unlock();
-				iput(freeme);
+				nfs_sb_deactive(freeme);
 				rcu_read_lock();
 			}
 			return ERR_PTR(-EAGAIN);


