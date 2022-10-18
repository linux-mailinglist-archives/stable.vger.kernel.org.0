Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7632E601E92
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiJRALY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiJRAKc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:10:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B852188DF9;
        Mon, 17 Oct 2022 17:08:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 962B5B81BF0;
        Tue, 18 Oct 2022 00:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FDBC43142;
        Tue, 18 Oct 2022 00:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051711;
        bh=nEH+r7D8W3FBPSF9L6Fil1nK3FYPAVrJbycjF4rrmXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dek5bSgp18EMf1drsPG2AnFRqly6JWckTe1enm7nN5Pfif3LCCO9OuT+h+1OCvkEa
         TL75OM3cgoLZlY00YSm47+7g4WrDAecwCE2YiiMEcJj2wTsrFv1DFv9oDtcSVS+xyB
         z0PkLkNCrrXgOE1dAnxbrWkZ4riVCqAkt6vQArCh7J8TpGxWmW4sqsoiurlWNsIshw
         HkogDQ7f2EvCoEDh/yWpBXWfQC96wc7SauNWMomAAxpPfnHfDmAxWWtDWJMMkLKer/
         7bRwaeHp39UZu+jZd9X/bMoIDJwUn3RTDzl+K2sbO4cbOCqw5qPgHVNE9o/vdYsun6
         6qQPKt8pQ52OQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 28/32] nfsd: fix nfsd_file_unhash_and_dispose
Date:   Mon, 17 Oct 2022 20:07:25 -0400
Message-Id: <20221018000729.2730519-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 8d0d254b15cc5b7d46d85fb7ab8ecede9575e672 ]

nfsd_file_unhash_and_dispose() is called for two reasons:

We're either shutting down and purging the filecache, or we've gotten a
notification about a file delete, so we want to go ahead and unhash it
so that it'll get cleaned up when we close.

We're either walking the hashtable or doing a lookup in it and we
don't take a reference in either case. What we want to do in both cases
is to try and unhash the object and put it on the dispose list if that
was successful. If it's no longer hashed, then we don't want to touch
it, with the assumption being that something else is already cleaning
up the sentinel reference.

Instead of trying to selectively decrement the refcount in this
function, just unhash it, and if that was successful, move it to the
dispose list. Then, the disposal routine will just clean that up as
usual.

Also, just make this a void function, drop the WARN_ON_ONCE, and the
comments about deadlocking since the nature of the purported deadlock
is no longer clear.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index eeed4ae5b4ad..844c41832d50 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -405,22 +405,15 @@ nfsd_file_unhash(struct nfsd_file *nf)
 	return false;
 }
 
-/*
- * Return true if the file was unhashed.
- */
-static bool
+static void
 nfsd_file_unhash_and_dispose(struct nfsd_file *nf, struct list_head *dispose)
 {
 	trace_nfsd_file_unhash_and_dispose(nf);
-	if (!nfsd_file_unhash(nf))
-		return false;
-	/* keep final reference for nfsd_file_lru_dispose */
-	if (refcount_dec_not_one(&nf->nf_ref))
-		return true;
-
-	nfsd_file_lru_remove(nf);
-	list_add(&nf->nf_lru, dispose);
-	return true;
+	if (nfsd_file_unhash(nf)) {
+		/* caller must call nfsd_file_dispose_list() later */
+		nfsd_file_lru_remove(nf);
+		list_add(&nf->nf_lru, dispose);
+	}
 }
 
 static void
@@ -562,8 +555,6 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
  * @lock: LRU list lock (unused)
  * @arg: dispose list
  *
- * Note this can deadlock with nfsd_file_cache_purge.
- *
  * Return values:
  *   %LRU_REMOVED: @item was removed from the LRU
  *   %LRU_ROTATE: @item is to be moved to the LRU tail
@@ -748,8 +739,6 @@ nfsd_file_close_inode(struct inode *inode)
  *
  * Walk the LRU list and close any entries that have not been used since
  * the last scan.
- *
- * Note this can deadlock with nfsd_file_cache_purge.
  */
 static void
 nfsd_file_delayed_close(struct work_struct *work)
@@ -891,16 +880,12 @@ nfsd_file_cache_init(void)
 	goto out;
 }
 
-/*
- * Note this can deadlock with nfsd_file_lru_cb.
- */
 static void
 __nfsd_file_cache_purge(struct net *net)
 {
 	struct rhashtable_iter iter;
 	struct nfsd_file *nf;
 	LIST_HEAD(dispose);
-	bool del;
 
 	rhashtable_walk_enter(&nfsd_file_rhash_tbl, &iter);
 	do {
@@ -910,14 +895,7 @@ __nfsd_file_cache_purge(struct net *net)
 		while (!IS_ERR_OR_NULL(nf)) {
 			if (net && nf->nf_net != net)
 				continue;
-			del = nfsd_file_unhash_and_dispose(nf, &dispose);
-
-			/*
-			 * Deadlock detected! Something marked this entry as
-			 * unhased, but hasn't removed it from the hash list.
-			 */
-			WARN_ON_ONCE(!del);
-
+			nfsd_file_unhash_and_dispose(nf, &dispose);
 			nf = rhashtable_walk_next(&iter);
 		}
 
-- 
2.35.1

