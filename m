Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B546A4FD3BB
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355840AbiDLH3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351469AbiDLHUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920C628E28;
        Mon, 11 Apr 2022 23:59:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D11C8615BB;
        Tue, 12 Apr 2022 06:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F2EC385A1;
        Tue, 12 Apr 2022 06:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746776;
        bh=hZRak8zB8UWPBxxT//igy3oc37r7YLVaBqEBOxrUdtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WISlkggcuVESbQEOT29xZc82Uu2b59fbnzGkC0SbnvpO4Y2hk13ktm4pN7M8/hTA5
         hlNUmYH3LjgyRZXmJJqyHtLkpD88IgWUYgHh7ZJhvWmkQOaFX831JAj2rxmjl1Q1Aa
         DSiStbkDLZc+nBUIia2qkYr0MfUs7tQerX5qogoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 127/285] NFSv4: Protect the state recovery thread against direct reclaim
Date:   Tue, 12 Apr 2022 08:29:44 +0200
Message-Id: <20220412062947.331674049@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

[ Upstream commit 3e17898aca293a24dae757a440a50aa63ca29671 ]

If memory allocation triggers a direct reclaim from the state recovery
thread, then we can deadlock. Use memalloc_nofs_save/restore to ensure
that doesn't happen.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 499bef9fe118..94f1876afab2 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -49,6 +49,7 @@
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
+#include <linux/sched/mm.h>
 
 #include <linux/sunrpc/clnt.h>
 
@@ -2560,9 +2561,17 @@ static void nfs4_layoutreturn_any_run(struct nfs_client *clp)
 
 static void nfs4_state_manager(struct nfs_client *clp)
 {
+	unsigned int memflags;
 	int status = 0;
 	const char *section = "", *section_sep = "";
 
+	/*
+	 * State recovery can deadlock if the direct reclaim code tries
+	 * start NFS writeback. So ensure memory allocations are all
+	 * GFP_NOFS.
+	 */
+	memflags = memalloc_nofs_save();
+
 	/* Ensure exclusive access to NFSv4 state */
 	do {
 		trace_nfs4_state_mgr(clp);
@@ -2657,6 +2666,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			clear_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state);
 		}
 
+		memalloc_nofs_restore(memflags);
 		nfs4_end_drain_session(clp);
 		nfs4_clear_state_manager_bit(clp);
 
@@ -2674,6 +2684,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			return;
 		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
 			return;
+		memflags = memalloc_nofs_save();
 	} while (refcount_read(&clp->cl_count) > 1 && !signalled());
 	goto out_drain;
 
@@ -2686,6 +2697,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			clp->cl_hostname, -status);
 	ssleep(1);
 out_drain:
+	memalloc_nofs_restore(memflags);
 	nfs4_end_drain_session(clp);
 	nfs4_clear_state_manager_bit(clp);
 }
-- 
2.35.1



