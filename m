Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A101815C393
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgBMPmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:42:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729580AbgBMP2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:10 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDFA620661;
        Thu, 13 Feb 2020 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607689;
        bh=xe3r34Is/TdpWklCLdm6X5UfJDrx1AOcYQjschZd5Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wnbN9hHUTOjaLWiMcFf9TlohxvykUdpmvy2h7UbQNeNriMkD+YVqJMyU+jpZJRf+1
         SRHQ+YkxG1Z+AlYQHIZBuATLWA4NAinH9U8z0chloakexAzYhREe0VHwELsQyBoGaj
         ShudrgyDpHZ252UXLSP/KxTWAqw8X8LSq4UTgBdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olga Kornievskaia <kolga@netapp.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.5 027/120] NFSv4.x recover from pre-mature loss of openstateid
Date:   Thu, 13 Feb 2020 07:20:23 -0800
Message-Id: <20200213151911.293201740@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <kolga@netapp.com>

commit d826e5b827641ae1bebb33d23a774f4e9bb8e94f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs42proc.c |   36 ++++++++++++++++++++++++++++--------
 fs/nfs/nfs4proc.c  |    2 ++
 fs/nfs/pnfs.c      |    2 --
 3 files changed, 30 insertions(+), 10 deletions(-)

--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -61,8 +61,11 @@ static int _nfs42_proc_fallocate(struct
 
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
@@ -287,8 +290,11 @@ static ssize_t _nfs42_proc_copy(struct f
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
@@ -297,8 +303,11 @@ static ssize_t _nfs42_proc_copy(struct f
 
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
@@ -546,8 +555,11 @@ static int _nfs42_proc_copy_notify(struc
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
@@ -618,8 +630,11 @@ static loff_t _nfs42_proc_llseek(struct
 
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
@@ -994,13 +1009,18 @@ static int _nfs42_proc_clone(struct rpc_
 
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
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3239,6 +3239,8 @@ static int _nfs4_do_setattr(struct inode
 		nfs_put_lock_context(l_ctx);
 		if (status == -EIO)
 			return -EBADF;
+		else if (status == -EAGAIN)
+			goto zero_stateid;
 	} else {
 zero_stateid:
 		nfs4_stateid_copy(&arg->stateid, &zero_stateid);
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1998,8 +1998,6 @@ lookup_again:
 			trace_pnfs_update_layout(ino, pos, count,
 					iomode, lo, lseg,
 					PNFS_UPDATE_LAYOUT_INVALID_OPEN);
-			if (status != -EAGAIN)
-				goto out_unlock;
 			spin_unlock(&ino->i_lock);
 			nfs4_schedule_stateid_recovery(server, ctx->state);
 			pnfs_clear_first_layoutget(lo);


