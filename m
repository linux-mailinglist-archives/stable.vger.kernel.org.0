Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6439063214C
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 12:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiKULwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 06:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiKULwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 06:52:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667E1F04
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 03:52:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0436D6112D
        for <stable@vger.kernel.org>; Mon, 21 Nov 2022 11:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE37C433C1;
        Mon, 21 Nov 2022 11:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669031554;
        bh=HnybsgpMLnR0km/ksR2ryPBrGWjQ2kr5omVz4arES7s=;
        h=Subject:To:Cc:From:Date:From;
        b=gzZ0B7sOsmr44RkXZ9VjFFImjxVlFfIP6L+Sfqo97B3VzVC3FtgcvNLuWEFUuVZwd
         RMf0wPno45IMzIZHjHkY0lwgFhMr/8w2f52Ppm4pRg5V6UFtPGnmGIK2CXGx+5xtNN
         j5rR5gtNhVblpj04ScxdQYrm+xSJ0cHGNGMNLIeo=
Subject: FAILED: patch "[PATCH] ceph: fix NULL pointer dereference for req->r_session" failed to apply to 6.0-stable tree
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Nov 2022 12:52:31 +0100
Message-ID: <16690315514754@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
aa1d627207ca ("ceph: Use kcalloc for allocating multiple elements")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5bd76b8de5b74fa941a6eafee87728a0fe072267 Mon Sep 17 00:00:00 2001
From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 10 Nov 2022 21:01:59 +0800
Subject: [PATCH] ceph: fix NULL pointer dereference for req->r_session

The request's r_session maybe changed when it was forwarded or
resent. Both the forwarding and resending cases the requests will
be protected by the mdsc->mutex.

Cc: stable@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index fb023f9fafcb..e54814d0c2f7 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2248,7 +2248,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
-	unsigned int max_sessions;
 	int ret, err = 0;
 
 	spin_lock(&ci->i_unsafe_lock);
@@ -2266,28 +2265,24 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
@@ -2299,16 +2294,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
@@ -2321,16 +2306,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
@@ -2342,11 +2317,12 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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

