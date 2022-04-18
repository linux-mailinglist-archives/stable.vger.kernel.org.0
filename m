Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67EF505646
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242753AbiDRNdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244657AbiDRNaq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:30:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E4D65AA;
        Mon, 18 Apr 2022 05:54:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83DBFB80EC0;
        Mon, 18 Apr 2022 12:54:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFD9C385A1;
        Mon, 18 Apr 2022 12:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286496;
        bh=0U1MH4AX840DC71MLBIHArHoLkvJ7+npJ2kTWvIyvH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgS4OmBTU6mIyvNEm1+j4uWg1zrNP6tg20egnQg1K/NUDGLiXVoR6yJISMQ8xNPpQ
         1C1phSzjswkAojjs+yy2tZhFd1IinWisS9+DhOC2/ouLaX+f9rZnv0yfQ+nzdeLSU9
         nfhOHioUfwoBsdwo529WTgEtL8yk4ESs5iTruh80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 153/284] NFSv4/pNFS: Fix another issue with a list iterator pointing to the head
Date:   Mon, 18 Apr 2022 14:12:14 +0200
Message-Id: <20220418121216.033306116@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3998b432e1b9..825b3166605d 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -355,12 +355,11 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
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
@@ -368,23 +367,15 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
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
index 619fc5c4c82c..18bbdaefd940 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -91,6 +91,17 @@ find_pnfs_driver(u32 id)
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
index 965d657086c8..3504826c1ee7 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -219,6 +219,8 @@ struct pnfs_devicelist {
 
 extern int pnfs_register_layoutdriver(struct pnfs_layoutdriver_type *);
 extern void pnfs_unregister_layoutdriver(struct pnfs_layoutdriver_type *);
+extern const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id);
+extern void pnfs_put_layoutdriver(const struct pnfs_layoutdriver_type *ld);
 
 /* nfs4proc.c */
 extern int nfs4_proc_getdeviceinfo(struct nfs_server *server,
-- 
2.34.1



