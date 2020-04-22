Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B071C1B3F6B
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbgDVKh3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729610AbgDVKW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E67C2076B;
        Wed, 22 Apr 2020 10:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550931;
        bh=PVXL39a8G9cSFLZbfkP7Np2QJO/Y1QW8+3ErBrGVbnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGFLZ35YckpxJ94qH8LB7exPrJzqzl+K4FHKmfJhBIQ/i3Qrdh4DdFCu4bifRGGK6
         jQ5vIMflpXGD9+40o3Zc5nLNTTE7upUp2MimX+HzU3XYUdPt1sBEOvJFQhrWGhH9s6
         CLWRl0xMtzEKtQUrWeb7AykTLEHlLDVqqqqBrTso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.6 033/166] afs: Fix rename operation status delivery
Date:   Wed, 22 Apr 2020 11:56:00 +0200
Message-Id: <20200422095052.366136259@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit b98f0ec91c42d87a70da42726b852ac8d78a3257 upstream.

The afs_deliver_fs_rename() and yfs_deliver_fs_rename() functions both only
decode the second file status returned unless the parent directories are
different - unfortunately, this means that the xdr pointer isn't advanced
and the volsync record will be read incorrectly in such an instance.

Fix this by always decoding the second status into the second
status/callback block which wasn't being used if the dirs were the same.

The afs_update_dentry_version() calls that update the directory data
version numbers on the dentries can then unconditionally use the second
status record as this will always reflect the state of the destination dir
(the two records will be identical if the destination dir is the same as
the source dir)

Fixes: 260a980317da ("[AFS]: Add "directory write" support.")
Fixes: 30062bd13e36 ("afs: Implement YFS support in the fs client")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/dir.c       |   13 +++----------
 fs/afs/fsclient.c  |   12 ++++++------
 fs/afs/yfsclient.c |    8 +++-----
 3 files changed, 12 insertions(+), 21 deletions(-)

--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -1892,7 +1892,6 @@ static int afs_rename(struct inode *old_
 	if (afs_begin_vnode_operation(&fc, orig_dvnode, key, true)) {
 		afs_dataversion_t orig_data_version;
 		afs_dataversion_t new_data_version;
-		struct afs_status_cb *new_scb = &scb[1];
 
 		orig_data_version = orig_dvnode->status.data_version + 1;
 
@@ -1904,7 +1903,6 @@ static int afs_rename(struct inode *old_
 			new_data_version = new_dvnode->status.data_version + 1;
 		} else {
 			new_data_version = orig_data_version;
-			new_scb = &scb[0];
 		}
 
 		while (afs_select_fileserver(&fc)) {
@@ -1912,7 +1910,7 @@ static int afs_rename(struct inode *old_
 			fc.cb_break_2 = afs_calc_vnode_cb_break(new_dvnode);
 			afs_fs_rename(&fc, old_dentry->d_name.name,
 				      new_dvnode, new_dentry->d_name.name,
-				      &scb[0], new_scb);
+				      &scb[0], &scb[1]);
 		}
 
 		afs_vnode_commit_status(&fc, orig_dvnode, fc.cb_break,
@@ -1957,13 +1955,8 @@ static int afs_rename(struct inode *old_
 		 * Note that if we ever implement RENAME_EXCHANGE, we'll have
 		 * to update both dentries with opposing dir versions.
 		 */
-		if (new_dvnode != orig_dvnode) {
-			afs_update_dentry_version(&fc, old_dentry, &scb[1]);
-			afs_update_dentry_version(&fc, new_dentry, &scb[1]);
-		} else {
-			afs_update_dentry_version(&fc, old_dentry, &scb[0]);
-			afs_update_dentry_version(&fc, new_dentry, &scb[0]);
-		}
+		afs_update_dentry_version(&fc, old_dentry, &scb[1]);
+		afs_update_dentry_version(&fc, new_dentry, &scb[1]);
 		d_move(old_dentry, new_dentry);
 		goto error_tmp;
 	}
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -986,16 +986,16 @@ static int afs_deliver_fs_rename(struct
 	if (ret < 0)
 		return ret;
 
-	/* unmarshall the reply once we've received all of it */
+	/* If the two dirs are the same, we have two copies of the same status
+	 * report, so we just decode it twice.
+	 */
 	bp = call->buffer;
 	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_dir_scb);
 	if (ret < 0)
 		return ret;
-	if (call->out_dir_scb != call->out_scb) {
-		ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
-		if (ret < 0)
-			return ret;
-	}
+	ret = xdr_decode_AFSFetchStatus(&bp, call, call->out_scb);
+	if (ret < 0)
+		return ret;
 	xdr_decode_AFSVolSync(&bp, call->out_volsync);
 
 	_leave(" = 0 [done]");
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -1157,11 +1157,9 @@ static int yfs_deliver_fs_rename(struct
 	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_dir_scb);
 	if (ret < 0)
 		return ret;
-	if (call->out_dir_scb != call->out_scb) {
-		ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
-		if (ret < 0)
-			return ret;
-	}
+	ret = xdr_decode_YFSFetchStatus(&bp, call, call->out_scb);
+	if (ret < 0)
+		return ret;
 
 	xdr_decode_YFSVolSync(&bp, call->out_volsync);
 	_leave(" = 0 [done]");


