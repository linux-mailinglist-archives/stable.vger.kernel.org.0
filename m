Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C89B63DF10
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbiK3Snb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiK3SnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:43:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BC555A80
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B60561D4F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8DAC433C1;
        Wed, 30 Nov 2022 18:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833799;
        bh=2eIZVKRdyWTi+TtsyTwI17f7oViA0B4JHT34CtM4hVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VpRl7+ACcR0Mi86gQWSNZ8i3f9HJag12xWui/oaAGZF5qWZitrO5KsAGZ7iuk5DiM
         VEdfqfoji439hmtd0gRX9gNR3QlzokBMzB0RyFwR6MQ8YN5/UlgPPzl2m+wn5/I7oh
         qzLZq+g30T5twrPrgfN62RXKtD7/gN30Ydw533FM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 003/289] ceph: fix NULL pointer dereference for req->r_session
Date:   Wed, 30 Nov 2022 19:19:48 +0100
Message-Id: <20221130180544.191441145@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 5bd76b8de5b74fa941a6eafee87728a0fe072267 ]

The request's r_session maybe changed when it was forwarded or
resent. Both the forwarding and resending cases the requests will
be protected by the mdsc->mutex.

Cc: stable@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2137955
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 48 ++++++++++++------------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 1eb2ff0f6bd8..02b5c0ac5654 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2247,7 +2247,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
-	unsigned int max_sessions;
 	int ret, err = 0;
 
 	spin_lock(&ci->i_unsafe_lock);
@@ -2265,28 +2264,24 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
@@ -2298,16 +2293,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
@@ -2320,16 +2305,6 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
@@ -2341,11 +2316,12 @@ static int flush_mdlog_and_wait_inode_unsafe_requests(struct inode *inode)
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
2.35.1



