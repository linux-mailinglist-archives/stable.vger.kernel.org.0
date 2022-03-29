Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF64EA634
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 05:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbiC2D62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 23:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiC2D61 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 23:58:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF12A65B6;
        Mon, 28 Mar 2022 20:56:44 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id y16so3440910pju.4;
        Mon, 28 Mar 2022 20:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=iOk6JIffNayUkevvRGbPEy7BxILIghcR3ACILdtVQ/A=;
        b=mHnieJwMGGIyOTLgSitqGcvQtd1arJHPkUpV3KCDhD78bGVTuVE4OSFbs8PjTOfHe8
         6V73zkiq7sM3jDbiNUyZGnQ+DENX+L4axq0pfxSIqPqQxcoHOF6dxSbIzsSgytCyky7g
         M1bXBZ2eMdUh/G/M/EcVL7Q+JqjM2ketFGchKOEqRcK53c/RKzyOab9UZodIXUQU9mOr
         T5InOgIXp98DV4OJCC61HfC5R0S9Fd5twScqfSgYfrwx03nZ8SVKOpYPH/KMxMCit+kC
         CWieSMAwBp4zkUnVJohFDf440iPjwJKZFHW7OVZJ/9vHFNii7PzPRjaAe16sDoxqHgQK
         dr+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iOk6JIffNayUkevvRGbPEy7BxILIghcR3ACILdtVQ/A=;
        b=ALbuDb/VnqSil96/ln+/W1RltbX3WMa22mQe26q2kUUXCVs3L1Obetmwl6hkkHE2Kh
         b80OfwKKzcTHqVodmwkhxwh+gzMCTT36s5c/N0L/Iu9wX9rSgas9ws90C5CiLn3PokcT
         /Q73nviucErKDHiQ+TURNd8ovv2ozjU+wyRIdchQnKqO2BkOJ1o5YWV/OjUWQFG9xIEj
         rXqFSFTEm63bbps37TDohoCILRYzleSOCMUto2DrIo2DWSnZRJRk9zzwagsdksacvSSG
         I14n74SpKSE8q5ITx1s2Q6AI4hQw2Z5eB5GxQaI8ax6+iD8ODOkwI5sq6vCrdmsuEgqI
         Kj9w==
X-Gm-Message-State: AOAM531xLLKswiRU0oppVXmx9B5a2d8FRUl39lCzBVw5qtkKV/gCLvyZ
        CKUONALxkyPAPvuq6nziAEw=
X-Google-Smtp-Source: ABdhPJwHarnnOb/wYCh7Y9bUSdXstuTQhgu0M/kAwvbQqCQ+H3MBf9S5wUTVtFf98K5gVNpREwlrqg==
X-Received: by 2002:a17:90b:4c49:b0:1c7:d6c1:bb0f with SMTP id np9-20020a17090b4c4900b001c7d6c1bb0fmr2433153pjb.230.1648526204288;
        Mon, 28 Mar 2022 20:56:44 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id h189-20020a636cc6000000b0039841f669bcsm5520083pgc.78.2022.03.28.20.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 20:56:43 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     trond.myklebust@hammerspace.com, anna@kernel.org
Cc:     bhalevy@panasas.com, bharrosh@panasas.com,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] NFSv4/pNFS: fix incorrect uses of list iterator
Date:   Tue, 29 Mar 2022 11:56:33 +0800
Message-Id: <20220329035633.14380-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
	if (!server ||
	server->pnfs_curr_ld->id != dev->cbd_layout_type) {

The list iterator value 'server' will *always* be set and non-NULL
by list_for_each_entry_rcu, so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element is
found (In fact, it will be a bogus pointer to an invalid struct
object containing the HEAD, which is used for above check at next
outer loop). Otherwise it may bypass the check in theory (if
server->pnfs_curr_ld->id == dev->cbd_layout_type, 'server' now is
a bogus pointer) and lead to invalid memory access passing the check.

Furthermore, even if we have a valid pointer, nothing pins the super
block, and so the struct nfs_server could end up getting freed while
we're using it.

Since all we want is a pointer to the struct pnfs_layoutdriver_type,
let's skip all the iteration over super blocks, and just use API to
find the layout driver directly. And to avoid use last found 'ld'
which may not exists any more, just call the API for every 'dev'.

At the same time, move the code to make the logic clearer.

Cc: stable@vger.kernel.org
Fixes: 1be5683b03a76 ("pnfs: CB_NOTIFY_DEVICEID")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---

changes since v1:
 - use API to find the layout driver directly (Trond Myklebust)
 - avoid use last found 'ld' (Xiaomeng Tong)
 - code movement (Xiaomeng Tong)

v1:https://lore.kernel.org/lkml/20220327080230.12134-1-xiam0nd.tong@gmail.com/

---
 fs/nfs/callback_proc.c | 32 ++++++++++----------------------
 fs/nfs/pnfs.c          |  5 +++++
 fs/nfs/pnfs.h          |  1 +
 3 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/fs/nfs/callback_proc.c b/fs/nfs/callback_proc.c
index c343666d9a42..579887749870 100644
--- a/fs/nfs/callback_proc.c
+++ b/fs/nfs/callback_proc.c
@@ -358,39 +358,27 @@ __be32 nfs4_callback_devicenotify(void *argp, void *resp,
 				  struct cb_process_state *cps)
 {
 	struct cb_devicenotifyargs *args = argp;
+	const struct pnfs_layoutdriver_type *ld;
 	uint32_t i;
-	__be32 res = 0;
-	struct nfs_client *clp = cps->clp;
-	struct nfs_server *server = NULL;
 
-	if (!clp) {
-		res = cpu_to_be32(NFS4ERR_OP_NOT_IN_SESSION);
-		goto out;
+	if (!cps->clp) {
+		kfree(args->devs);
+		return cpu_to_be32(NFS4ERR_OP_NOT_IN_SESSION);
 	}
 
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
+		ld = pnfs_find_layoutdriver(dev->cbd_layout_type);
+		if (ld) {
+			nfs4_delete_deviceid(ld, cps->clp,
+						&dev->cbd_dev_id);
+			module_put(ld->owner);
 		}
-
-	found:
-		nfs4_delete_deviceid(server->pnfs_curr_ld, clp, &dev->cbd_dev_id);
 	}
 
-out:
 	kfree(args->devs);
-	return res;
+	return 0;
 }
 
 /*
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 7c9090a28e5c..112c36977feb 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -92,6 +92,11 @@ find_pnfs_driver(u32 id)
 	return local;
 }
 
+const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id)
+{
+	return find_pnfs_driver(id);
+}
+
 void
 unset_pnfs_layoutdriver(struct nfs_server *nfss)
 {
diff --git a/fs/nfs/pnfs.h b/fs/nfs/pnfs.h
index f4d7548d67b2..873ea8fe945b 100644
--- a/fs/nfs/pnfs.h
+++ b/fs/nfs/pnfs.h
@@ -234,6 +234,7 @@ struct pnfs_devicelist {
 
 extern int pnfs_register_layoutdriver(struct pnfs_layoutdriver_type *);
 extern void pnfs_unregister_layoutdriver(struct pnfs_layoutdriver_type *);
+extern const struct pnfs_layoutdriver_type *pnfs_find_layoutdriver(u32 id);
 
 /* nfs4proc.c */
 extern size_t max_response_pages(struct nfs_server *server);
-- 
2.17.1

