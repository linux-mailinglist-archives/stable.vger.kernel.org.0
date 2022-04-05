Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FE74F3E41
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382533AbiDEMPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243409AbiDEKfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:35:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A3351326;
        Tue,  5 Apr 2022 03:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93A71B81C98;
        Tue,  5 Apr 2022 10:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03DD2C385A0;
        Tue,  5 Apr 2022 10:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154065;
        bh=ycQWrZjQ6til+kCrXM9OxU+VmAfujOA5Ig+3kccmxUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AB6gJ9jZE+NWbBFrVbBLyNLYxndv6fOTQF/P63p2ZeqPgJKwwfB1FNmk2xK5jWUP/
         g4PAuKGZcnrg1tHUWFUkpXWIjpRR/rN5gS953zXplBt511xTcwHXp3ghrj1arznS9P
         taquQeodg45lEs4QHj/9JbLJ3T1fQUl8ABjK5CpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 444/599] NFSv4/pNFS: Fix another issue with a list iterator pointing to the head
Date:   Tue,  5 Apr 2022 09:32:18 +0200
Message-Id: <20220405070312.043320138@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 7c9d845f0612e5bcd23456a2ec43be8ac43458f1 ]

In nfs4_callback_devicenotify(), if we don't find a matching entry for
the deviceid, we're left with a pointer to 'struct nfs_server' that
actually points to the list of super blocks associated with our struct
nfs_client.
Furthermore, even if we have a valid pointer, nothing pins the super
block, and so the struct nfs_server could end up getting freed while
we're using it.

Since all we want is a pointer to the struct pnfs_layoutdriver_type,
let's skip all the iteration over super blocks, and just use APIs to
find the layout driver directly.

Reported-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Fixes: 1be5683b03a7 ("pnfs: CB_NOTIFY_DEVICEID")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_proc.c | 27 +++++++++------------------
 fs/nfs/pnfs.c          | 11 +++++++++++
 fs/nfs/pnfs.h          |  2 ++
 3 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index b44219ce60b8..a5209643ac36 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -353,12 +353,11 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 				  struct cb_process_state *cps)
 {
 	struct cb_devicenotifyargs *args = argp;
+	const struct pnfs_layoutdriver_type *ld = NULL;
 	uint32_t i;
 	__be32 res = 0;
-	struct nfs_client *clp = cps->clp;
-	struct nfs_server *server = NULL;
 
-	if (!clp) {
+	if (!cps->clp) {
 		res = cpu_to_be32(NFS4ERR_OP_NOT_IN_SESSION);
 		goto out;
 	}
@@ -366,23 +365,15 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 	for (i = 0; i < args->ndevs; i++) {
 		struct cb_devicenotifyitem *dev = &args->devs[i];
 
-		if (!server ||
-		    server->pnfs_curr_ld->id != dev->cbd_layout_type) {
-			rcu_read_lock();
-			list_for_each_entry_rcu(server, &clp->cl_superblocks, client_link)
-				if (server->pnfs_curr_ld &&
-				    server->pnfs_curr_ld->id == dev->cbd_layout_type) {
-					rcu_read_unlock();
-					goto found;
-				}
-			rcu_read_unlock();
-			continue;
+		if (!ld || ld->id != dev->cbd_layout_type) {
+			pnfs_put_layoutdriver(ld);
+			ld = pnfs_find_layoutdriver(dev->cbd_layout_type);
+			if (!ld)
+				continue;
 		}
-
-	found:
-		nfs4_delete_deviceid(server->pnfs_curr_ld, clp, &dev->cbd_dev_id);
+		nfs4_delete_deviceid(ld, cps->clp, &dev->cbd_dev_id);
 	}
-
+	pnfs_put_layoutdriver(ld);
 out:
 	kfree(args->devs);
 	return res;
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 5370e082aded..b3b9eff5d572 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -92,6 +92,17 @@ find_pnfs_driver(u32 id)
 	return local;
 }
 
+const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id)
+{
+	return find_pnfs_driver(id);
+}
+
+void pnfs_put_layoutdriver(const struct pnfs_layoutdriver_type *ld)
+{
+	if (ld)
+		module_put(ld->owner);
+}
+
 void
 unset_pnfs_layoutdriver(struct nfs_server *nfss)
 {
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index 0212fe32e63a..11d9ed9addc0 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -236,6 +236,8 @@ struct pnfs_devicelist {
 
 extern int pnfs_register_layoutdriver(struct pnfs_layoutdriver_type *);
 extern void pnfs_unregister_layoutdriver(struct pnfs_layoutdriver_type *);
+extern const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id);
+extern void pnfs_put_layoutdriver(const struct pnfs_layoutdriver_type *ld);
 
 /* nfs4proc.c */
 extern size_t max_response_pages(struct nfs_server *server);
-- 
2.34.1



