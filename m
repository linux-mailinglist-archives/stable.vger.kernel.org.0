Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D606214F1
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiKHOGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:06:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiKHOGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:06:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF24F7054A
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:06:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B2CB6152D
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A44C433D6;
        Tue,  8 Nov 2022 14:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916407;
        bh=lT8aBcHHy1SJ8TCiyEg38XLiruCUZBSpFaPnz5ppt0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0SfIvBbXFA7KKf0n/1aTeglDpI7hCgVkSWdS6X+DRamNmnOKgdohcgLJD6UZB6Ozc
         WWv/nUkicf6uDFtWgmRpZ3PFpqgDlhxVCZpA03/IplpqOM4SmifurvAYwRpZvgQfOQ
         NWNR45KOTTrXtF52R9Kfaq/o/h0K1m1lCzxHBzMw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 011/197] NFSv4.1: Handle RECLAIM_COMPLETE trunking errors
Date:   Tue,  8 Nov 2022 14:37:29 +0100
Message-Id: <20221108133355.296980593@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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
index 9bab3e9c702a..0b6bd6336c98 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -2671,6 +2671,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			if (status < 0)
 				goto out_error;
 			nfs4_state_end_reclaim_reboot(clp);
+			continue;
 		}
 
 		/* Detect expired delegations... */
-- 
2.35.1



