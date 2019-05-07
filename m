Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C13915919
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfEGFdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:33:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727274AbfEGFdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:33:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E570214AE;
        Tue,  7 May 2019 05:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207217;
        bh=H3FJUbZ8cdQuU5fVYR4pxnXg5jHeMXkwhuk8K7uyOic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQLBGeUguDKGPoftDKpLGakbUU38h/ljoJ5P0Y9iBjQqoYddI/5OLrwHG+c9GWYWc
         9UmQFXwVkE9NpJ1kOlmD1morZ9j2lhX4AbFB3jb50xZkB05hW8SZjVS4gjLPGhwe5s
         bSWSx4JZUcCQBUd0O4mv3l+GzuI4HrPhr1YcMo2o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.0 32/99] afs: Fix in-progess ops to ignore server-level callback invalidation
Date:   Tue,  7 May 2019 01:31:26 -0400
Message-Id: <20190507053235.29900-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit eeba1e9cf31d064284dd1fa7bd6cfe01395bd03d ]

The in-kernel afs filesystem client counts the number of server-level
callback invalidation events (CB.InitCallBackState* RPC operations) that it
receives from the server.  This is stored in cb_s_break in various
structures, including afs_server and afs_vnode.

If an inode is examined by afs_validate(), say, the afs_server copy is
compared, along with other break counters, to those in afs_vnode, and if
one or more of the counters do not match, it is considered that the
server's callback promise is broken.  At points where this happens,
AFS_VNODE_CB_PROMISED is cleared to indicate that the status must be
refetched from the server.

afs_validate() issues an FS.FetchStatus operation to get updated metadata -
and based on the updated data_version may invalidate the pagecache too.

However, the break counters are also used to determine whether to note a
new callback in the vnode (which would set the AFS_VNODE_CB_PROMISED flag)
and whether to cache the permit data included in the YFSFetchStatus record
by the server.

The problem comes when the server sends us a CB.InitCallBackState op.  The
first such instance doesn't cause cb_s_break to be incremented, but rather
causes AFS_SERVER_FL_NEW to be cleared - but thereafter, say some hours
after last use and all the volumes have been automatically unmounted and
the server has forgotten about the client[*], this *will* likely cause an
increment.

 [*] There are other circumstances too, such as the server restarting or
     needing to make space in its callback table.

Note that the server won't send us a CB.InitCallBackState op until we talk
to it again.

So what happens is:

 (1) A mount for a new volume is attempted, a inode is created for the root
     vnode and vnode->cb_s_break and AFS_VNODE_CB_PROMISED aren't set
     immediately, as we don't have a nominated server to talk to yet - and
     we may iterate through a few to find one.

 (2) Before the operation happens, afs_fetch_status(), say, notes in the
     cursor (fc.cb_break) the break counter sum from the vnode, volume and
     server counters, but the server->cb_s_break is currently 0.

 (3) We send FS.FetchStatus to the server.  The server sends us back
     CB.InitCallBackState.  We increment server->cb_s_break.

 (4) Our FS.FetchStatus completes.  The reply includes a callback record.

 (5) xdr_decode_AFSCallBack()/xdr_decode_YFSCallBack() check to see whether
     the callback promise was broken by checking the break counter sum from
     step (2) against the current sum.

     This fails because of step (3), so we don't set the callback record
     and, importantly, don't set AFS_VNODE_CB_PROMISED on the vnode.

This does not preclude the syscall from progressing, and we don't loop here
rechecking the status, but rather assume it's good enough for one round
only and will need to be rechecked next time.

 (6) afs_validate() it triggered on the vnode, probably called from
     d_revalidate() checking the parent directory.

 (7) afs_validate() notes that AFS_VNODE_CB_PROMISED isn't set, so doesn't
     update vnode->cb_s_break and assumes the vnode to be invalid.

 (8) afs_validate() needs to calls afs_fetch_status().  Go back to step (2)
     and repeat, every time the vnode is validated.

This primarily affects volume root dir vnodes.  Everything subsequent to
those inherit an already incremented cb_s_break upon mounting.

The issue is that we assume that the callback record and the cached permit
information in a reply from the server can't be trusted after getting a
server break - but this is wrong since the server makes sure things are
done in the right order, holding up our ops if necessary[*].

 [*] There is an extremely unlikely scenario where a reply from before the
     CB.InitCallBackState could get its delivery deferred till after - at
     which point we think we have a promise when we don't.  This, however,
     requires unlucky mass packet loss to one call.

AFS_SERVER_FL_NEW tries to paper over the cracks for the initial mount from
a server we've never contacted before, but this should be unnecessary.
It's also further insulated from the problem on an initial mount by
querying the server first with FS.GetCapabilities, which triggers the
CB.InitCallBackState.

Fix this by

 (1) Remove AFS_SERVER_FL_NEW.

 (2) In afs_calc_vnode_cb_break(), don't include cb_s_break in the
     calculation.

 (3) In afs_cb_is_broken(), don't include cb_s_break in the check.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/callback.c | 3 +--
 fs/afs/internal.h | 4 +---
 fs/afs/server.c   | 1 -
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 1c7955f5cdaf..128f2dbe256a 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -203,8 +203,7 @@ void afs_put_cb_interest(struct afs_net *net, struct afs_cb_interest *cbi)
  */
 void afs_init_callback_state(struct afs_server *server)
 {
-	if (!test_and_clear_bit(AFS_SERVER_FL_NEW, &server->flags))
-		server->cb_s_break++;
+	server->cb_s_break++;
 }
 
 /*
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 8871b9e8645f..465526f495b0 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -475,7 +475,6 @@ struct afs_server {
 	time64_t		put_time;	/* Time at which last put */
 	time64_t		update_at;	/* Time at which to next update the record */
 	unsigned long		flags;
-#define AFS_SERVER_FL_NEW	0		/* New server, don't inc cb_s_break */
 #define AFS_SERVER_FL_NOT_READY	1		/* The record is not ready for use */
 #define AFS_SERVER_FL_NOT_FOUND	2		/* VL server says no such server */
 #define AFS_SERVER_FL_VL_FAIL	3		/* Failed to access VL server */
@@ -828,7 +827,7 @@ static inline struct afs_cb_interest *afs_get_cb_interest(struct afs_cb_interest
 
 static inline unsigned int afs_calc_vnode_cb_break(struct afs_vnode *vnode)
 {
-	return vnode->cb_break + vnode->cb_s_break + vnode->cb_v_break;
+	return vnode->cb_break + vnode->cb_v_break;
 }
 
 static inline bool afs_cb_is_broken(unsigned int cb_break,
@@ -836,7 +835,6 @@ static inline bool afs_cb_is_broken(unsigned int cb_break,
 				    const struct afs_cb_interest *cbi)
 {
 	return !cbi || cb_break != (vnode->cb_break +
-				    cbi->server->cb_s_break +
 				    vnode->volume->cb_v_break);
 }
 
diff --git a/fs/afs/server.c b/fs/afs/server.c
index 642afa2e9783..65b33b6da48b 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -226,7 +226,6 @@ static struct afs_server *afs_alloc_server(struct afs_net *net,
 	RCU_INIT_POINTER(server->addresses, alist);
 	server->addr_version = alist->version;
 	server->uuid = *uuid;
-	server->flags = (1UL << AFS_SERVER_FL_NEW);
 	server->update_at = ktime_get_real_seconds() + afs_server_update_delay;
 	rwlock_init(&server->fs_lock);
 	INIT_HLIST_HEAD(&server->cb_volumes);
-- 
2.20.1

