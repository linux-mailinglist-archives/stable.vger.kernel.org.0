Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0242C0935
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388451AbgKWNFF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:05:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:35182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387593AbgKWMuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:50:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B79E2158C;
        Mon, 23 Nov 2020 12:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135836;
        bh=utRuSWWmGSwHqgXDnQTu/5IuHB/3IhQO/k2mNKK4128=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p5QDOzIZf6tBfiYQf+j3VG9TcW/QK97DNYIZKECYaKNNrjaV+t1bTbF2BMDd25aCr
         pxYIlMCfcMQsCmCTi7shLQUae8rWSOGWfoK69+vqbqTWFCrCXtjMtWiFt+NZy2ZeNR
         pdC5YHEPyf0m13bpNHs/315IhUdS18MrRMDRBbMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 184/252] afs: Fix speculative status fetch going out of order wrt to modifications
Date:   Mon, 23 Nov 2020 13:22:14 +0100
Message-Id: <20201123121844.471859747@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit a9e5c87ca7443d09fb530fffa4d96ce1c76dbe4d ]

When doing a lookup in a directory, the afs filesystem uses a bulk
status fetch to speculatively retrieve the statuses of up to 48 other
vnodes found in the same directory and it will then either update extant
inodes or create new ones - effectively doing 'lookup ahead'.

To avoid the possibility of deadlocking itself, however, the filesystem
doesn't lock all of those inodes; rather just the directory inode is
locked (by the VFS).

When the operation completes, afs_inode_init_from_status() or
afs_apply_status() is called, depending on whether the inode already
exists, to commit the new status.

A case exists, however, where the speculative status fetch operation may
straddle a modification operation on one of those vnodes.  What can then
happen is that the speculative bulk status RPC retrieves the old status,
and whilst that is happening, the modification happens - which returns
an updated status, then the modification status is committed, then we
attempt to commit the speculative status.

This results in something like the following being seen in dmesg:

	kAFS: vnode modified {100058:861} 8->9 YFS.InlineBulkStatus

showing that for vnode 861 on volume 100058, we saw YFS.InlineBulkStatus
say that the vnode had data version 8 when we'd already recorded version
9 due to a local modification.  This was causing the cache to be
invalidated for that vnode when it shouldn't have been.  If it happens
on a data file, this might lead to local changes being lost.

Fix this by ignoring speculative status updates if the data version
doesn't match the expected value.

Note that it is possible to get a DV regression if a volume gets
restored from a backup - but we should get a callback break in such a
case that should trigger a recheck anyway.  It might be worth checking
the volume creation time in the volsync info and, if a change is
observed in that (as would happen on a restore), invalidate all caches
associated with the volume.

Fixes: 5cf9dd55a0ec ("afs: Prospectively look up extra files when doing a single lookup")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/dir.c      | 1 +
 fs/afs/inode.c    | 8 ++++++++
 fs/afs/internal.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 1bb5b9d7f0a2c..9068d5578a26f 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -823,6 +823,7 @@ static struct inode *afs_do_lookup(struct inode *dir, struct dentry *dentry,
 				vp->cb_break_before = afs_calc_vnode_cb_break(vnode);
 				vp->vnode = vnode;
 				vp->put_vnode = true;
+				vp->speculative = true; /* vnode not locked */
 			}
 		}
 	}
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 0fe8844b4bee2..b0d7b892090da 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -294,6 +294,13 @@ void afs_vnode_commit_status(struct afs_operation *op, struct afs_vnode_param *v
 			op->flags &= ~AFS_OPERATION_DIR_CONFLICT;
 		}
 	} else if (vp->scb.have_status) {
+		if (vp->dv_before + vp->dv_delta != vp->scb.status.data_version &&
+		    vp->speculative)
+			/* Ignore the result of a speculative bulk status fetch
+			 * if it splits around a modification op, thereby
+			 * appearing to regress the data version.
+			 */
+			goto out;
 		afs_apply_status(op, vp);
 		if (vp->scb.have_cb)
 			afs_apply_callback(op, vp);
@@ -305,6 +312,7 @@ void afs_vnode_commit_status(struct afs_operation *op, struct afs_vnode_param *v
 		}
 	}
 
+out:
 	write_sequnlock(&vnode->cb_lock);
 
 	if (vp->scb.have_status)
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 17336cbb8419f..932f501888e73 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -754,6 +754,7 @@ struct afs_vnode_param {
 	bool			update_ctime:1;	/* Need to update the ctime */
 	bool			set_size:1;	/* Must update i_size */
 	bool			op_unlinked:1;	/* True if file was unlinked by op */
+	bool			speculative:1;	/* T if speculative status fetch (no vnode lock) */
 };
 
 /*
-- 
2.27.0



