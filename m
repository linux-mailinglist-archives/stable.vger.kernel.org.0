Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE432A583B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbgKCUtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731515AbgKCUtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:19 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF55720719;
        Tue,  3 Nov 2020 20:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436558;
        bh=HePFGk/7Ox50I1nfd/BRrMQxdtgsuScb9PBwP6v/v98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k2RydcmgQiKC+m8dt6f/Ow8a4gXZwhz/dvl3XAozqq0KJNXgPeTDlxs+NpKIVmedc
         qDb7oe5vajKleQbmS5CYdLakvhq6rWKy1ajT5FlTxofVUFuU+ePTVGp1nviTlwv/hi
         v0kUcFSdSqgYm5ozQfI+Ah3GJuyyyA7PDpiF4MUI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.9 300/391] NFSv4: Wait for stateid updates after CLOSE/OPEN_DOWNGRADE
Date:   Tue,  3 Nov 2020 21:35:51 +0100
Message-Id: <20201103203407.327284940@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

commit b4868b44c5628995fdd8ef2e24dda73cef963a75 upstream.

Since commit 0e0cb35b417f ("NFSv4: Handle NFS4ERR_OLD_STATEID in
CLOSE/OPEN_DOWNGRADE") the following livelock may occur if a CLOSE races
with the update of the nfs_state:

Process 1           Process 2           Server
=========           =========           ========
 OPEN file
                    OPEN file
                                        Reply OPEN (1)
                                        Reply OPEN (2)
 Update state (1)
 CLOSE file (1)
                                        Reply OLD_STATEID (1)
 CLOSE file (2)
                                        Reply CLOSE (-1)
                    Update state (2)
                    wait for state change
 OPEN file
                    wake
 CLOSE file
 OPEN file
                    wake
 CLOSE file
 ...
                    ...

We can avoid this situation by not issuing an immediate retry with a bumped
seqid when CLOSE/OPEN_DOWNGRADE receives NFS4ERR_OLD_STATEID.  Instead,
take the same approach used by OPEN and wait at least 5 seconds for
outstanding stateid updates to complete if we can detect that we're out of
sequence.

Note that after this change it is still possible (though unlikely) that
CLOSE waits a full 5 seconds, bumps the seqid, and retries -- and that
attempt races with another OPEN at the same time.  In order to avoid this
race (which would result in the livelock), update
nfs_need_update_open_stateid() to handle the case where:
 - the state is NFS_OPEN_STATE, and
 - the stateid doesn't match the current open stateid

Finally, nfs_need_update_open_stateid() is modified to be idempotent and
renamed to better suit the purpose of signaling that the stateid passed
is the next stateid in sequence.

Fixes: 0e0cb35b417f ("NFSv4: Handle NFS4ERR_OLD_STATEID in CLOSE/OPEN_DOWNGRADE")
Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4_fs.h   |    8 +++++
 fs/nfs/nfs4proc.c  |   81 ++++++++++++++++++++++++++++++-----------------------
 fs/nfs/nfs4trace.h |    1 
 3 files changed, 56 insertions(+), 34 deletions(-)

--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -599,6 +599,14 @@ static inline bool nfs4_stateid_is_newer
 	return (s32)(be32_to_cpu(s1->seqid) - be32_to_cpu(s2->seqid)) > 0;
 }
 
+static inline bool nfs4_stateid_is_next(const nfs4_stateid *s1, const nfs4_stateid *s2)
+{
+	u32 seq1 = be32_to_cpu(s1->seqid);
+	u32 seq2 = be32_to_cpu(s2->seqid);
+
+	return seq2 == seq1 + 1U || (seq2 == 1U && seq1 == 0xffffffffU);
+}
+
 static inline bool nfs4_stateid_match_or_older(const nfs4_stateid *dst, const nfs4_stateid *src)
 {
 	return nfs4_stateid_match_other(dst, src) &&
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1547,19 +1547,6 @@ static void nfs_state_log_update_open_st
 		wake_up_all(&state->waitq);
 }
 
-static void nfs_state_log_out_of_order_open_stateid(struct nfs4_state *state,
-		const nfs4_stateid *stateid)
-{
-	u32 state_seqid = be32_to_cpu(state->open_stateid.seqid);
-	u32 stateid_seqid = be32_to_cpu(stateid->seqid);
-
-	if (stateid_seqid == state_seqid + 1U ||
-	    (stateid_seqid == 1U && state_seqid == 0xffffffffU))
-		nfs_state_log_update_open_stateid(state);
-	else
-		set_bit(NFS_STATE_CHANGE_WAIT, &state->flags);
-}
-
 static void nfs_test_and_clear_all_open_stateid(struct nfs4_state *state)
 {
 	struct nfs_client *clp = state->owner->so_server->nfs_client;
@@ -1585,21 +1572,19 @@ static void nfs_test_and_clear_all_open_
  * i.e. The stateid seqids have to be initialised to 1, and
  * are then incremented on every state transition.
  */
-static bool nfs_need_update_open_stateid(struct nfs4_state *state,
+static bool nfs_stateid_is_sequential(struct nfs4_state *state,
 		const nfs4_stateid *stateid)
 {
-	if (test_bit(NFS_OPEN_STATE, &state->flags) == 0 ||
-	    !nfs4_stateid_match_other(stateid, &state->open_stateid)) {
+	if (test_bit(NFS_OPEN_STATE, &state->flags)) {
+		/* The common case - we're updating to a new sequence number */
+		if (nfs4_stateid_match_other(stateid, &state->open_stateid) &&
+			nfs4_stateid_is_next(&state->open_stateid, stateid)) {
+			return true;
+		}
+	} else {
+		/* This is the first OPEN in this generation */
 		if (stateid->seqid == cpu_to_be32(1))
-			nfs_state_log_update_open_stateid(state);
-		else
-			set_bit(NFS_STATE_CHANGE_WAIT, &state->flags);
-		return true;
-	}
-
-	if (nfs4_stateid_is_newer(stateid, &state->open_stateid)) {
-		nfs_state_log_out_of_order_open_stateid(state, stateid);
-		return true;
+			return true;
 	}
 	return false;
 }
@@ -1673,16 +1658,16 @@ static void nfs_set_open_stateid_locked(
 	int status = 0;
 	for (;;) {
 
-		if (!nfs_need_update_open_stateid(state, stateid))
-			return;
-		if (!test_bit(NFS_STATE_CHANGE_WAIT, &state->flags))
+		if (nfs_stateid_is_sequential(state, stateid))
 			break;
+
 		if (status)
 			break;
 		/* Rely on seqids for serialisation with NFSv4.0 */
 		if (!nfs4_has_session(NFS_SERVER(state->inode)->nfs_client))
 			break;
 
+		set_bit(NFS_STATE_CHANGE_WAIT, &state->flags);
 		prepare_to_wait(&state->waitq, &wait, TASK_KILLABLE);
 		/*
 		 * Ensure we process the state changes in the same order
@@ -1693,6 +1678,7 @@ static void nfs_set_open_stateid_locked(
 		spin_unlock(&state->owner->so_lock);
 		rcu_read_unlock();
 		trace_nfs4_open_stateid_update_wait(state->inode, stateid, 0);
+
 		if (!signal_pending(current)) {
 			if (schedule_timeout(5*HZ) == 0)
 				status = -EAGAIN;
@@ -3435,7 +3421,8 @@ static bool nfs4_refresh_open_old_statei
 	__be32 seqid_open;
 	u32 dst_seqid;
 	bool ret;
-	int seq;
+	int seq, status = -EAGAIN;
+	DEFINE_WAIT(wait);
 
 	for (;;) {
 		ret = false;
@@ -3447,15 +3434,41 @@ static bool nfs4_refresh_open_old_statei
 				continue;
 			break;
 		}
+
+		write_seqlock(&state->seqlock);
 		seqid_open = state->open_stateid.seqid;
-		if (read_seqretry(&state->seqlock, seq))
-			continue;
 
 		dst_seqid = be32_to_cpu(dst->seqid);
-		if ((s32)(dst_seqid - be32_to_cpu(seqid_open)) >= 0)
-			dst->seqid = cpu_to_be32(dst_seqid + 1);
-		else
+
+		/* Did another OPEN bump the state's seqid?  try again: */
+		if ((s32)(be32_to_cpu(seqid_open) - dst_seqid) > 0) {
 			dst->seqid = seqid_open;
+			write_sequnlock(&state->seqlock);
+			ret = true;
+			break;
+		}
+
+		/* server says we're behind but we haven't seen the update yet */
+		set_bit(NFS_STATE_CHANGE_WAIT, &state->flags);
+		prepare_to_wait(&state->waitq, &wait, TASK_KILLABLE);
+		write_sequnlock(&state->seqlock);
+		trace_nfs4_close_stateid_update_wait(state->inode, dst, 0);
+
+		if (signal_pending(current))
+			status = -EINTR;
+		else
+			if (schedule_timeout(5*HZ) != 0)
+				status = 0;
+
+		finish_wait(&state->waitq, &wait);
+
+		if (!status)
+			continue;
+		if (status == -EINTR)
+			break;
+
+		/* we slept the whole 5 seconds, we must have lost a seqid */
+		dst->seqid = cpu_to_be32(dst_seqid + 1);
 		ret = true;
 		break;
 	}
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -1511,6 +1511,7 @@ DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_set
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_delegreturn);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_open_stateid_update);
 DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_open_stateid_update_wait);
+DEFINE_NFS4_INODE_STATEID_EVENT(nfs4_close_stateid_update_wait);
 
 DECLARE_EVENT_CLASS(nfs4_getattr_event,
 		TP_PROTO(


