Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452D329BF71
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:07:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1815050AbgJ0RBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:01:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793827AbgJ0PIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:32 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FEB020657;
        Tue, 27 Oct 2020 15:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811311;
        bh=fHx7BqSEQSgwURzHFbfofNHRxUv8GxX2lB69b0Sp5qA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RNX6ZrwRWqxxQ/p9Y8L1ret5QC9miWldayCbTpWiquKxmjVE09hN6YwLa4UO6bYCB
         Zw8f7nk9+v0wmPyUCQcEfXl3EvsBjZpEG+wj6VGy/6bNkA8mcgSXfIvkgsgCAxf7Xa
         vjHDmy5Ilt/EcgoLO4v09/UbCaupOGt9HK4G0/vY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b994ecf2b023f14832c1@syzkaller.appspotmail.com,
        syzbot+0e0db88e1eb44a91ae8d@syzkaller.appspotmail.com,
        syzbot+2d0585e5efcd43d113c2@syzkaller.appspotmail.com,
        syzbot+1ecc2f9d3387f1d79d42@syzkaller.appspotmail.com,
        syzbot+18d51774588492bf3f69@syzkaller.appspotmail.com,
        syzbot+a5e4946b04d6ca8fa5f3@syzkaller.appspotmail.com,
        Hillf Danton <hdanton@sina.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 417/633] afs: Fix cell removal
Date:   Tue, 27 Oct 2020 14:52:40 +0100
Message-Id: <20201027135542.282271338@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 1d0e850a49a5b56f8f3cb51e74a11e2fedb96be6 ]

Fix cell removal by inserting a more final state than AFS_CELL_FAILED that
indicates that the cell has been unpublished in case the manager is already
requeued and will go through again.  The new AFS_CELL_REMOVED state will
just immediately leave the manager function.

Going through a second time in the AFS_CELL_FAILED state will cause it to
try to remove the cell again, potentially leading to the proc list being
removed.

Fixes: 989782dcdc91 ("afs: Overhaul cell database management")
Reported-by: syzbot+b994ecf2b023f14832c1@syzkaller.appspotmail.com
Reported-by: syzbot+0e0db88e1eb44a91ae8d@syzkaller.appspotmail.com
Reported-by: syzbot+2d0585e5efcd43d113c2@syzkaller.appspotmail.com
Reported-by: syzbot+1ecc2f9d3387f1d79d42@syzkaller.appspotmail.com
Reported-by: syzbot+18d51774588492bf3f69@syzkaller.appspotmail.com
Reported-by: syzbot+a5e4946b04d6ca8fa5f3@syzkaller.appspotmail.com
Suggested-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hillf Danton <hdanton@sina.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c     | 16 ++++++++++------
 fs/afs/internal.h |  1 +
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 1944be78e9b0d..bc7ed46aaca9f 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -291,11 +291,11 @@ struct afs_cell *afs_lookup_cell(struct afs_net *net,
 	wait_var_event(&cell->state,
 		       ({
 			       state = smp_load_acquire(&cell->state); /* vs error */
-			       state == AFS_CELL_ACTIVE || state == AFS_CELL_FAILED;
+			       state == AFS_CELL_ACTIVE || state == AFS_CELL_REMOVED;
 		       }));
 
 	/* Check the state obtained from the wait check. */
-	if (state == AFS_CELL_FAILED) {
+	if (state == AFS_CELL_REMOVED) {
 		ret = cell->error;
 		goto error;
 	}
@@ -700,7 +700,6 @@ static void afs_deactivate_cell(struct afs_net *net, struct afs_cell *cell)
 static void afs_manage_cell(struct afs_cell *cell)
 {
 	struct afs_net *net = cell->net;
-	bool deleted;
 	int ret, active;
 
 	_enter("%s", cell->name);
@@ -712,13 +711,15 @@ static void afs_manage_cell(struct afs_cell *cell)
 	case AFS_CELL_FAILED:
 		down_write(&net->cells_lock);
 		active = 1;
-		deleted = atomic_try_cmpxchg_relaxed(&cell->active, &active, 0);
-		if (deleted) {
+		if (atomic_try_cmpxchg_relaxed(&cell->active, &active, 0)) {
 			rb_erase(&cell->net_node, &net->cells);
+			smp_store_release(&cell->state, AFS_CELL_REMOVED);
 		}
 		up_write(&net->cells_lock);
-		if (deleted)
+		if (cell->state == AFS_CELL_REMOVED) {
+			wake_up_var(&cell->state);
 			goto final_destruction;
+		}
 		if (cell->state == AFS_CELL_FAILED)
 			goto done;
 		smp_store_release(&cell->state, AFS_CELL_UNSET);
@@ -760,6 +761,9 @@ static void afs_manage_cell(struct afs_cell *cell)
 		wake_up_var(&cell->state);
 		goto again;
 
+	case AFS_CELL_REMOVED:
+		goto done;
+
 	default:
 		break;
 	}
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 522597b401fec..7689f4535ef9c 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -326,6 +326,7 @@ enum afs_cell_state {
 	AFS_CELL_DEACTIVATING,
 	AFS_CELL_INACTIVE,
 	AFS_CELL_FAILED,
+	AFS_CELL_REMOVED,
 };
 
 /*
-- 
2.25.1



