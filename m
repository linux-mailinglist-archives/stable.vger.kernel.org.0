Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811CA5F8E74
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiJIU6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiJIU5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:57:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4CF32044;
        Sun,  9 Oct 2022 13:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF21760C79;
        Sun,  9 Oct 2022 20:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91008C433D7;
        Sun,  9 Oct 2022 20:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348827;
        bh=5PG47T3Lk85ysYxu1Fte6j55xzyZkLG55nlS1tiE5TA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FlZvrNppHkodgmcXI6It8gsDRwxZt77twZlzMSP4Hrtb+aHSg/3QxbhaKzeASiq4c
         DC8BxKlDQ99JPKKfuS0E5g7gZEqfR0QVi1WsX6mOx4T+KTjXSV93NwGjVmcD60hnDs
         BQwKyOlvfLlJHGf67Rk7B3qNe1nyxfb3Ln0Wwj4jWssdHgLksccxemegxx+awxTokd
         UzWEdnggosZMoGliVY0FoCiWlYc+P11SCR4ynJFDqwyDj8vsxL9l37b4NJgLrH8It9
         tRossDyK/tsU4LXKFCbRIXEFzqJ2QcM8W2Q9MFPJ0pRI8KjWFQmzTkReMnBDsffiVY
         9SJXJ9bkxrUBw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/15] NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data
Date:   Sun,  9 Oct 2022 16:53:07 -0400
Message-Id: <20221009205308.1202627-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205308.1202627-1-sashal@kernel.org>
References: <20221009205308.1202627-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anna Schumaker <Anna.Schumaker@Netapp.com>

[ Upstream commit 06981d560606ac48d61e5f4fff6738b925c93173 ]

This was discussed with Chuck as part of this patch set. Returning
nfserr_resource was decided to not be the best error message here, and
he suggested changing to nfserr_serverfault instead.

Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Link: https://lore.kernel.org/linux-nfs/20220907195259.926736-1-anna@kernel.org/T/#t
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index f6d385e0efec..f559405772c5 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3993,7 +3993,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	if (resp->xdr->buf->page_len &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
 		WARN_ON_ONCE(1);
-		return nfserr_resource;
+		return nfserr_serverfault;
 	}
 	xdr_commit_encode(xdr);
 
-- 
2.35.1

