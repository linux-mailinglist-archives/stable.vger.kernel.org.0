Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF13063DE36
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiK3SfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiK3Sep (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:34:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735E893A6F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:34:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB8A061D73
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98B3C433D7;
        Wed, 30 Nov 2022 18:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833283;
        bh=MuMwmeHl2ukvK1/BxUJkEYsLfNX5qSaqtD8SUpNM+kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upPJkrRP6BvGUgQZprFnHlajLteqxkAjobyevzL99aiV/clOBBWtIJEy8cDN8zj+u
         uUJz/Y2O4hfHKZhk7YTzuXsqZqzHHsXT+snoeZQ1D9Bxo5vKsnuYt0gkq5HEzboWpa
         Vlm8KgvLza5JBKBZTJ6ckI+2J2iLjVbCXUFv9ThE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/206] ceph: do not update snapshot context when there is no new snapshot
Date:   Wed, 30 Nov 2022 19:21:16 +0100
Message-Id: <20221130180533.611541998@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

[ Upstream commit 2e586641c950e7f3e7e008404bd783a466b9b590 ]

We will only track the uppest parent snapshot realm from which we
need to rebuild the snapshot contexts _downward_ in hierarchy. For
all the others having no new snapshot we will do nothing.

This fix will avoid calling ceph_queue_cap_snap() on some inodes
inappropriately. For example, with the code in mainline, suppose there
are 2 directory hierarchies (with 6 directories total), like this:

/dir_X1/dir_X2/dir_X3/
/dir_Y1/dir_Y2/dir_Y3/

Firstly, make a snapshot under /dir_X1/dir_X2/.snap/snap_X2, then make a
root snapshot under /.snap/root_snap. Every time we make snapshots under
/dir_Y1/..., the kclient will always try to rebuild the snap context for
snap_X2 realm and finally will always try to queue cap snaps for dir_Y2
and dir_Y3, which makes no sense.

That's because the snap_X2's seq is 2 and root_snap's seq is 3. So when
creating a new snapshot under /dir_Y1/... the new seq will be 4, and
the mds will send the kclient a snapshot backtrace in _downward_
order: seqs 4, 3.

When ceph_update_snap_trace() is called, it will always rebuild the from
the last realm, that's the root_snap. So later when rebuilding the snap
context, the current logic will always cause it to rebuild the snap_X2
realm and then try to queue cap snaps for all the inodes related in that
realm, even though it's not necessary.

This is accompanied by a lot of these sorts of dout messages:

    "ceph:  queue_cap_snap 00000000a42b796b nothing dirty|writing"

Fix the logic to avoid this situation.

Also, the 'invalidate' word is not precise here. In actuality, it will
cause a rebuild of the existing snapshot contexts or just build
non-existent ones. Rename it to 'rebuild_snapcs'.

URL: https://tracker.ceph.com/issues/44100
Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 51884d153f7e ("ceph: avoid putting the realm twice when decoding snaps fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/snap.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index b41e6724c591..ae9cf37374e3 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -707,7 +707,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	__le64 *prior_parent_snaps;        /* encoded */
 	struct ceph_snap_realm *realm = NULL;
 	struct ceph_snap_realm *first_realm = NULL;
-	int invalidate = 0;
+	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	int rebuild_snapcs;
 	int err = -ENOMEM;
 	LIST_HEAD(dirty_realms);
 
@@ -715,6 +716,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
 	p += sizeof(*ri);
@@ -738,7 +740,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
 	if (err < 0)
 		goto fail;
-	invalidate += err;
+	rebuild_snapcs += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
 		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
@@ -763,22 +765,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 		if (realm->seq > mdsc->last_snap_seq)
 			mdsc->last_snap_seq = realm->seq;
 
-		invalidate = 1;
+		rebuild_snapcs = 1;
 	} else if (!realm->cached_context) {
 		dout("update_snap_trace %llx %p seq %lld new\n",
 		     realm->ino, realm, realm->seq);
-		invalidate = 1;
+		rebuild_snapcs = 1;
 	} else {
 		dout("update_snap_trace %llx %p seq %lld unchanged\n",
 		     realm->ino, realm, realm->seq);
 	}
 
-	dout("done with %llx %p, invalidated=%d, %p %p\n", realm->ino,
-	     realm, invalidate, p, e);
+	dout("done with %llx %p, rebuild_snapcs=%d, %p %p\n", realm->ino,
+	     realm, rebuild_snapcs, p, e);
 
-	/* invalidate when we reach the _end_ (root) of the trace */
-	if (invalidate && p >= e)
-		rebuild_snap_realms(realm, &dirty_realms);
+	/*
+	 * this will always track the uppest parent realm from which
+	 * we need to rebuild the snapshot contexts _downward_ in
+	 * hierarchy.
+	 */
+	if (rebuild_snapcs)
+		realm_to_rebuild = realm;
+
+	/* rebuild_snapcs when we reach the _end_ (root) of the trace */
+	if (realm_to_rebuild && p >= e)
+		rebuild_snap_realms(realm_to_rebuild, &dirty_realms);
 
 	if (!first_realm)
 		first_realm = realm;
-- 
2.35.1



