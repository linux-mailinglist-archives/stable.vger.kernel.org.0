Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF756242C5
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 14:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKJNDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 08:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKJNDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 08:03:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55E3725D9
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 05:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668085330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=u5HjnKAZTuzuiB1xXFf+3hVgIaNkF6QfHUMfW827l9M=;
        b=YE8bISW/fbLpxDeSgTp+NBhkbEGc1khnbfpZmJ3hWTQpTFs4kDrEnW3ySayDrpYlgLWWEo
        HuliYZEgk+zsAGVxJxHoWOTvKa/p+UC6t8cyA/BUxy3NOc3bT2zJWvuYnPTVmbBVgJlD0f
        Vl6SrUvXQ0ismHHFlDESObXKtcaMuW8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-jq38i8FIOLyPnDUIDmwueA-1; Thu, 10 Nov 2022 08:02:07 -0500
X-MC-Unique: jq38i8FIOLyPnDUIDmwueA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BFC51C09CA2;
        Thu, 10 Nov 2022 13:02:05 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA3D54A9256;
        Thu, 10 Nov 2022 13:02:02 +0000 (UTC)
From:   xiubli@redhat.com
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Cc:     lhenriques@suse.de, jlayton@kernel.org, mchangir@redhat.com,
        Xiubo Li <xiubli@redhat.com>, stable@vger.kernel.org
Subject: [PATCH v5] ceph: fix NULL pointer dereference for req->r_session
Date:   Thu, 10 Nov 2022 21:01:59 +0800
Message-Id: <20221110130159.33319-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

The request's r_session maybe changed when it was forwarded or
resent. Both the forwarding and resending cases the requests will
be protected by the mdsc->mutex.

Cc: stable@vger.kernel.org
URL: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---

Changed in V5:
- simplify the code by removing the "unlikely(s->s_mds >= max_sessions)" check.

Changed in V4:
- move mdsc->mutex acquisition and max_sessions assignment into "if (req1 || req2)" branch



 fs/ceph/caps.c | 48 ++++++++++++------------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 894adfb4a092..065e9311b607 100644
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
@@ -2348,16 +2343,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
 				if (!sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
@@ -2370,16 +2355,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
 				if (!sessions[s->s_mds]) {
 					s = ceph_get_mds_session(s);
 					sessions[s->s_mds] = s;
@@ -2391,11 +2366,12 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 		/* the auth MDS */
 		spin_lock(&ci->i_ceph_lock);
 		if (ci->i_auth_cap) {
-		      s = ci->i_auth_cap->session;
-		      if (!sessions[s->s_mds])
-			      sessions[s->s_mds] = ceph_get_mds_session(s);
+			s = ci->i_auth_cap->session;
+			if (!sessions[s->s_mds])
+				sessions[s->s_mds] = ceph_get_mds_session(s);
 		}
 		spin_unlock(&ci->i_ceph_lock);
+		mutex_unlock(&mdsc->mutex);
 
 		/* send flush mdlog request to MDSes */
 		for (i = 0; i < max_sessions; i++) {
-- 
2.31.1

