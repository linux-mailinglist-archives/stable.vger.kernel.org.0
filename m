Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 297AA6AFD21
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 03:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbjCHC5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 21:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCHC5d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 21:57:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40E4A2F04
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:56:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678244209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fenccMkVzQhfUbRyk0gDbDuiJqGvqystJgPIWnrh6dg=;
        b=bBhy6eBW/YOukVa7FhlfdvPHDbluPTcv1cLfRQ+wj2hOpeAbcMNpduZiVxQl+/xzo3l7Y2
        YKW1U8m/wBeUOijOkhN6FgoaJEYHsb0aVpITBgiSdI+neJnMA8gkR1Iy/8Z4uLXRHOsTYB
        Xc5+RHADpVJH8ey54C5CTtNsYBKQYQI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-301-vp4N95AKNxKHNfOI0j08xA-1; Tue, 07 Mar 2023 21:56:45 -0500
X-MC-Unique: vp4N95AKNxKHNfOI0j08xA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49F163C18348;
        Wed,  8 Mar 2023 02:56:45 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32BEC492C3E;
        Wed,  8 Mar 2023 02:56:41 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, lhenriques@suse.de, vshankar@redhat.com,
        mchangir@redhat.com, Xiubo Li <xiubli@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH] ceph: implement writeback livelock avoidance using page tagging
Date:   Wed,  8 Mar 2023 10:56:30 +0800
Message-Id: <20230308025630.276866-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

While the mapped IOs continue if we try to flush a file's buffer
we can see that the fsync() won't complete until the IOs finish.

This is analogous to Jan Kara's commit (f446daaea9d4 mm: implement
writeback livelock avoidance using page tagging), we will try to
avoid livelocks of writeback when some steadily creates dirty pages
in a mapping we are writing out.

Cc: stable@vger.kernel.org
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/addr.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 5731b82bf368..caf6ac5c1390 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -879,6 +879,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 	bool should_loop, range_whole = false;
 	bool done = false;
 	bool caching = ceph_is_cache_enabled(inode);
+	xa_mark_t tag;
 
 	if (wbc->sync_mode == WB_SYNC_NONE &&
 	    fsc->write_congested)
@@ -905,6 +906,11 @@ static int ceph_writepages_start(struct address_space *mapping,
 	start_index = wbc->range_cyclic ? mapping->writeback_index : 0;
 	index = start_index;
 
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages) {
+		tag = PAGECACHE_TAG_TOWRITE;
+	} else {
+		tag = PAGECACHE_TAG_DIRTY;
+	}
 retry:
 	/* find oldest snap context with dirty data */
 	snapc = get_oldest_context(inode, &ceph_wbc, NULL);
@@ -943,6 +949,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 		dout(" non-head snapc, range whole\n");
 	}
 
+	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
+		tag_pages_for_writeback(mapping, index, end);
+
 	ceph_put_snap_context(last_snapc);
 	last_snapc = snapc;
 
@@ -959,7 +968,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 
 get_more_pages:
 		pvec_pages = pagevec_lookup_range_tag(&pvec, mapping, &index,
-						end, PAGECACHE_TAG_DIRTY);
+						      end, tag);
 		dout("pagevec_lookup_range_tag got %d\n", pvec_pages);
 		if (!pvec_pages && !locked_pages)
 			break;
-- 
2.31.1

