Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A5C6810A8
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237068AbjA3OFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237067AbjA3OFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:05:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F7F3B3C2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 102F261034
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2110C4339C;
        Mon, 30 Jan 2023 14:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087529;
        bh=JiadrZOK1rKEMD3JOP8CbdUEDzY3eFYXUhac1tDo3ZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5z55nW+t5RltS6tYvjX9y0aWBDJwhf1UwXdHTMnltA+DX6BGgCXexpEKDHQ4tD0K
         DCa0faZnPh1qOwnnnXKitXZ/d5UWYYa1uVOnXB5NjmOteUnSpPRaGNmAf4tAxIzejY
         w9C/MlFl4k6bhF8VCo5XbFri2oEcgOHkjrs/mCps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ruben Vestergaard <rubenv@drcmr.dk>,
        Torkil Svensgaard <torkil@drcmr.dk>,
        Shachar Kagan <skagan@nvidia.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 209/313] nfsd: dont free files unconditionally in __nfsd_file_cache_purge
Date:   Mon, 30 Jan 2023 14:50:44 +0100
Message-Id: <20230130134346.430994882@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 4bdbba54e9b1c769da8ded9abd209d765715e1d6 ]

nfsd_file_cache_purge is called when the server is shutting down, in
which case, tearing things down is generally fine, but it also gets
called when the exports cache is flushed.

Instead of walking the cache and freeing everything unconditionally,
handle it the same as when we have a notification of conflicting access.

Fixes: ac3a2585f018 ("nfsd: rework refcounting in filecache")
Reported-by: Ruben Vestergaard <rubenv@drcmr.dk>
Reported-by: Torkil Svensgaard <torkil@drcmr.dk>
Reported-by: Shachar Kagan <skagan@nvidia.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Tested-by: Shachar Kagan <skagan@nvidia.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 61 ++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index ea6fb0e6b165..142b3c928f76 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -638,6 +638,39 @@ static struct shrinker	nfsd_file_shrinker = {
 	.seeks = 1,
 };
 
+/**
+ * nfsd_file_cond_queue - conditionally unhash and queue a nfsd_file
+ * @nf: nfsd_file to attempt to queue
+ * @dispose: private list to queue successfully-put objects
+ *
+ * Unhash an nfsd_file, try to get a reference to it, and then put that
+ * reference. If it's the last reference, queue it to the dispose list.
+ */
+static void
+nfsd_file_cond_queue(struct nfsd_file *nf, struct list_head *dispose)
+	__must_hold(RCU)
+{
+	int decrement = 1;
+
+	/* If we raced with someone else unhashing, ignore it */
+	if (!nfsd_file_unhash(nf))
+		return;
+
+	/* If we can't get a reference, ignore it */
+	if (!nfsd_file_get(nf))
+		return;
+
+	/* Extra decrement if we remove from the LRU */
+	if (nfsd_file_lru_remove(nf))
+		++decrement;
+
+	/* If refcount goes to 0, then put on the dispose list */
+	if (refcount_sub_and_test(decrement, &nf->nf_ref)) {
+		list_add(&nf->nf_lru, dispose);
+		trace_nfsd_file_closing(nf);
+	}
+}
+
 /**
  * nfsd_file_queue_for_close: try to close out any open nfsd_files for an inode
  * @inode:   inode on which to close out nfsd_files
@@ -665,30 +698,11 @@ nfsd_file_queue_for_close(struct inode *inode, struct list_head *dispose)
 
 	rcu_read_lock();
 	do {
-		int decrement = 1;
-
 		nf = rhashtable_lookup(&nfsd_file_rhash_tbl, &key,
 				       nfsd_file_rhash_params);
 		if (!nf)
 			break;
-
-		/* If we raced with someone else unhashing, ignore it */
-		if (!nfsd_file_unhash(nf))
-			continue;
-
-		/* If we can't get a reference, ignore it */
-		if (!nfsd_file_get(nf))
-			continue;
-
-		/* Extra decrement if we remove from the LRU */
-		if (nfsd_file_lru_remove(nf))
-			++decrement;
-
-		/* If refcount goes to 0, then put on the dispose list */
-		if (refcount_sub_and_test(decrement, &nf->nf_ref)) {
-			list_add(&nf->nf_lru, dispose);
-			trace_nfsd_file_closing(nf);
-		}
+		nfsd_file_cond_queue(nf, dispose);
 	} while (1);
 	rcu_read_unlock();
 }
@@ -905,11 +919,8 @@ __nfsd_file_cache_purge(struct net *net)
 
 		nf = rhashtable_walk_next(&iter);
 		while (!IS_ERR_OR_NULL(nf)) {
-			if (!net || nf->nf_net == net) {
-				nfsd_file_unhash(nf);
-				nfsd_file_lru_remove(nf);
-				list_add(&nf->nf_lru, &dispose);
-			}
+			if (!net || nf->nf_net == net)
+				nfsd_file_cond_queue(nf, &dispose);
 			nf = rhashtable_walk_next(&iter);
 		}
 
-- 
2.39.0



