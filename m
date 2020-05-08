Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17231CAB33
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgEHMlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:36150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728814AbgEHMlX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F78420731;
        Fri,  8 May 2020 12:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941682;
        bh=coGiifpaPcuHQ25T9IkLeHiFDoMeP0UME5sKmpfpGYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLlmhwFtuIlQLR+QOUFBiyP+argegFm4hnEtWHuXsnZTLpZGe6nS/iw6xcE2s8kan
         214RpGngigUPN0xmcSkDWSa4S0s7kCu7lJthB5Lom9683i3zp0A1JmS1VB4t3jhhdG
         fyxvQyFIJfOGyPeBuFPaHE8yVm/fIfQsSOoguklA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 4.4 130/312] NFS: Fix an LOCK/OPEN race when unlinking an open file
Date:   Fri,  8 May 2020 14:32:01 +0200
Message-Id: <20200508123133.650729681@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 11476e9dec39d90fe1e9bf12abc6f3efe35a073d upstream.

At Connectathon 2016, we found that recent upstream Linux clients
would occasionally send a LOCK operation with a zero stateid. This
appeared to happen in close proximity to another thread returning
a delegation before unlinking the same file while it remained open.

Earlier, the client received a write delegation on this file and
returned the open stateid. Now, as it is getting ready to unlink the
file, it returns the write delegation. But there is still an open
file descriptor on that file, so the client must OPEN the file
again before it returns the delegation.

Since commit 24311f884189 ('NFSv4: Recovery of recalled read
delegations is broken'), nfs_open_delegation_recall() clears the
NFS_DELEGATED_STATE flag _before_ it sends the OPEN. This allows a
racing LOCK on the same inode to be put on the wire before the OPEN
operation has returned a valid open stateid.

To eliminate this race, serialize delegation return with the
acquisition of a file lock on the same file. Adopt the same approach
as is used in the unlock path.

This patch also eliminates a similar race seen when sending a LOCK
operation at the same time as returning a delegation on the same file.

Fixes: 24311f884189 ('NFSv4: Recovery of recalled read ... ')
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
[Anna: Add sentence about LOCK / delegation race]
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6054,6 +6054,7 @@ static int nfs41_lock_expired(struct nfs
 static int _nfs4_proc_setlk(struct nfs4_state *state, int cmd, struct file_lock *request)
 {
 	struct nfs_inode *nfsi = NFS_I(state->inode);
+	struct nfs4_state_owner *sp = state->owner;
 	unsigned char fl_flags = request->fl_flags;
 	int status = -ENOLCK;
 
@@ -6068,6 +6069,7 @@ static int _nfs4_proc_setlk(struct nfs4_
 	status = do_vfs_lock(state->inode, request);
 	if (status < 0)
 		goto out;
+	mutex_lock(&sp->so_delegreturn_mutex);
 	down_read(&nfsi->rwsem);
 	if (test_bit(NFS_DELEGATED_STATE, &state->flags)) {
 		/* Yes: cache locks! */
@@ -6075,9 +6077,11 @@ static int _nfs4_proc_setlk(struct nfs4_
 		request->fl_flags = fl_flags & ~FL_SLEEP;
 		status = do_vfs_lock(state->inode, request);
 		up_read(&nfsi->rwsem);
+		mutex_unlock(&sp->so_delegreturn_mutex);
 		goto out;
 	}
 	up_read(&nfsi->rwsem);
+	mutex_unlock(&sp->so_delegreturn_mutex);
 	status = _nfs4_do_setlk(state, cmd, request, NFS_LOCK_NEW);
 out:
 	request->fl_flags = fl_flags;


