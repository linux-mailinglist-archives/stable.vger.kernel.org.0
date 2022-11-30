Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24A3B63DDD6
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiK3SbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiK3SbB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:31:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3CF5E9F7
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:31:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED661B81C9A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4639FC433D7;
        Wed, 30 Nov 2022 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833057;
        bh=/pdnx0dewe/fKJFu6PPxo5guj67PUUcG/kiCGr7+ia4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x35/5xI5WVebbQmNEF9BuA7EKy8W4NPsgjzUdvtwjrEj9kQ5JFPwsHejw2MvlayYt
         OzyagnIxDSSXvzwWmTroA7IZ+Y4PrExgjgC94Y/KFNeRnkzoexpa34Z3mx3D+2TqjY
         7UyENTl15z1YxqfWTtJSRNRnpgJGgzogHmOVOTLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/162] ceph: make iterate_sessions a global symbol
Date:   Wed, 30 Nov 2022 19:23:09 +0100
Message-Id: <20221130180531.417780192@linuxfoundation.org>
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

[ Upstream commit 59b312f36230ea91ebb6ce1b11f2781604495d30 ]

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c       | 26 +----------------------
 fs/ceph/mds_client.c | 49 +++++++++++++++++++++++++++++---------------
 fs/ceph/mds_client.h |  3 +++
 3 files changed, 36 insertions(+), 42 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 76e43a487bc6..7ae27a18cf18 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4310,33 +4310,9 @@ static void flush_dirty_session_caps(struct ceph_mds_session *s)
 	dout("flush_dirty_caps done\n");
 }
 
-static void iterate_sessions(struct ceph_mds_client *mdsc,
-			     void (*cb)(struct ceph_mds_session *))
-{
-	int mds;
-
-	mutex_lock(&mdsc->mutex);
-	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
-		struct ceph_mds_session *s;
-
-		if (!mdsc->sessions[mds])
-			continue;
-
-		s = ceph_get_mds_session(mdsc->sessions[mds]);
-		if (!s)
-			continue;
-
-		mutex_unlock(&mdsc->mutex);
-		cb(s);
-		ceph_put_mds_session(s);
-		mutex_lock(&mdsc->mutex);
-	}
-	mutex_unlock(&mdsc->mutex);
-}
-
 void ceph_flush_dirty_caps(struct ceph_mds_client *mdsc)
 {
-	iterate_sessions(mdsc, flush_dirty_session_caps);
+	ceph_mdsc_iterate_sessions(mdsc, flush_dirty_session_caps, true);
 }
 
 void __ceph_touch_fmode(struct ceph_inode_info *ci,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 36cf3638f501..45587b3025e4 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -809,6 +809,33 @@ static void put_request_session(struct ceph_mds_request *req)
 	}
 }
 
+void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
+				void (*cb)(struct ceph_mds_session *),
+				bool check_state)
+{
+	int mds;
+
+	mutex_lock(&mdsc->mutex);
+	for (mds = 0; mds < mdsc->max_sessions; ++mds) {
+		struct ceph_mds_session *s;
+
+		s = __ceph_lookup_mds_session(mdsc, mds);
+		if (!s)
+			continue;
+
+		if (check_state && !check_session_state(s)) {
+			ceph_put_mds_session(s);
+			continue;
+		}
+
+		mutex_unlock(&mdsc->mutex);
+		cb(s);
+		ceph_put_mds_session(s);
+		mutex_lock(&mdsc->mutex);
+	}
+	mutex_unlock(&mdsc->mutex);
+}
+
 void ceph_mdsc_release_request(struct kref *kref)
 {
 	struct ceph_mds_request *req = container_of(kref,
@@ -4377,24 +4404,12 @@ void ceph_mdsc_lease_send_msg(struct ceph_mds_session *session,
 }
 
 /*
- * lock unlock sessions, to wait ongoing session activities
+ * lock unlock the session, to wait ongoing session activities
  */
-static void lock_unlock_sessions(struct ceph_mds_client *mdsc)
+static void lock_unlock_session(struct ceph_mds_session *s)
 {
-	int i;
-
-	mutex_lock(&mdsc->mutex);
-	for (i = 0; i < mdsc->max_sessions; i++) {
-		struct ceph_mds_session *s = __ceph_lookup_mds_session(mdsc, i);
-		if (!s)
-			continue;
-		mutex_unlock(&mdsc->mutex);
-		mutex_lock(&s->s_mutex);
-		mutex_unlock(&s->s_mutex);
-		ceph_put_mds_session(s);
-		mutex_lock(&mdsc->mutex);
-	}
-	mutex_unlock(&mdsc->mutex);
+	mutex_lock(&s->s_mutex);
+	mutex_unlock(&s->s_mutex);
 }
 
 static void maybe_recover_session(struct ceph_mds_client *mdsc)
@@ -4658,7 +4673,7 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 	dout("pre_umount\n");
 	mdsc->stopping = 1;
 
-	lock_unlock_sessions(mdsc);
+	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
 	ceph_flush_dirty_caps(mdsc);
 	wait_requests(mdsc);
 
diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
index c0cff765cbf5..88fc80832016 100644
--- a/fs/ceph/mds_client.h
+++ b/fs/ceph/mds_client.h
@@ -518,6 +518,9 @@ static inline void ceph_mdsc_put_request(struct ceph_mds_request *req)
 	kref_put(&req->r_kref, ceph_mdsc_release_request);
 }
 
+extern void ceph_mdsc_iterate_sessions(struct ceph_mds_client *mdsc,
+				       void (*cb)(struct ceph_mds_session *),
+				       bool check_state);
 extern struct ceph_msg *ceph_create_session_msg(u32 op, u64 seq);
 extern void __ceph_queue_cap_release(struct ceph_mds_session *session,
 				    struct ceph_cap *cap);
-- 
2.35.1



