Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836826212C8
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbiKHNmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234455AbiKHNmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:42:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FD617590
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2345B81AEF
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18008C433D6;
        Tue,  8 Nov 2022 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914958;
        bh=6H2TV0W27miLJ/OOr4ZGiSoOPT4aOsZpyJM6JlZSwnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SN/Neh1EmE7kCfbDWdAPdKnwiQxi1RhSFFVmDj0DlI+WIW0+TwUdryGKczID5nobL
         VIgb4PSlwm8lwkZuCNKE1/RSJzwzrlCV+XHipuzEC/etXUBvSm7o+h9xdUdVs5B/5m
         DJRHgvjWkIp45qhqXLHYbPCNH+o5MHW7dKgNsg58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/40] NFSv4.1: Handle RECLAIM_COMPLETE trunking errors
Date:   Tue,  8 Nov 2022 14:38:46 +0100
Message-Id: <20221108133328.410328669@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133328.351887714@linuxfoundation.org>
References: <20221108133328.351887714@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 5d917cba3201e5c25059df96c29252fd99c4f6a7 ]

If RECLAIM_COMPLETE sets the NFS4CLNT_BIND_CONN_TO_SESSION flag, then we
need to loop back in order to handle it.

Fixes: 0048fdd06614 ("NFSv4.1: RECLAIM_COMPLETE must handle NFS4ERR_CONN_NOT_BOUND_TO_SESSION")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index c0987557d4ab..1cd2350816e2 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2507,6 +2507,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			if (status < 0)
 				goto out_error;
 			nfs4_state_end_reclaim_reboot(clp);
+			continue;
 		}
 
 		/* Detect expired delegations... */
-- 
2.35.1



