Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF116E4732
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 14:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjDQMLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 08:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjDQMLQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 08:11:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D2D976E
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 05:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681733405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1Hlcb9UbDjiM1XqGb00jsJmMSq4uSvjjTohDIi0T//I=;
        b=HgpE3lxdjPYd0HFbxe3FAQNiCmlAglPzA0Qkr1D/aojGWvWiCGKGpyJ2BI8P4b/shoKYzI
        rnbbzrweFv7BselCY/HernaNP7HYR+FgujSpNosF3lPbU6CMiOY/Z8A75puZS0d2eQg9uB
        ZEgg8hdgpFxok9j9hNGiD9yYbxmMExU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-pNA4YsL4Mcanz_BbMaIzzA-1; Mon, 17 Apr 2023 08:10:04 -0400
X-MC-Unique: pNA4YsL4Mcanz_BbMaIzzA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E25F3380406B;
        Mon, 17 Apr 2023 12:10:03 +0000 (UTC)
Received: from li-a71a4dcc-35d1-11b2-a85c-951838863c8d.ibm.com.com (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EF1214152F6;
        Mon, 17 Apr 2023 12:09:56 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, vshankar@redhat.com, lhenriques@suse.de,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] ceph: fix potential use-after-free bug when trimming caps
Date:   Mon, 17 Apr 2023 20:08:50 +0800
Message-Id: <20230417120850.60880-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

V2:
- Fix this in ceph_iterate_session_caps instead.


 fs/ceph/debugfs.c    |  7 +++++-
 fs/ceph/mds_client.c | 56 ++++++++++++++++++++++++++++++--------------
 fs/ceph/mds_client.h |  2 +-
 3 files changed, 46 insertions(+), 19 deletions(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index bec3c4549c07..5c0f07df5b02 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -248,14 +248,19 @@ static int metrics_caps_show(struct seq_file *s, void *p)
 	return 0;
 }
 
-static int caps_show_cb(struct inode *inode, struct ceph_cap *cap, void *p)
+static int caps_show_cb(struct inode *inode, struct rb_node *ci_node, void *p)
 {
+	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct seq_file *s = p;
+	struct ceph_cap *cap;
 
+	spin_lock(&ci->i_ceph_lock);
+	cap = rb_entry(ci_node, struct ceph_cap, ci_node);
 	seq_printf(s, "0x%-17llx%-3d%-17s%-17s\n", ceph_ino(inode),
 		   cap->session->s_mds,
 		   ceph_cap_string(cap->issued),
 		   ceph_cap_string(cap->implemented));
+	spin_unlock(&ci->i_ceph_lock);
 	return 0;
 }
 
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 294af79c25c9..7fcfbddd534d 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1786,7 +1786,7 @@ static void cleanup_session_requests(struct ceph_mds_client *mdsc,
  * Caller must hold session s_mutex.
  */
 int ceph_iterate_session_caps(struct ceph_mds_session *session,
-			      int (*cb)(struct inode *, struct ceph_cap *,
+			      int (*cb)(struct inode *, struct rb_node *ci_node,
 					void *), void *arg)
 {
 	struct list_head *p;
@@ -1799,6 +1799,8 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	spin_lock(&session->s_cap_lock);
 	p = session->s_caps.next;
 	while (p != &session->s_caps) {
+		struct rb_node *ci_node;
+
 		cap = list_entry(p, struct ceph_cap, session_caps);
 		inode = igrab(&cap->ci->netfs.inode);
 		if (!inode) {
@@ -1806,6 +1808,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 			continue;
 		}
 		session->s_cap_iterator = cap;
+		ci_node = &cap->ci_node;
 		spin_unlock(&session->s_cap_lock);
 
 		if (last_inode) {
@@ -1817,7 +1820,7 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 			old_cap = NULL;
 		}
 
-		ret = cb(inode, cap, arg);
+		ret = cb(inode, ci_node, arg);
 		last_inode = inode;
 
 		spin_lock(&session->s_cap_lock);
@@ -1850,17 +1853,22 @@ int ceph_iterate_session_caps(struct ceph_mds_session *session,
 	return ret;
 }
 
-static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
+static int remove_session_caps_cb(struct inode *inode, struct rb_node *ci_node,
 				  void *arg)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	bool invalidate = false;
+	struct ceph_cap *cap;
 	int iputs;
 
-	dout("removing cap %p, ci is %p, inode is %p\n",
-	     cap, ci, &ci->netfs.inode);
 	spin_lock(&ci->i_ceph_lock);
-	iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
+	cap = rb_entry(ci_node, struct ceph_cap, ci_node);
+	if (cap) {
+		dout(" removing cap %p, ci is %p, inode is %p\n",
+		     cap, ci, &ci->netfs.inode);
+
+		iputs = ceph_purge_inode_cap(inode, cap, &invalidate);
+	}
 	spin_unlock(&ci->i_ceph_lock);
 
 	wake_up_all(&ci->i_cap_wq);
@@ -1934,11 +1942,11 @@ enum {
  *
  * caller must hold s_mutex.
  */
-static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
-			      void *arg)
+static int wake_up_session_cb(struct inode *inode, struct rb_node *ci_node, void *arg)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	unsigned long ev = (unsigned long)arg;
+	struct ceph_cap *cap;
 
 	if (ev == RECONNECT) {
 		spin_lock(&ci->i_ceph_lock);
@@ -1949,7 +1957,9 @@ static int wake_up_session_cb(struct inode *inode, struct ceph_cap *cap,
 		if (cap->cap_gen < atomic_read(&cap->session->s_cap_gen)) {
 			/* mds did not re-issue stale cap */
 			spin_lock(&ci->i_ceph_lock);
-			cap->issued = cap->implemented = CEPH_CAP_PIN;
+			cap = rb_entry(ci_node, struct ceph_cap, ci_node);
+			if (cap)
+				cap->issued = cap->implemented = CEPH_CAP_PIN;
 			spin_unlock(&ci->i_ceph_lock);
 		}
 	} else if (ev == FORCE_RO) {
@@ -2113,16 +2123,22 @@ static bool drop_negative_children(struct dentry *dentry)
  * Yes, this is a bit sloppy.  Our only real goal here is to respond to
  * memory pressure from the MDS, though, so it needn't be perfect.
  */
-static int trim_caps_cb(struct inode *inode, struct ceph_cap *cap, void *arg)
+static int trim_caps_cb(struct inode *inode, struct rb_node *ci_node, void *arg)
 {
 	int *remaining = arg;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	int used, wanted, oissued, mine;
+	struct ceph_cap *cap;
 
 	if (*remaining <= 0)
 		return -1;
 
 	spin_lock(&ci->i_ceph_lock);
+	cap = rb_entry(ci_node, struct ceph_cap, ci_node);
+	if (!cap) {
+		spin_unlock(&ci->i_ceph_lock);
+		return 0;
+	}
 	mine = cap->issued | cap->implemented;
 	used = __ceph_caps_used(ci);
 	wanted = __ceph_caps_file_wanted(ci);
@@ -4265,26 +4281,23 @@ static struct dentry* d_find_primary(struct inode *inode)
 /*
  * Encode information about a cap for a reconnect with the MDS.
  */
-static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
+static int reconnect_caps_cb(struct inode *inode, struct rb_node *ci_node,
 			  void *arg)
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
@@ -4301,6 +4314,15 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
 	}
 
 	spin_lock(&ci->i_ceph_lock);
+	cap = rb_entry(ci_node, struct ceph_cap, ci_node);
+	if (!cap) {
+		spin_lock(&ci->i_ceph_lock);
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
index 0f70ca3cdb21..001b69d04307 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -569,7 +569,7 @@ extern void ceph_queue_cap_reclaim_work(struct ceph_mds_client *mdsc);
 extern void ceph_reclaim_caps_nr(struct ceph_mds_client *mdsc, int nr);
 extern int ceph_iterate_session_caps(struct ceph_mds_session *session,
 				     int (*cb)(struct inode *,
-					       struct ceph_cap *, void *),
+					       struct rb_node *ci_node, void *),
 				     void *arg);
 extern void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc);
 
-- 
2.39.2

