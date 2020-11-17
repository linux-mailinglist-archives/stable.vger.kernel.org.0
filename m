Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E516F2B64BD
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733074AbgKQNs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:48:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:44806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732161AbgKQNeS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:34:18 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A04B72463D;
        Tue, 17 Nov 2020 13:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620058;
        bh=QRDP498dOWM5C4nDfySOyyKApoMkKM9HIB+LzQmW6vI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rb9oaP/8DSMnPJgzBItXUqXDZxZIaDSWevE/KaOcRXGu0+FDjNvvLf2in89Ptksu4
         Jsn/9COhm4W7GJ49PTLzMIb3RIOmEgb4R7w1WMSrCo7wVyiDPOcgIO2m1PoPLFS9dL
         6P4BU6nVJCw1rPwYsdGfRBOeXBwTCRMfa+a+NJJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Donnelly <pdonnell@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 064/255] ceph: check session state after bumping session->s_seq
Date:   Tue, 17 Nov 2020 14:03:24 +0100
Message-Id: <20201117122142.066944769@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 62575e270f661aba64778cbc5f354511cf9abb21 ]

Some messages sent by the MDS entail a session sequence number
increment, and the MDS will drop certain types of requests on the floor
when the sequence numbers don't match.

In particular, a REQUEST_CLOSE message can cross with one of the
sequence morphing messages from the MDS which can cause the client to
stall, waiting for a response that will never come.

Originally, this meant an up to 5s delay before the recurring workqueue
job kicked in and resent the request, but a recent change made it so
that the client would never resend, causing a 60s stall unmounting and
sometimes a blockisting event.

Add a new helper for incrementing the session sequence and then testing
to see whether a REQUEST_CLOSE needs to be resent, and move the handling
of CEPH_MDS_SESSION_CLOSING into that function. Change all of the
bare sequence counter increments to use the new helper.

Reorganize check_session_state with a switch statement.  It should no
longer be called when the session is CLOSING, so throw a warning if it
ever is (but still handle that case sanely).

[ idryomov: whitespace, pr_err() call fixup ]

URL: https://tracker.ceph.com/issues/47563
Fixes: fa9967734227 ("ceph: fix potential mdsc use-after-free crash")
Reported-by: Patrick Donnelly <pdonnell@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c       |  2 +-
 fs/ceph/mds_client.c | 50 +++++++++++++++++++++++++++++++-------------
 fs/ceph/mds_client.h |  1 +
 fs/ceph/quota.c      |  2 +-
 fs/ceph/snap.c       |  2 +-
 5 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 034b3f4fdd3a7..64a64a29f5c79 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4064,7 +4064,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	     vino.snap, inode);
 
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 	dout(" mds%d seq %lld cap seq %u\n", session->s_mds, session->s_seq,
 	     (unsigned)seq);
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 76d8d9495d1d4..b2214679baf4e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4227,7 +4227,7 @@ static void handle_lease(struct ceph_mds_client *mdsc,
 	     dname.len, dname.name);
 
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 
 	if (!inode) {
 		dout("handle_lease no inode %llx\n", vino.ino);
@@ -4381,28 +4381,48 @@ static void maybe_recover_session(struct ceph_mds_client *mdsc)
 
 bool check_session_state(struct ceph_mds_session *s)
 {
-	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
-		dout("resending session close request for mds%d\n",
-				s->s_mds);
-		request_close_session(s);
-		return false;
-	}
-	if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
-		if (s->s_state == CEPH_MDS_SESSION_OPEN) {
+	switch (s->s_state) {
+	case CEPH_MDS_SESSION_OPEN:
+		if (s->s_ttl && time_after(jiffies, s->s_ttl)) {
 			s->s_state = CEPH_MDS_SESSION_HUNG;
 			pr_info("mds%d hung\n", s->s_mds);
 		}
-	}
-	if (s->s_state == CEPH_MDS_SESSION_NEW ||
-	    s->s_state == CEPH_MDS_SESSION_RESTARTING ||
-	    s->s_state == CEPH_MDS_SESSION_CLOSED ||
-	    s->s_state == CEPH_MDS_SESSION_REJECTED)
-		/* this mds is failed or recovering, just wait */
+		break;
+	case CEPH_MDS_SESSION_CLOSING:
+		/* Should never reach this when we're unmounting */
+		WARN_ON_ONCE(true);
+		fallthrough;
+	case CEPH_MDS_SESSION_NEW:
+	case CEPH_MDS_SESSION_RESTARTING:
+	case CEPH_MDS_SESSION_CLOSED:
+	case CEPH_MDS_SESSION_REJECTED:
 		return false;
+	}
 
 	return true;
 }
 
+/*
+ * If the sequence is incremented while we're waiting on a REQUEST_CLOSE reply,
+ * then we need to retransmit that request.
+ */
+void inc_session_sequence(struct ceph_mds_session *s)
+{
+	lockdep_assert_held(&s->s_mutex);
+
+	s->s_seq++;
+
+	if (s->s_state == CEPH_MDS_SESSION_CLOSING) {
+		int ret;
+
+		dout("resending session close request for mds%d\n", s->s_mds);
+		ret = request_close_session(s);
+		if (ret < 0)
+			pr_err("unable to close session to mds%d: %d\n",
+			       s->s_mds, ret);
+	}
+}
+
 /*
  * delayed work -- periodically trim expired leases, renew caps with mds
  */
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 658800605bfb4..11f20a4d36bc5 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -480,6 +480,7 @@ struct ceph_mds_client {
 extern const char *ceph_mds_op_name(int op);
 
 extern bool check_session_state(struct ceph_mds_session *s);
+void inc_session_sequence(struct ceph_mds_session *s);
 
 extern struct ceph_mds_session *
 __ceph_lookup_mds_session(struct ceph_mds_client *, int mds);
diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index cc2c4d40b0222..2b213f864c564 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -53,7 +53,7 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
 
 	/* increment msg sequence number */
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 	mutex_unlock(&session->s_mutex);
 
 	/* lookup inode */
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index 923be9399b21c..cc9a9bfc790a3 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -873,7 +873,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	     ceph_snap_op_name(op), split, trace_len);
 
 	mutex_lock(&session->s_mutex);
-	session->s_seq++;
+	inc_session_sequence(session);
 	mutex_unlock(&session->s_mutex);
 
 	down_write(&mdsc->snap_rwsem);
-- 
2.27.0



