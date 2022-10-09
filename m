Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9DAC5F8ECB
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 23:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbiJIVJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 17:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiJIVIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 17:08:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B6F3EA79;
        Sun,  9 Oct 2022 14:03:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B18B160C93;
        Sun,  9 Oct 2022 20:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CF4C433C1;
        Sun,  9 Oct 2022 20:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348882;
        bh=jW4elg5loCepsK7wp7uNpCRmDv18t0TzV6USqvCTJKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z4QEtltISOtR9KLFCfzVn0qrTbDvxlQ1dyO3fIpS0+339gTARwWe1P4dFj8Td+iuC
         cjtga/q0Wb+QmdKzgngSHVuHYjlqztBbI1+khAYItz+uv2B+/6x7t7IJ6Nh1HJWki2
         UeBZpOfISjk4UAID+cXKm0OtT9ZJyabWtp4RdXeNNYZV+viBZVafidu8n6RYOdgKON
         xLate6BXb+lXZNVrnSmGlkq+lqBW5iPEJ+QDyC4zyzA2onIiH0ng0/aZTaay0ralfZ
         ctpHU8SNhZUzDfNYF98jx9HO+X8Nzdk/HMOmAGfo/COPFFbYDwX4OyQjso863k9C3M
         mRyt6cA6Ewc9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 6/6] NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data
Date:   Sun,  9 Oct 2022 16:54:22 -0400
Message-Id: <20221009205423.1203538-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205423.1203538-1-sashal@kernel.org>
References: <20221009205423.1203538-1-sashal@kernel.org>
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
index e61d9c435957..95bbe9d4018a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3600,7 +3600,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	if (resp->xdr.buf->page_len &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
 		WARN_ON_ONCE(1);
-		return nfserr_resource;
+		return nfserr_serverfault;
 	}
 	xdr_commit_encode(xdr);
 
-- 
2.35.1

