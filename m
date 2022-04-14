Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADA105010F4
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343542AbiDNOIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 10:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347176AbiDNN6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:58:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26BEB8207;
        Thu, 14 Apr 2022 06:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCD9561DE7;
        Thu, 14 Apr 2022 13:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CBFC385A1;
        Thu, 14 Apr 2022 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649944146;
        bh=6Gbe4J2EhR/VgiSxky4sq29L3flJuguxPUi/AjaeUlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H1M4vpCm4NGdTHsglJ9H2wW5hBpFkf7rqP8MrSXcZtVjSMQCtYfB73yd2aUmu/Jus
         x4UJnbZooOev1r3DlX3cGH5zszusABOOEyEoIWtUW9A3aiEEotYd9xsCu3z7F5pGO0
         t/3BGuWkunc2WKFFJU6uCrwfPUpq+9EIPIuW/wsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 410/475] NFSv4: Protect the state recovery thread against direct reclaim
Date:   Thu, 14 Apr 2022 15:13:15 +0200
Message-Id: <20220414110906.539053686@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index aa2caba38a01..1d2b81a233bb 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -49,6 +49,7 @@
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
+#include <linux/sched/mm.h>
 
 #include <linux/sunrpc/clnt.h>
 
@@ -2504,9 +2505,17 @@ static int nfs4_bind_conn_to_session(struct nfs_client *clp)
 
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
 		clear_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state);
@@ -2600,6 +2609,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			clear_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state);
 		}
 
+		memalloc_nofs_restore(memflags);
 		nfs4_end_drain_session(clp);
 		nfs4_clear_state_manager_bit(clp);
 
@@ -2616,6 +2626,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			return;
 		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
 			return;
+		memflags = memalloc_nofs_save();
 	} while (refcount_read(&clp->cl_count) > 1 && !signalled());
 	goto out_drain;
 
@@ -2627,6 +2638,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			clp->cl_hostname, -status);
 	ssleep(1);
 out_drain:
+	memalloc_nofs_restore(memflags);
 	nfs4_end_drain_session(clp);
 	nfs4_clear_state_manager_bit(clp);
 }
-- 
2.35.1



