Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D2E4174C6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346397AbhIXNKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346845AbhIXNIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A514260E8B;
        Fri, 24 Sep 2021 12:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488224;
        bh=KpzRXMMsCQNA6qb0p+e5qdjuYKUNlRmHo44BN4oz6zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqXkgiMa//ZAwC1U9rMLJ1CaKXhxAgv94kQa8PVHgARocX5WbZg0iTD39efQQPL7w
         lFsWGKvsP2fWF4VGH8txIjmZqE4L1Aqglgf5R9GL8X6O09YZlAMxcvRtkgjjAwspGg
         +m7UadsTJBAmI3OQkvTXHJqwWC+HsVR0SmxN816Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        Luis Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/63] ceph: allow ceph_put_mds_session to take NULL or ERR_PTR
Date:   Fri, 24 Sep 2021 14:44:30 +0200
Message-Id: <20210924124335.307657262@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 7e65624d32b6e0429b1d3559e5585657f34f74a1 ]

...to simplify some error paths.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Luis Henriques <lhenriques@suse.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/dir.c        | 3 +--
 fs/ceph/inode.c      | 6 ++----
 fs/ceph/mds_client.c | 6 ++++--
 fs/ceph/metric.c     | 3 +--
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index a4d48370b2b3..f63c1a090139 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1797,8 +1797,7 @@ static void ceph_d_release(struct dentry *dentry)
 	dentry->d_fsdata = NULL;
 	spin_unlock(&dentry->d_lock);
 
-	if (di->lease_session)
-		ceph_put_mds_session(di->lease_session);
+	ceph_put_mds_session(di->lease_session);
 	kmem_cache_free(ceph_dentry_cachep, di);
 }
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 57cd78e942c0..63e781e4f7e4 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1121,8 +1121,7 @@ static inline void update_dentry_lease(struct inode *dir, struct dentry *dentry,
 	__update_dentry_lease(dir, dentry, lease, session, from_time,
 			      &old_lease_session);
 	spin_unlock(&dentry->d_lock);
-	if (old_lease_session)
-		ceph_put_mds_session(old_lease_session);
+	ceph_put_mds_session(old_lease_session);
 }
 
 /*
@@ -1167,8 +1166,7 @@ static void update_dentry_lease_careful(struct dentry *dentry,
 			      from_time, &old_lease_session);
 out_unlock:
 	spin_unlock(&dentry->d_lock);
-	if (old_lease_session)
-		ceph_put_mds_session(old_lease_session);
+	ceph_put_mds_session(old_lease_session);
 }
 
 /*
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 816cea497537..8cbbb611e0ca 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -661,6 +661,9 @@ struct ceph_mds_session *ceph_get_mds_session(struct ceph_mds_session *s)
 
 void ceph_put_mds_session(struct ceph_mds_session *s)
 {
+	if (IS_ERR_OR_NULL(s))
+		return;
+
 	dout("mdsc put_session %p %d -> %d\n", s,
 	     refcount_read(&s->s_ref), refcount_read(&s->s_ref)-1);
 	if (refcount_dec_and_test(&s->s_ref)) {
@@ -1435,8 +1438,7 @@ static void __open_export_target_sessions(struct ceph_mds_client *mdsc,
 
 	for (i = 0; i < mi->num_export_targets; i++) {
 		ts = __open_export_target_session(mdsc, mi->export_targets[i]);
-		if (!IS_ERR(ts))
-			ceph_put_mds_session(ts);
+		ceph_put_mds_session(ts);
 	}
 }
 
diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
index fee4c4778313..3b2ef8ee544e 100644
--- a/fs/ceph/metric.c
+++ b/fs/ceph/metric.c
@@ -233,8 +233,7 @@ void ceph_metric_destroy(struct ceph_client_metric *m)
 
 	cancel_delayed_work_sync(&m->delayed_work);
 
-	if (m->session)
-		ceph_put_mds_session(m->session);
+	ceph_put_mds_session(m->session);
 }
 
 static inline void __update_latency(ktime_t *totalp, ktime_t *lsump,
-- 
2.33.0



