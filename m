Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBFA540AE0
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350788AbiFGSYY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352268AbiFGSRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB457A82A;
        Tue,  7 Jun 2022 10:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F856616A3;
        Tue,  7 Jun 2022 17:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB2DC34115;
        Tue,  7 Jun 2022 17:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624277;
        bh=W1dWzICFRP6sYvlkV3Ti3k7/EiLaFrobnxuCwIq+YeY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5p4uW5JSiicqumzkUPCXQXVYFQY4a/I1UFt1X4vYQVHwAfymRd3bpHXViBuSyaGX
         IMYLn8oXaSmrBHN2VbLRq+8hfcmnNSIY05R/6W06sXr5HEA3a0iJXhLhCT398uHt1v
         +DsOIZf1EzOqxpIZC2pOGim4e056Z+XUZssbcEdDt62VMtwWjhGUHzX6KzabHhXgoz
         CHqoNW2+EVim8iEHlagcvT/m3ckhrV3iGEhS6nDigeqJ59hgAZgenqALGosIgMbXm0
         P3kj5H5seSyxEmZDF3vnQBx5Ex/KZXG7wYHlPktr6f7pFHW6zy73hEvdwJncXwEQXh
         8685hWkNTBHiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>, ceph-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 42/68] ceph: flush the mdlog for filesystem sync
Date:   Tue,  7 Jun 2022 13:48:08 -0400
Message-Id: <20220607174846.477972-42-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit 1b2ba3c5616e17ff951359e25c658a1c3f146f1e ]

Before waiting for a request's safe reply, we will send the mdlog flush
request to the relevant MDS. And this will also flush the mdlog for all
the other unsafe requests in the same session, so we can record the last
session and no need to flush mdlog again in the next loop. But there
still have cases that it may send the mdlog flush requst twice or more,
but that should be not often.

Rename wait_unsafe_requests() to
flush_mdlog_and_wait_mdsc_unsafe_requests() to make it more
descriptive.

[xiubli: fold in MDS request refcount leak fix from Jeff]

URL: https://tracker.ceph.com/issues/55284
URL: https://tracker.ceph.com/issues/55411
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/mds_client.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 00c3de177dd6..86215822e84e 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4696,15 +4696,17 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 }
 
 /*
- * wait for all write mds requests to flush.
+ * flush the mdlog and wait for all write mds requests to flush.
  */
-static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
+static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *mdsc,
+						 u64 want_tid)
 {
 	struct ceph_mds_request *req = NULL, *nextreq;
+	struct ceph_mds_session *last_session = NULL;
 	struct rb_node *n;
 
 	mutex_lock(&mdsc->mutex);
-	dout("wait_unsafe_requests want %lld\n", want_tid);
+	dout("%s want %lld\n", __func__, want_tid);
 restart:
 	req = __get_oldest_req(mdsc);
 	while (req && req->r_tid <= want_tid) {
@@ -4716,14 +4718,32 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 			nextreq = NULL;
 		if (req->r_op != CEPH_MDS_OP_SETFILELOCK &&
 		    (req->r_op & CEPH_MDS_OP_WRITE)) {
+			struct ceph_mds_session *s = req->r_session;
+
+			if (!s) {
+				req = nextreq;
+				continue;
+			}
+
 			/* write op */
 			ceph_mdsc_get_request(req);
 			if (nextreq)
 				ceph_mdsc_get_request(nextreq);
+			s = ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
-			dout("wait_unsafe_requests  wait on %llu (want %llu)\n",
+
+			/* send flush mdlog request to MDS */
+			if (last_session != s) {
+				send_flush_mdlog(s);
+				ceph_put_mds_session(last_session);
+				last_session = s;
+			} else {
+				ceph_put_mds_session(s);
+			}
+			dout("%s wait on %llu (want %llu)\n", __func__,
 			     req->r_tid, want_tid);
 			wait_for_completion(&req->r_safe_completion);
+
 			mutex_lock(&mdsc->mutex);
 			ceph_mdsc_put_request(req);
 			if (!nextreq)
@@ -4738,7 +4758,8 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 		req = nextreq;
 	}
 	mutex_unlock(&mdsc->mutex);
-	dout("wait_unsafe_requests done\n");
+	ceph_put_mds_session(last_session);
+	dout("%s done\n", __func__);
 }
 
 void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
@@ -4767,7 +4788,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
 	dout("sync want tid %lld flush_seq %lld\n",
 	     want_tid, want_flush);
 
-	wait_unsafe_requests(mdsc, want_tid);
+	flush_mdlog_and_wait_mdsc_unsafe_requests(mdsc, want_tid);
 	wait_caps_flush(mdsc, want_flush);
 }
 
-- 
2.35.1

