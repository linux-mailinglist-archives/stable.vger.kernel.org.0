Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533656E72F4
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 08:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbjDSGPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 02:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbjDSGPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 02:15:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF3F30F4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 23:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681884867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+RDn566f79AKkQbNjHzRZvEBZgkaxnRIw1AKo+QMcE0=;
        b=XMxLsaw68t8NraMlgNvIYI8dUst9hLLQ4rELLv2mCksZeFSzMUXNLX/MbasGGOHgHzLwOM
        fjzZi8BwIqgrFwXRBAquKjk7NmnfyYsEfIuldHMKZ7WLRiO/fDA3QVCIh+nlbBITnl5mfa
        B8+BLJ8vz24omtQF/t/Ek7An2FGMLiQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-h5qLOrhQMOW0xCi15akVTQ-1; Wed, 19 Apr 2023 02:14:26 -0400
X-MC-Unique: h5qLOrhQMOW0xCi15akVTQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BA29804186;
        Wed, 19 Apr 2023 06:14:24 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-234.pek2.redhat.com [10.72.12.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EBE9C16024;
        Wed, 19 Apr 2023 06:14:20 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v4 2/2] ceph: fix potential use-after-free bug when trimming caps
Date:   Wed, 19 Apr 2023 14:14:02 +0800
Message-Id: <20230419061402.183915-3-xiubli@redhat.com>
In-Reply-To: <20230419061402.183915-1-xiubli@redhat.com>
References: <20230419061402.183915-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When trimming the caps and just after the 'session->s_cap_lock' is
released in ceph_iterate_session_caps() the cap maybe removed by
another thread, and when using the stale cap memory in the callbacks
it will trigger use-after-free crash.

We need to check the existence of the cap just after the 'ci->i_ceph_lock'
being acquired. And do nothing if it's already removed.

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2186264
URL: https://tracker.ceph.com/issues/43272
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/debugfs.c    | 18 +++++++----
 fs/ceph/mds_client.c | 72 ++++++++++++++++++++++++++++----------------
 fs/ceph/mds_client.h |  3 +-
 3 files changed, 59 insertions(+), 34 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index bec3c4549c07..3904333fa6c3 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -248,14 +248,20 @@ static int metrics_caps_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
+static int caps_show_cb(struct inode *inode, int mds, void *p)
 {
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct seq_file *s = p;
-
-	seq_printf(s, "0x%-17llx%-3d%-17s%-17s\n", ceph_ino(inode),
-		   cap->session->s_mds,
-		   ceph_cap_string(cap->issued),
-		   ceph_cap_string(cap->implemented));
+	struct ceph_cap *cap;
+
+	spin_lock(&ci->i_ceph_lock);
+	cap = __get_cap_for_mds(ci, mds);
+	if (cap)
+		seq_printf(s, "0x%-17llx%-3d%-17s%-17s\n", ceph_ino(inode),
+			   cap->session->s_mds,
+			   ceph_cap_string(cap->issued),
+			   ceph_cap_string(cap->implemented));
+	spin_unlock(&ci->i_ceph_lock);
 	return 0;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 294af79c25c9..70bbd344e3d9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1786,8 +1786,8 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
  * Caller must hold session s_mutex.
  */
 int ceph_iterate_session_caps(struct ceph_mds_session *session,
-			      int (*cb)(struct inode *, struct ceph_cap *,
-					void *), void *arg)
+			      int (*cb)(struct inode *, int mds, void *),
+			      void *arg)
 {
 	struct list_head *p;
 	struct ceph_cap *cap;
@@ -1799,6 +1799,8 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	spin_lock(&session->s_cap_lock);
 	p = session->s_caps.next;
 	while (p != &session->s_caps) {
+		int mds;
+
 		cap = list_entry(p, struct ceph_cap, session_caps);
 		inode = igrab(&cap->ci->netfs.inode);
 		if (!inode) {
@@ -1806,6 +1808,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 			continue;
 		}
 		session->s_cap_iterator = cap;
+		mds = cap->mds;
 		spin_unlock(&session->s_cap_lock);
 
 		if (last_inode) {
@@ -1817,7 +1820,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 			old_cap = NULL;
 		}
 
-		ret = cb(inode, cap, arg);
+		ret = cb(inode, mds, arg);
 		last_inode = inode;
 
 		spin_lock(&session->s_cap_lock);
@@ -1850,20 +1853,25 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	return ret;
 }
 
-static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
-				  void *arg)
+static int remove_session_caps_cb(struct inode *inode, int mds, void *arg)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	bool invalidate = false;
-	int iputs;
+	struct ceph_cap *cap;
+	int iputs = 0;
 
-	dout("removing cap %p, ci is %p, inode is %p\n",
-	     cap, ci, &ci->netfs.inode);
 	spin_lock(&ci->i_ceph_lock);
-	iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
+	cap = __get_cap_for_mds(ci, mds);
+	if (cap) {
+		dout(" removing cap %p, ci is %p, inode is %p\n",
+		     cap, ci, &ci->netfs.inode);
+
+		iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
+	}
 	spin_unlock(&ci->i_ceph_lock);
 
-	wake_up_all(&ci->i_cap_wq);
+	if (cap)
+		wake_up_all(&ci->i_cap_wq);
 	if (invalidate)
 		ceph_queue_invalidate(inode);
 	while (iputs--)
@@ -1934,8 +1942,7 @@ enum {
  *
  * caller must hold s_mutex.
  */
-static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
-			      void *arg)
+static int wake_up_session_cb(struct inode *inode, int mds, void *arg)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	unsigned long ev = (unsigned long)arg;
@@ -1946,12 +1953,14 @@ static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
 		ci->i_requested_max_size = 0;
 		spin_unlock(&ci->i_ceph_lock);
 	} else if (ev == RENEWCAPS) {
-		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
-			/* mds did not re-issue stale cap */
-			spin_lock(&ci->i_ceph_lock);
+		struct ceph_cap *cap;
+
+		spin_lock(&ci->i_ceph_lock);
+		cap = __get_cap_for_mds(ci, mds);
+		/* mds did not re-issue stale cap */
+		if (cap && cap->cap_gen < atomic_read(&cap->session->s_cap_gen))
 			cap->issued = cap->implemented = CEPH_CAP_PIN;
-			spin_unlock(&ci->i_ceph_lock);
-		}
+		spin_unlock(&ci->i_ceph_lock);
 	} else if (ev == FORCE_RO) {
 	}
 	wake_up_all(&ci->i_cap_wq);
@@ -2113,16 +2122,22 @@ static bool drop_negative_children(struct dentry *dentry)
  * Yes, this is a bit sloppy.  Our only real goal here is to respond to
  * memory pressure from the MDS, though, so it needn't be perfect.
  */
-static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
+static int trim_caps_cb(struct inode *inode, int mds, void *arg)
 {
 	int *remaining = arg;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int used, wanted, oissued, mine;
+	struct ceph_cap *cap;
 
 	if (*remaining <= 0)
 		return -1;
 
 	spin_lock(&ci->i_ceph_lock);
+	cap = __get_cap_for_mds(ci, mds);
+	if (!cap) {
+		spin_unlock(&ci->i_ceph_lock);
+		return 0;
+	}
 	mine = cap->issued | cap->implemented;
 	used = __ceph_caps_used(ci);
 	wanted = __ceph_caps_file_wanted(ci);
@@ -4265,26 +4280,22 @@ static struct dentry* d_find_primary(struct inode *inode)
 /*
  * Encode information about a cap for a reconnect with the MDS.
  */
-static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
-			  void *arg)
+static int reconnect_caps_cb(struct inode *inode, int mds, void *arg)
 {
 	union {
 		struct ceph_mds_cap_reconnect v2;
 		struct ceph_mds_cap_reconnect_v1 v1;
 	} rec;
-	struct ceph_inode_info *ci = cap->ci;
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_reconnect_state *recon_state = arg;
 	struct ceph_pagelist *pagelist = recon_state->pagelist;
 	struct dentry *dentry;
+	struct ceph_cap *cap;
 	char *path;
-	int pathlen = 0, err;
+	int pathlen = 0, err = 0;
 	u64 pathbase;
 	u64 snap_follows;
 
-	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
-	     inode, ceph_vinop(inode), cap, cap->cap_id,
-	     ceph_cap_string(cap->issued));
-
 	dentry = d_find_primary(inode);
 	if (dentry) {
 		/* set pathbase to parent dir when msg_version >= 2 */
@@ -4301,6 +4312,15 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	}
 
 	spin_lock(&ci->i_ceph_lock);
+	cap = __get_cap_for_mds(ci, mds);
+	if (!cap) {
+		spin_unlock(&ci->i_ceph_lock);
+		goto out_err;
+	}
+	dout(" adding %p ino %llx.%llx cap %p %lld %s\n",
+	     inode, ceph_vinop(inode), cap, cap->cap_id,
+	     ceph_cap_string(cap->issued));
+
 	cap->seq = 0;        /* reset cap seq */
 	cap->issue_seq = 0;  /* and issue_seq */
 	cap->mseq = 0;       /* and migrate_seq */
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index 0f70ca3cdb21..c2e77e0306b4 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -568,8 +568,7 @@ extern void ceph_flush_cap_releases(struct ceph_mds_client *mdsc,
 extern void ceph_queue_cap_reclaim_work(struct ceph_mds_client *mdsc);
 extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
 extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
-				     int (*cb)(struct inode *,
-					       struct ceph_cap *, void *),
+				     int (*cb)(struct inode *, int mds, void *),
 				     void *arg);
 extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
-- 
2.39.2

