Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C57620918
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 06:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiKHFvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 00:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbiKHFvI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 00:51:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C761A2CDD0
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 21:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667886607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Uyr9irhUI4cZf1pAifTPvmxuxaFwuo+Sl3q/VQKxQD0=;
        b=L0FJWFRyK4jX3hns2jbcXyZXqS5lp6spqjFes80IUdzqY7FHm9GlCVrGLXG/DxXGqjMUrm
        msGlIn3HAwQ3Xi69E5rkUpWrPqCFNUr1ays+sRoL4ziWPOl8yXcX8o5bC5ZLbiw+4u5DAx
        sJK1cvX7qLZMKnnz9rD9ls9l5zllnDo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-263-1h3vQI1ZPISqPvhDMMObYQ-1; Tue, 08 Nov 2022 00:50:05 -0500
X-MC-Unique: 1h3vQI1ZPISqPvhDMMObYQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2245E1C05155;
        Tue,  8 Nov 2022 05:50:05 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39D9F401D49;
        Tue,  8 Nov 2022 05:50:00 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, jlayton@kernel.org, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v2] ceph: fix NULL pointer dereference for req->r_session
Date:   Tue,  8 Nov 2022 13:49:54 +0800
Message-Id: <20221108054954.307554-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The request's r_session maybe changed when it was forwarded or
resent.

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/caps.c | 88 +++++++++++++++++++-------------------------------
 1 file changed, 33 insertions(+), 55 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 894adfb4a092..172f18f7459d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2297,8 +2297,9 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
+	struct ceph_mds_session *s, **sessions = NULL;
 	unsigned int max_sessions;
-	int ret, err = 0;
+	int i, ret, err = 0;
 
 	spin_lock(&ci->i_unsafe_lock);
 	if (S_ISDIR(inode->i_mode) && !list_empty(&ci->i_unsafe_dirops)) {
@@ -2315,31 +2316,22 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
-	/*
-	 * The mdsc->max_sessions is unlikely to be changed
-	 * mostly, here we will retry it by reallocating the
-	 * sessions array memory to get rid of the mdsc->mutex
-	 * lock.
-	 */
-retry:
-	max_sessions = mdsc->max_sessions;
-
 	/*
 	 * Trigger to flush the journal logs in all the relevant MDSes
 	 * manually, or in the worst case we must wait at most 5 seconds
 	 * to wait the journal logs to be flushed by the MDSes periodically.
 	 */
+	mutex_lock(&mdsc->mutex);
+	max_sessions = mdsc->max_sessions;
+	sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
+	if (!sessions) {
+		mutex_unlock(&mdsc->mutex);
+		err = -ENOMEM;
+		goto out;
+	}
+
 	if ((req1 || req2) && likely(max_sessions)) {
-		struct ceph_mds_session **sessions = NULL;
-		struct ceph_mds_session *s;
 		struct ceph_mds_request *req;
-		int i;
-
-		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
-		if (!sessions) {
-			err = -ENOMEM;
-			goto out;
-		}
 
 		spin_lock(&ci->i_unsafe_lock);
 		if (req1) {
@@ -2348,16 +2340,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 				s = req->r_session;
 				if (!s)
 					continue;
-				if (unlikely(s->s_mds >= max_sessions)) {
-					spin_unlock(&ci->i_unsafe_lock);
-					for (i = 0; i < max_sessions; i++) {
-						s = sessions[i];
-						if (s)
-							ceph_put_mds_session(s);
-					}
-					kfree(sessions);
-					goto retry;
-				}
+				if (unlikely(s->s_mds >= max_sessions))
+					continue;
 				if (!sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
@@ -2370,16 +2354,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 				s = req->r_session;
 				if (!s)
 					continue;
-				if (unlikely(s->s_mds >= max_sessions)) {
-					spin_unlock(&ci->i_unsafe_lock);
-					for (i = 0; i < max_sessions; i++) {
-						s = sessions[i];
-						if (s)
-							ceph_put_mds_session(s);
-					}
-					kfree(sessions);
-					goto retry;
-				}
+				if (unlikely(s->s_mds >= max_sessions))
+					continue;
 				if (!sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
@@ -2387,25 +2363,26 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 			}
 		}
 		spin_unlock(&ci->i_unsafe_lock);
+	}
+	mutex_unlock(&mdsc->mutex);
 
-		/* the auth MDS */
-		spin_lock(&ci->i_ceph_lock);
-		if (ci->i_auth_cap) {
-		      s = ci->i_auth_cap->session;
-		      if (!sessions[s->s_mds])
-			      sessions[s->s_mds] = ceph_get_mds_session(s);
-		}
-		spin_unlock(&ci->i_ceph_lock);
+	/* the auth MDS */
+	spin_lock(&ci->i_ceph_lock);
+	if (ci->i_auth_cap) {
+		s = ci->i_auth_cap->session;
+		if (!sessions[s->s_mds] &&
+		    likely(s->s_mds < max_sessions))
+			sessions[s->s_mds] = ceph_get_mds_session(s);
+	}
+	spin_unlock(&ci->i_ceph_lock);
 
-		/* send flush mdlog request to MDSes */
-		for (i = 0; i < max_sessions; i++) {
-			s = sessions[i];
-			if (s) {
-				send_flush_mdlog(s);
-				ceph_put_mds_session(s);
-			}
+	/* send flush mdlog request to MDSes */
+	for (i = 0; i < max_sessions; i++) {
+		s = sessions[i];
+		if (s) {
+			send_flush_mdlog(s);
+			ceph_put_mds_session(s);
 		}
-		kfree(sessions);
 	}
 
 	dout("%s %p wait on tid %llu %llu\n", __func__,
@@ -2428,6 +2405,7 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 		ceph_mdsc_put_request(req1);
 	if (req2)
 		ceph_mdsc_put_request(req2);
+	kfree(sessions);
 	return err;
 }
 
-- 
2.31.1

