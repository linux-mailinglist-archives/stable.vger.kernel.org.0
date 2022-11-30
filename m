Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B876463DD58
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiK3S0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiK3S0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:26:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A21627F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:26:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0853461D54
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197DEC433C1;
        Wed, 30 Nov 2022 18:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832793;
        bh=nCl8VUdqjDdIGYK0NPBCPNGX5RBo/mSM7xKiI8PAYMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ar3bQKiISd8/k6mPhu1LcWq9bDSaMSo777wgl7mMZKW8fk/joQAkVAFAOuH19ngNK
         KHVTupVnZek2BtFtxVIqFIaCyv0qnXZpKbvjKn3p06Ad4j2SuW/5H/CRZdGuIegq5a
         /QrECa9pz5aMDyweD+FBN/SXXRoBByFtEWz0sJ4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 013/162] ceph: do not update snapshot context when there is no new snapshot
Date:   Wed, 30 Nov 2022 19:21:34 +0100
Message-Id: <20221130180528.855134475@linuxfoundation.org>
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
index 0369f672a76f..e779f0e2bdb8 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -699,7 +699,8 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	__le64 *prior_parent_snaps;        /* encoded */
 	struct ceph_snap_realm *realm = NULL;
 	struct ceph_snap_realm *first_realm = NULL;
-	int invalidate = 0;
+	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	int rebuild_snapcs;
 	int err = -ENOMEM;
 	LIST_HEAD(dirty_realms);
 
@@ -707,6 +708,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 
 	dout("update_snap_trace deletion=%d\n", deletion);
 more:
+	rebuild_snapcs = 0;
 	ceph_decode_need(&p, e, sizeof(*ri), bad);
 	ri = p;
 	p += sizeof(*ri);
@@ -730,7 +732,7 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	err = adjust_snap_realm_parent(mdsc, realm, le64_to_cpu(ri->parent));
 	if (err < 0)
 		goto fail;
-	invalidate += err;
+	rebuild_snapcs += err;
 
 	if (le64_to_cpu(ri->seq) > realm->seq) {
 		dout("update_snap_trace updating %llx %p %lld -> %lld\n",
@@ -755,22 +757,30 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
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



