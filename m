Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB2B63DDB7
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbiK3S3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiK3S3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:29:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3998D650
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E791861D4D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C50C433D7;
        Wed, 30 Nov 2022 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832983;
        bh=UkTMcxe9P7gciZKzGqb3voP85XLPOnI4y4i67ayDqQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKBcS75awCVFBJ/dlRvnJ/ydvvsIj4sR9ix5+3n/NOFIEiM8uxlkF0W1cJlvIKULp
         +8TwH66Bj8zqvfln9rQQ1YZbuvq+5Jcuut3Km80jmP08wQs2TkyzRgVu/zecYHxT+4
         I0ZoyKWEkWx378TmTPsxMOBWZQDZsaivoPzY6SJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/162] ceph: flush the mdlog before waiting on unsafe reqs
Date:   Wed, 30 Nov 2022 19:23:11 +0100
Message-Id: <20221130180531.470667867@linuxfoundation.org>
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

[ Upstream commit e1a4541ec0b951685a49d1f72d183681e6433a45 ]

For the client requests who will have unsafe and safe replies from
MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
(journal log) immediatelly, because they think it's unnecessary.
That's true for most cases but not all, likes the fsync request.
The fsync will wait until all the unsafe replied requests to be
safely replied.

Normally if there have multiple threads or clients are running, the
whole mdlog in MDS daemons could be flushed in time if any request
will trigger the mdlog submit thread. So usually we won't experience
the normal operations will stuck for a long time. But in case there
has only one client with only thread is running, the stuck phenomenon
maybe obvious and the worst case it must wait at most 5 seconds to
wait the mdlog to be flushed by the MDS's tick thread periodically.

This patch will trigger to flush the mdlog in the relevant and auth
MDSes to which the in-flight requests are sent just before waiting
the unsafe requests to finish.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 7ae27a18cf18..2fa6b7cc0cc4 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2294,6 +2294,7 @@ static int caps_are_flushed(struct inode *inode, u64 flush_tid)
  */
 static int unsafe_request_wait(struct inode *inode)
 {
+	struct ceph_mds_client *mdsc = ceph_sb_to_client(inode->i_sb)->mdsc;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_mds_request *req1 = NULL, *req2 = NULL;
 	int ret, err = 0;
@@ -2313,6 +2314,81 @@ static int unsafe_request_wait(struct inode *inode)
 	}
 	spin_unlock(&ci->i_unsafe_lock);
 
+	/*
+	 * Trigger to flush the journal logs in all the relevant MDSes
+	 * manually, or in the worst case we must wait at most 5 seconds
+	 * to wait the journal logs to be flushed by the MDSes periodically.
+	 */
+	if (req1 || req2) {
+		struct ceph_mds_session **sessions = NULL;
+		struct ceph_mds_session *s;
+		struct ceph_mds_request *req;
+		unsigned int max;
+		int i;
+
+		/*
+		 * The mdsc->max_sessions is unlikely to be changed
+		 * mostly, here we will retry it by reallocating the
+		 * sessions arrary memory to get rid of the mdsc->mutex
+		 * lock.
+		 */
+retry:
+		max = mdsc->max_sessions;
+		sessions = krealloc(sessions, max * sizeof(s), __GFP_ZERO);
+		if (!sessions)
+			return -ENOMEM;
+
+		spin_lock(&ci->i_unsafe_lock);
+		if (req1) {
+			list_for_each_entry(req, &ci->i_unsafe_dirops,
+					    r_unsafe_dir_item) {
+				s = req->r_session;
+				if (unlikely(s->s_mds > max)) {
+					spin_unlock(&ci->i_unsafe_lock);
+					goto retry;
+				}
+				if (!sessions[s->s_mds]) {
+					s = ceph_get_mds_session(s);
+					sessions[s->s_mds] = s;
+				}
+			}
+		}
+		if (req2) {
+			list_for_each_entry(req, &ci->i_unsafe_iops,
+					    r_unsafe_target_item) {
+				s = req->r_session;
+				if (unlikely(s->s_mds > max)) {
+					spin_unlock(&ci->i_unsafe_lock);
+					goto retry;
+				}
+				if (!sessions[s->s_mds]) {
+					s = ceph_get_mds_session(s);
+					sessions[s->s_mds] = s;
+				}
+			}
+		}
+		spin_unlock(&ci->i_unsafe_lock);
+
+		/* the auth MDS */
+		spin_lock(&ci->i_ceph_lock);
+		if (ci->i_auth_cap) {
+		      s = ci->i_auth_cap->session;
+		      if (!sessions[s->s_mds])
+			      sessions[s->s_mds] = ceph_get_mds_session(s);
+		}
+		spin_unlock(&ci->i_ceph_lock);
+
+		/* send flush mdlog request to MDSes */
+		for (i = 0; i < max; i++) {
+			s = sessions[i];
+			if (s) {
+				send_flush_mdlog(s);
+				ceph_put_mds_session(s);
+			}
+		}
+		kfree(sessions);
+	}
+
 	dout("unsafe_request_wait %p wait on tid %llu %llu\n",
 	     inode, req1 ? req1->r_tid : 0ULL, req2 ? req2->r_tid : 0ULL);
 	if (req1) {
-- 
2.35.1



