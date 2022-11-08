Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7973E62129B
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbiKHNlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiKHNlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:41:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DFD4509B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:41:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA90C61582
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65F6C433D6;
        Tue,  8 Nov 2022 13:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667914860;
        bh=6Qn56G56Gi5D/BceXKMlfSKBjn/FXMdS4NwJy3k6ar8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVt2HFDkg97Bb84anu9lveANeBAgztmnZhnkg+m7MWpotqfE1QV0iEGKqDC2sOaCU
         e1IA5mzXjh3TpTSSRMD77GrNm4tzB+YRxgzeuR9svxOo+KBAuaJ7hEaOvlMefdq2e1
         8w8lK1mN9JpbBIelYlHDImpjs0iXSq+/7wO8a7y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/30] NFSv4.1: We must always send RECLAIM_COMPLETE after a reboot
Date:   Tue,  8 Nov 2022 14:38:50 +0100
Message-Id: <20221108133326.813419239@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133326.715586431@linuxfoundation.org>
References: <20221108133326.715586431@linuxfoundation.org>
User-Agent: quilt/0.67
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
index 2df0a1be5974..dcb2c8b4a14d 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1656,6 +1656,7 @@ static void nfs4_state_mark_reclaim_helper(struct nfs_client *clp,
 
 static void nfs4_state_start_reclaim_reboot(struct nfs_client *clp)
 {
+	set_bit(NFS4CLNT_RECLAIM_REBOOT, &clp->cl_state);
 	/* Mark all delegations for reclaim */
 	nfs_delegation_mark_reclaim(clp);
 	nfs4_state_mark_reclaim_helper(clp, nfs4_state_mark_reclaim_reboot);
-- 
2.35.1



