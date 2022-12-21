Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92D0652CA9
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 07:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiLUGDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 01:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiLUGDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 01:03:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3A9218A1
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 22:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671602546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bso7QZ2PIuUmXR7PcS6dx61PlkJXCeFo/atkd5Gb6m0=;
        b=R2KdawP3n2igztQIjcSy0ULK6rvRZV8Y/I3OPgsYxhAtqpmlWLTISVWKHIXXZ3pflIkUkj
        w6g/UX4WiNvyVn1Oyr+THJaf/cxZhRgd6djxduQHCwzhN5fvrMRdt9hdPqnKIVpbnPyPvf
        QoRX2XqMKVSLfiQB/END9/V4sev2sSU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-445-ERErV-gNPQeqult8CuvQwg-1; Wed, 21 Dec 2022 01:02:22 -0500
X-MC-Unique: ERErV-gNPQeqult8CuvQwg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 07AAD80234E;
        Wed, 21 Dec 2022 06:02:22 +0000 (UTC)
Received: from fedora.redhat.com (ovpn-13-96.pek2.redhat.com [10.72.13.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D9C132026D4B;
        Wed, 21 Dec 2022 06:02:17 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v5 2/2] ceph: blocklist the kclient when receiving corrupted snap trace
Date:   Wed, 21 Dec 2022 14:02:06 +0800
Message-Id: <20221221060206.1859329-3-xiubli@redhat.com>
In-Reply-To: <20221221060206.1859329-1-xiubli@redhat.com>
References: <20221221060206.1859329-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When received corrupted snap trace we don't know what exactly has
happened in MDS side. And we shouldn't continue IOs and metadatas
access to MDS, which may corrupt or get incorrect contents.

This patch will just block all the further IO/MDS requests
immediately and then evict the kclient itself.

The reason why we still need to evict the kclient just after
blocking all the further IOs is that the MDS could revoke the caps
faster.

Cc: stable@vger.kernel.org
URL: https://tracker.ceph.com/issues/57686
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c       | 22 ++++++++++++++++++++--
 fs/ceph/caps.c       | 17 ++++++++++++++---
 fs/ceph/file.c       |  9 +++++++++
 fs/ceph/mds_client.c | 28 +++++++++++++++++++++++++---
 fs/ceph/snap.c       | 37 +++++++++++++++++++++++++++++++++++--
 fs/ceph/super.h      |  1 +
 6 files changed, 104 insertions(+), 10 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index da2fb2c97531..092f8d40abdc 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -305,13 +305,18 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_osd_request *req;
+	struct ceph_osd_request *req = NULL;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct iov_iter iter;
 	int err = 0;
 	u64 len = subreq->len;
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
+	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
+		err = -EIO;
+		goto out;
+	}
+
 	if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
 		return;
 
@@ -559,6 +564,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 
 	dout("writepage %p idx %lu\n", page, page->index);
 
+	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return -EIO;
+
 	/* verify this is a writeable snap context */
 	snapc = page_snap_context(page);
 	if (!snapc) {
@@ -797,6 +805,11 @@ static int ceph_writepages_start(struct address_space *mapping,
 	bool done = false;
 	bool caching = ceph_is_cache_enabled(inode);
 
+	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
+		mapping_set_error(mapping, -EIO);
+		return -EIO;
+	}
+
 	if (wbc->sync_mode == WB_SYNC_NONE &&
 	    fsc->write_congested)
 		return 0;
@@ -1639,7 +1652,7 @@ int ceph_uninline_data(struct file *file)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req = NULL;
-	struct ceph_cap_flush *prealloc_cf;
+	struct ceph_cap_flush *prealloc_cf = NULL;
 	struct folio *folio = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
 	struct page *pages[1];
@@ -1653,6 +1666,11 @@ int ceph_uninline_data(struct file *file)
 	dout("uninline_data %p %llx.%llx inline_version %llu\n",
 	     inode, ceph_vinop(inode), inline_version);
 
+	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
+		err = -EIO;
+		goto out;
+	}
+
 	if (inline_version == CEPH_INLINE_NONE)
 		return 0;
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 948136f81fc8..5230ab64fff0 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4134,6 +4134,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	void *p, *end;
 	struct cap_extra_info extra_info = {};
 	bool queue_trunc;
+	bool close_sessions = false;
 
 	dout("handle_caps from mds%d\n", session->s_mds);
 
@@ -4275,9 +4276,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		realm = NULL;
 		if (snaptrace_len) {
 			down_write(&mdsc->snap_rwsem);
-			ceph_update_snap_trace(mdsc, snaptrace,
-					       snaptrace + snaptrace_len,
-					       false, &realm);
+			if (ceph_update_snap_trace(mdsc, snaptrace,
+						   snaptrace + snaptrace_len,
+						   false, &realm)) {
+				up_write(&mdsc->snap_rwsem);
+				close_sessions = true;
+				goto done;
+			}
 			downgrade_write(&mdsc->snap_rwsem);
 		} else {
 			down_read(&mdsc->snap_rwsem);
@@ -4341,6 +4346,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	iput(inode);
 out:
 	ceph_put_string(extra_info.pool_ns);
+
+	/* Defer closing the sessions after s_mutex lock being released */
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
+
 	return;
 
 flush_cap_releases:
@@ -4350,6 +4360,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	 * cap).
 	 */
 	ceph_flush_cap_releases(mdsc, session);
+
 	goto done;
 
 bad:
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 85afcbbb5648..76a5633b3f35 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -976,6 +976,9 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
 	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
 	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
 
+	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return -EIO;
+
 	if (!len)
 		return 0;
 	/*
@@ -1342,6 +1345,9 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 	bool should_dirty = !write && user_backed_iter(iter);
 	bool sparse = ceph_test_mount_opt(fsc, SPARSEREAD);
 
+	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return -EIO;
+
 	if (write && ceph_snap(file_inode(file)) != CEPH_NOSNAP)
 		return -EROFS;
 
@@ -2078,6 +2084,9 @@ static int ceph_zero_partial_object(struct inode *inode,
 	loff_t zero = 0;
 	int op;
 
+	if (READ_ONCE(fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return -EIO;
+
 	if (!length) {
 		op = offset ? CEPH_OSD_OP_DELETE : CEPH_OSD_OP_TRUNCATE;
 		length = &zero;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index cbbaf334b6b8..b60812707fce 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -957,6 +957,9 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 {
 	struct ceph_mds_session *s;
 
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return ERR_PTR(-EIO);
+
 	if (mds >= mdsc->mdsmap->possible_max_rank)
 		return ERR_PTR(-EINVAL);
 
@@ -1632,6 +1635,9 @@ static int __open_session(struct ceph_mds_client *mdsc,
 	int mstate;
 	int mds = session->s_mds;
 
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return -EIO;
+
 	/* wait for mds to go active? */
 	mstate = ceph_mdsmap_get_state(mdsc->mdsmap, mds);
 	dout("open_session to mds%d (%s)\n", mds,
@@ -3205,6 +3211,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		err = -ETIMEDOUT;
 		goto finish;
 	}
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
+		dout("do_request metadata corrupted\n");
+		err = -EIO;
+		goto finish;
+	}
 	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_SHUTDOWN) {
 		dout("do_request forced umount\n");
 		err = -EIO;
@@ -3584,6 +3595,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	u64 tid;
 	int err, result;
 	int mds = session->s_mds;
+	bool close_sessions = false;
 
 	if (msg->front.iov_len < sizeof(*head)) {
 		pr_err("mdsc_handle_reply got corrupt (short) reply\n");
@@ -3698,10 +3710,15 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	realm = NULL;
 	if (rinfo->snapblob_len) {
 		down_write(&mdsc->snap_rwsem);
-		ceph_update_snap_trace(mdsc, rinfo->snapblob,
+		err = ceph_update_snap_trace(mdsc, rinfo->snapblob,
 				rinfo->snapblob + rinfo->snapblob_len,
 				le32_to_cpu(head->op) == CEPH_MDS_OP_RMSNAP,
 				&realm);
+		if (err) {
+			up_write(&mdsc->snap_rwsem);
+			close_sessions = true;
+			goto out_err;
+		}
 		downgrade_write(&mdsc->snap_rwsem);
 	} else {
 		down_read(&mdsc->snap_rwsem);
@@ -3759,6 +3776,10 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 				     req->r_end_latency, err);
 out:
 	ceph_mdsc_put_request(req);
+
+	/* Defer closing the sessions after s_mutex lock being released */
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
 	return;
 }
 
@@ -5358,7 +5379,7 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
 }
 
 /*
- * called after sb is ro.
+ * called after sb is ro or when metadata corrupted.
  */
 void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 {
@@ -5648,7 +5669,8 @@ static void mds_peer_reset(struct ceph_connection *con)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 
 	pr_warn("mds%d closed our session\n", s->s_mds);
-	send_mds_reconnect(mdsc, s);
+	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO)
+		send_mds_reconnect(mdsc, s);
 }
 
 static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index c1c452afa84d..a73943e51a77 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -767,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	struct ceph_client *client = mdsc->fsc->client;
 	int rebuild_snapcs;
 	int err = -ENOMEM;
+	int ret;
 	LIST_HEAD(dirty_realms);
 
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
@@ -885,6 +887,27 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	if (first_realm)
 		ceph_put_snap_realm(mdsc, first_realm);
 	pr_err("%s error %d\n", __func__, err);
+
+	/*
+	 * When receiving a corrupted snap trace we don't know what
+	 * exactly has happened in MDS side. And we shouldn't continue
+	 * writing to OSD, which may corrupt the snapshot contents.
+	 *
+	 * Just try to blocklist this kclient and then this kclient
+	 * must be remounted to continue after the corrupted metadata
+	 * fixed in the MDS side.
+	 */
+	mdsc->fsc->mount_state = CEPH_MOUNT_FENCE_IO;
+	ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
+	if (ret)
+		pr_err("%s blocklist of %s failed: %d", __func__,
+		       ceph_pr_addr(&client->msgr.inst.addr), ret);
+
+	WARN(1, "%s:%s%s do remount to continue%s",
+	     __func__, ret ? "" : ceph_pr_addr(&client->msgr.inst.addr),
+	     ret ? "" : " was blocklisted,",
+	     err == -EIO ? " after corrupted snaptrace fixed" : "");
+
 	return err;
 }
 
@@ -985,6 +1008,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	__le64 *split_inos = NULL, *split_realms = NULL;
 	int i;
 	int locked_rwsem = 0;
+	bool close_sessions = false;
 
 	/* decode */
 	if (msg->front.iov_len < sizeof(*h))
@@ -1093,8 +1117,12 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	 * update using the provided snap trace. if we are deleting a
 	 * snap, we can avoid queueing cap_snaps.
 	 */
-	ceph_update_snap_trace(mdsc, p, e,
-			       op == CEPH_SNAP_OP_DESTROY, NULL);
+	if (ceph_update_snap_trace(mdsc, p, e,
+				   op == CEPH_SNAP_OP_DESTROY,
+				   NULL)) {
+		close_sessions = true;
+		goto bad;
+	}
 
 	if (op == CEPH_SNAP_OP_SPLIT)
 		/* we took a reference when we created the realm, above */
@@ -1113,6 +1141,11 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 out:
 	if (locked_rwsem)
 		up_write(&mdsc->snap_rwsem);
+
+	/* Defer closing the sessions after s_mutex lock being released */
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
+
 	return;
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 0d5cb0983831..f59fd4b4755b 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -111,6 +111,7 @@ enum {
 	CEPH_MOUNT_UNMOUNTED,
 	CEPH_MOUNT_SHUTDOWN,
 	CEPH_MOUNT_RECOVER,
+	CEPH_MOUNT_FENCE_IO,
 };
 
 #define CEPH_ASYNC_CREATE_CONFLICT_BITS 8
-- 
2.31.1

