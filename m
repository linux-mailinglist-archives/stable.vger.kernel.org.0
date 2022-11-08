Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2FB621306
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234313AbiKHNpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234516AbiKHNpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:45:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B1D58019
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:45:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 723F56157B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:45:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F31AC433D6;
        Tue,  8 Nov 2022 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915131;
        bh=kkjN/KRhh6xBx2WHw5rItKz/+zMA1O7c1FfmaB11wDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2HxGWnF5/V96LavyV6UdDC3aL8WS09bzpuZL4sdKpf7rU06qJIq9flmqCsYmXfSgR
         RGNXnh89Xy1OFNLSppsMwMBuk7vajXbzhz+PIK58XZp6THNXSC7SKKNkqpVLdkgQEM
         wXvpzk3rosQCSsCRPPbYL2wyBuEMCRSbAGSW7Svs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/48] NFSv4.1: We must always send RECLAIM_COMPLETE after a reboot
Date:   Tue,  8 Nov 2022 14:38:47 +0100
Message-Id: <20221108133329.607896093@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e59679f2b7e522ecad99974e5636291ffd47c184 ]

Currently, we are only guaranteed to send RECLAIM_COMPLETE if we have
open state to recover. Fix the client to always send RECLAIM_COMPLETE
after setting up the lease.

Fixes: fce5c838e133 ("nfs41: RECLAIM_COMPLETE functionality")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 0679858dc3b3..5ab021f87ecf 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1736,6 +1736,7 @@ static void nfs4_state_mark_reclaim_helper(struct nfs_client *clp,
 
 static void nfs4_state_start_reclaim_reboot(struct nfs_client *clp)
 {
+	set_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state);
 	/* Mark all delegations for reclaim */
 	nfs_delegation_mark_reclaim(clp);
 	nfs4_state_mark_reclaim_helper(clp, nfs4_state_mark_reclaim_reboot);
-- 
2.35.1



