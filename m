Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33232623995
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 03:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiKJCJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 21:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbiKJCJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 21:09:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FD4FACC
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 18:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668046139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=z1J0GU6pRVh2b9DEKnoCQdh+6DVd2k/jOHeAmRz8JFY=;
        b=blXckwwoeF3p070Lz8/jnk9+HClfBebk7pfGzI/A4nPskARCq3HyAJCa86VidyygKZsF1+
        j7OjcRJwauFwLqTDFkyN3B2wA87bgD3x09BTpoX20s1nXUBTaPHyADi3iu5yyDhSQYkcWD
        zzixwouSOzKYgJ5bdPgkdhPCTZK7GNQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-1ZVk0t6OMzyzbgVXo-KmaQ-1; Wed, 09 Nov 2022 21:08:55 -0500
X-MC-Unique: 1ZVk0t6OMzyzbgVXo-KmaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3818D85A5A6;
        Thu, 10 Nov 2022 02:08:55 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 556F5C1912A;
        Thu, 10 Nov 2022 02:08:52 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, jlayton@kernel.org, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v4] ceph: fix NULL pointer dereference for req->r_session
Date:   Thu, 10 Nov 2022 10:08:28 +0800
Message-Id: <20221110020828.1899393-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

Changed in V4:
- move mdsc->mutex acquisition and max_sessions assignment into "if (req1 || req2)" branch

 fs/ceph/caps.c | 54 +++++++++++++++-----------------------------------
 1 file changed, 16 insertions(+), 38 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 894adfb4a092..1c84be839087 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2297,7 +2297,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
-	unsigned int max_sessions;
 	int ret, err = 0;
 
 	spin_lock(&ci->i_unsafe_lock);
@@ -2315,28 +2314,24 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
-	if ((req1 || req2) && likely(max_sessions)) {
-		struct ceph_mds_session **sessions = NULL;
-		struct ceph_mds_session *s;
+	if (req1 || req2) {
 		struct ceph_mds_request *req;
+		struct ceph_mds_session **sessions;
+		struct ceph_mds_session *s;
+		unsigned int max_sessions;
 		int i;
 
+		mutex_lock(&mdsc->mutex);
+		max_sessions = mdsc->max_sessions;
+
 		sessions = kcalloc(max_sessions, sizeof(s), GFP_KERNEL);
 		if (!sessions) {
+			mutex_unlock(&mdsc->mutex);
 			err = -ENOMEM;
 			goto out;
 		}
@@ -2346,18 +2341,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
-				if (!s)
+				if (!s || unlikely(s->s_mds >= max_sessions))
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
 				if (!sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
@@ -2368,18 +2353,8 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
-				if (!s)
+				if (!s || unlikely(s->s_mds >= max_sessions))
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
 				if (!sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
@@ -2391,11 +2366,14 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 		/* the auth MDS */
 		spin_lock(&ci->i_ceph_lock);
 		if (ci->i_auth_cap) {
-		      s = ci->i_auth_cap->session;
-		      if (!sessions[s->s_mds])
-			      sessions[s->s_mds] = ceph_get_mds_session(s);
+			s = ci->i_auth_cap->session;
+			if (likely(s->s_mds < max_sessions) &&
+			    !sessions[s->s_mds]) {
+				sessions[s->s_mds] = ceph_get_mds_session(s);
+			}
 		}
 		spin_unlock(&ci->i_ceph_lock);
+		mutex_unlock(&mdsc->mutex);
 
 		/* send flush mdlog request to MDSes */
 		for (i = 0; i < max_sessions; i++) {
-- 
2.31.1

