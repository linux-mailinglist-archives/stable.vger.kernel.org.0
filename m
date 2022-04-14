Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C66D05014F9
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245397AbiDNNnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344078AbiDNNaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4F3117D;
        Thu, 14 Apr 2022 06:27:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEEEE6190F;
        Thu, 14 Apr 2022 13:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACCFC385A1;
        Thu, 14 Apr 2022 13:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942864;
        bh=pq5Hkm5sFmOw4+bSV+L9OhXIlFKnUqlcIn+go98fDOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijCF15l19Sqi4SZIlgeVvJja3RBJwnbyJirewikgVEWeHEEp9aIO2Qhu/yoAmCskC
         ViOVDNp9eYj/7R76OhGCVQVePuYE7EjCRXqAtQaXsRhK31YJ3cXeNDouzbtxrugYwq
         zKjDTkPXX0DNP99h6mYXOKoKXG1HpilcWP7nLcbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 290/338] NFSv4: Protect the state recovery thread against direct reclaim
Date:   Thu, 14 Apr 2022 15:13:13 +0200
Message-Id: <20220414110847.143408909@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 9c98547fcefc..30576a10a1f4 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -49,6 +49,7 @@
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
+#include <linux/sched/mm.h>
 
 #include <linux/sunrpc/clnt.h>
 
@@ -2505,9 +2506,17 @@ static int nfs4_bind_conn_to_session(struct nfs_client *clp)
 
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
 				goto out_error;
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



