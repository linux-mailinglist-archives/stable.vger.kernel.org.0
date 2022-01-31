Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0FE4A4422
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359281AbiAaL0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:26:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56790 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377752AbiAaLYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6272C61298;
        Mon, 31 Jan 2022 11:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67330C340E8;
        Mon, 31 Jan 2022 11:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628268;
        bh=qk9u8HkJMkipvnE4bSjIQsDwSh/2/xDehKN+Oc7cf/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sP8lTFBz9YKUcebVy1BVQH2oTK6ZNyLS+bOD8dRcAyKcISiZBVRLKtsoy8Ga/mlbr
         CplKTxBA3gOaOG1ZZYWe1k6mxeS53firQDke6+eUmp5hxoCDNp9Oi+XoHTOtSFgPBZ
         XH8Lvl+q8RN41W1+dJ4nCJAjDpcJswPevdo8mV88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Venky Shankar <vshankar@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 179/200] ceph: put the requests/sessions when it fails to alloc memory
Date:   Mon, 31 Jan 2022 11:57:22 +0100
Message-Id: <20220131105239.567707487@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 55 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c447fa2e2d1fe..2f8696f3b925d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2218,6 +2218,7 @@ static int unsafe_request_wait(struct inode *inode)
 	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
+	unsigned int max_sessions;
 	int ret, err = 0;
 
 	spin_lock(&ci->i_unsafe_lock);
@@ -2235,37 +2236,45 @@ static int unsafe_request_wait(struct inode *inode)
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
@@ -2278,8 +2287,14 @@ retry:
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
@@ -2300,7 +2315,7 @@ retry:
 		spin_unlock(&ci->i_ceph_lock);
 
 		/* send flush mdlog request to MDSes */
-		for (i = 0; i < max; i++) {
+		for (i = 0; i < max_sessions; i++) {
 			s = sessions[i];
 			if (s) {
 				send_flush_mdlog(s);
@@ -2317,15 +2332,19 @@ retry:
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
2.34.1



