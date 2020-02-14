Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF1C215F0C7
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388016AbgBNP4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:56:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388003AbgBNP4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:52 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 289792067D;
        Fri, 14 Feb 2020 15:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695810;
        bh=tTRTa4UnlM3q5dwh/8XMV0LGO/JgQNvuiKbkjs0hCbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GIP8r+W8uhItNRyikndhUKBTA0T92ctj3hjHNxIOD4/K0sMfXB6eEqMY+iyc5LP0J
         IycrGqw5473m2g19JbTy5KJX/pxnv1vDx4ANCdw6pJIk7oIMHgKjM4S+X55OmJ6bZj
         QhlITPZDLK/9I02G4GMISDTLhLgPfhkwU2S1mM/Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 369/542] NFSv4.x recover from pre-mature loss of openstateid
Date:   Fri, 14 Feb 2020 10:46:01 -0500
Message-Id: <20200214154854.6746-369-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit d826e5b827641ae1bebb33d23a774f4e9bb8e94f ]

Ever since the commit 0e0cb35b417f, it's possible to lose an open stateid
while retrying a CLOSE due to ERR_OLD_STATEID. Once that happens,
operations that require openstateid fail with EAGAIN which is propagated
to the application then tests like generic/446 and generic/168 fail with
"Resource temporarily unavailable".

Instead of returning this error, initiate state recovery when possible to
recover the open stateid and then try calling nfs4_select_rw_stateid()
again.

Fixes: 0e0cb35b417f ("NFSv4: Handle NFS4ERR_OLD_STATEID in CLOSE/OPEN_DOWNGRADE")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs42proc.c | 36 ++++++++++++++++++++++++++++--------
 fs/nfs/nfs4proc.c  |  2 ++
 fs/nfs/pnfs.c      |  2 --
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 1fe83e0f663e2..9637aad36bdca 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -61,8 +61,11 @@ static int _nfs42_proc_fallocate(struct rpc_message *msg, struct file *filep,
 
 	status = nfs4_set_rw_stateid(&args.falloc_stateid, lock->open_context,
 			lock, FMODE_WRITE);
-	if (status)
+	if (status) {
+		if (status == -EAGAIN)
+			status = -NFS4ERR_BAD_STATEID;
 		return status;
+	}
 
 	res.falloc_fattr = nfs_alloc_fattr();
 	if (!res.falloc_fattr)
@@ -287,8 +290,11 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 	} else {
 		status = nfs4_set_rw_stateid(&args->src_stateid,
 				src_lock->open_context, src_lock, FMODE_READ);
-		if (status)
+		if (status) {
+			if (status == -EAGAIN)
+				status = -NFS4ERR_BAD_STATEID;
 			return status;
+		}
 	}
 	status = nfs_filemap_write_and_wait_range(file_inode(src)->i_mapping,
 			pos_src, pos_src + (loff_t)count - 1);
@@ -297,8 +303,11 @@ static ssize_t _nfs42_proc_copy(struct file *src,
 
 	status = nfs4_set_rw_stateid(&args->dst_stateid, dst_lock->open_context,
 				     dst_lock, FMODE_WRITE);
-	if (status)
+	if (status) {
+		if (status == -EAGAIN)
+			status = -NFS4ERR_BAD_STATEID;
 		return status;
+	}
 
 	status = nfs_sync_inode(dst_inode);
 	if (status)
@@ -546,8 +555,11 @@ static int _nfs42_proc_copy_notify(struct file *src, struct file *dst,
 	status = nfs4_set_rw_stateid(&args->cna_src_stateid, ctx, l_ctx,
 				     FMODE_READ);
 	nfs_put_lock_context(l_ctx);
-	if (status)
+	if (status) {
+		if (status == -EAGAIN)
+			status = -NFS4ERR_BAD_STATEID;
 		return status;
+	}
 
 	status = nfs4_call_sync(src_server->client, src_server, &msg,
 				&args->cna_seq_args, &res->cnr_seq_res, 0);
@@ -618,8 +630,11 @@ static loff_t _nfs42_proc_llseek(struct file *filep,
 
 	status = nfs4_set_rw_stateid(&args.sa_stateid, lock->open_context,
 			lock, FMODE_READ);
-	if (status)
+	if (status) {
+		if (status == -EAGAIN)
+			status = -NFS4ERR_BAD_STATEID;
 		return status;
+	}
 
 	status = nfs_filemap_write_and_wait_range(inode->i_mapping,
 			offset, LLONG_MAX);
@@ -994,13 +1009,18 @@ static int _nfs42_proc_clone(struct rpc_message *msg, struct file *src_f,
 
 	status = nfs4_set_rw_stateid(&args.src_stateid, src_lock->open_context,
 			src_lock, FMODE_READ);
-	if (status)
+	if (status) {
+		if (status == -EAGAIN)
+			status = -NFS4ERR_BAD_STATEID;
 		return status;
-
+	}
 	status = nfs4_set_rw_stateid(&args.dst_stateid, dst_lock->open_context,
 			dst_lock, FMODE_WRITE);
-	if (status)
+	if (status) {
+		if (status == -EAGAIN)
+			status = -NFS4ERR_BAD_STATEID;
 		return status;
+	}
 
 	res.dst_fattr = nfs_alloc_fattr();
 	if (!res.dst_fattr)
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 76d37161409a5..f9bb4b43a5192 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3239,6 +3239,8 @@ static int _nfs4_do_setattr(struct inode *inode,
 		nfs_put_lock_context(l_ctx);
 		if (status == -EIO)
 			return -EBADF;
+		else if (status == -EAGAIN)
+			goto zero_stateid;
 	} else {
 zero_stateid:
 		nfs4_stateid_copy(&arg->stateid, &zero_stateid);
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index cec3070ab577e..3ac6b4dea72d3 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1998,8 +1998,6 @@ pnfs_update_layout(struct inode *ino,
 			trace_pnfs_update_layout(ino, pos, count,
 					iomode, lo, lseg,
 					PNFS_UPDATE_LAYOUT_INVALID_OPEN);
-			if (status != -EAGAIN)
-				goto out_unlock;
 			spin_unlock(&ino->i_lock);
 			nfs4_schedule_stateid_recovery(server, ctx->state);
 			pnfs_clear_first_layoutget(lo);
-- 
2.20.1

