Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8557463DDBC
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbiK3SaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiK3S36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:29:58 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9F78D65E
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:29:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 042F5CE1AD1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D79C433C1;
        Wed, 30 Nov 2022 18:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832989;
        bh=0Rw3glO7BbKdV2UUK99NIwbtnCBZNmi/5PROH3ajUa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbQOrrLPLv3R89VgewHnpivLuto5gET2pNLn7FlIf8fbchs8IEdYjeKvd6upYe925
         Vc+9PnIA41WEixfkCrc/Y/aCkVn04hO7UoX62xwFdLdRZ1crycOG/3G3kTGzrMpe+e
         SvfqR5o+r2iHw8a7/ZGc7E/Pae9XTXJ+kNMfAC7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/162] ceph: put the requests/sessions when it fails to alloc memory
Date:   Wed, 30 Nov 2022 19:23:13 +0100
Message-Id: <20221130180531.525751501@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

[ Upstream commit 89d43d0551a848e70e63d9ba11534aaeabc82443 ]

When failing to allocate the sessions memory we should make sure
the req1 and req2 and the sessions get put. And also in case the
max_sessions decreased so when kreallocate the new memory some
sessions maybe missed being put.

And if the max_sessions is 0 krealloc will return ZERO_SIZE_PTR,
which will lead to a distinct access fault.

URL: https://tracker.ceph.com/issues/53819
Fixes: e1a4541ec0b9 ("ceph: flush the mdlog before waiting on unsafe reqs")
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Venky Shankar <vshankar@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 55 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index f14d52848b91..4e2fada35808 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2297,6 +2297,7 @@ static int unsafe_request_wait(struct inode *inode)
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
+	unsigned int max_sessions;
 	int ret, err = 0;
 
 	spin_lock(&ci->i_unsafe_lock);
@@ -2314,37 +2315,45 @@ static int unsafe_request_wait(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
+	/*
+	 * The mdsc->max_sessions is unlikely to be changed
+	 * mostly, here we will retry it by reallocating the
+	 * sessions array memory to get rid of the mdsc->mutex
+	 * lock.
+	 */
+retry:
+	max_sessions = mdsc->max_sessions;
+
 	/*
 	 * Trigger to flush the journal logs in all the relevant MDSes
 	 * manually, or in the worst case we must wait at most 5 seconds
 	 * to wait the journal logs to be flushed by the MDSes periodically.
 	 */
-	if (req1 || req2) {
+	if ((req1 || req2) && likely(max_sessions)) {
 		struct ceph_mds_session **sessions = NULL;
 		struct ceph_mds_session *s;
 		struct ceph_mds_request *req;
-		unsigned int max;
 		int i;
 
-		/*
-		 * The mdsc->max_sessions is unlikely to be changed
-		 * mostly, here we will retry it by reallocating the
-		 * sessions arrary memory to get rid of the mdsc->mutex
-		 * lock.
-		 */
-retry:
-		max = mdsc->max_sessions;
-		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
-		if (!sessions)
-			return -ENOMEM;
+		sessions = kzalloc(max_sessions * sizeof(s), GFP_KERNEL);
+		if (!sessions) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		spin_lock(&ci->i_unsafe_lock);
 		if (req1) {
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds >= max)) {
+				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
+					for (i = 0; i < max_sessions; i++) {
+						s = sessions[i];
+						if (s)
+							ceph_put_mds_session(s);
+					}
+					kfree(sessions);
 					goto retry;
 				}
 				if (!sessions[s->s_mds]) {
@@ -2357,8 +2366,14 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds >= max)) {
+				if (unlikely(s->s_mds >= max_sessions)) {
 					spin_unlock(&ci->i_unsafe_lock);
+					for (i = 0; i < max_sessions; i++) {
+						s = sessions[i];
+						if (s)
+							ceph_put_mds_session(s);
+					}
+					kfree(sessions);
 					goto retry;
 				}
 				if (!sessions[s->s_mds]) {
@@ -2379,7 +2394,7 @@ static int unsafe_request_wait(struct inode *inode)
 		spin_unlock(&ci->i_ceph_lock);
 
 		/* send flush mdlog request to MDSes */
-		for (i = 0; i < max; i++) {
+		for (i = 0; i < max_sessions; i++) {
 			s = sessions[i];
 			if (s) {
 				send_flush_mdlog(s);
@@ -2396,15 +2411,19 @@ static int unsafe_request_wait(struct inode *inode)
 					ceph_timeout_jiffies(req1->r_timeout));
 		if (ret)
 			err = -EIO;
-		ceph_mdsc_put_request(req1);
 	}
 	if (req2) {
 		ret = !wait_for_completion_timeout(&req2->r_safe_completion,
 					ceph_timeout_jiffies(req2->r_timeout));
 		if (ret)
 			err = -EIO;
-		ceph_mdsc_put_request(req2);
 	}
+
+out:
+	if (req1)
+		ceph_mdsc_put_request(req1);
+	if (req2)
+		ceph_mdsc_put_request(req2);
 	return err;
 }
 
-- 
2.35.1



