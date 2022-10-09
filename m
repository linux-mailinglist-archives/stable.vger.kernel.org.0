Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D4B5F8E1C
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbiJIUxu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbiJIUxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:53:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3512BB0C;
        Sun,  9 Oct 2022 13:52:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC3DFB80DC9;
        Sun,  9 Oct 2022 20:52:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F342EC433D6;
        Sun,  9 Oct 2022 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348743;
        bh=yFHH9o1hn/EBF5U+mxfRPXuFxPOQ9JFIUNmg3pQq0LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kwc+HsA20GEGKdRcOCRoZMoEUQ0UERnxqfO4gbXWQzuT3BPmZmFUAUr8dh5dmOdAc
         ZHInTBoWfxvGe8fIbbfsw1kZLpp/hZMe1EoMmn9sebkRvtUtosJwO0zsUjbXoPufmj
         hUch1I6iRKihgvWccuMZo1duj6v/tPTM6pTqmjhvW39FqhqjGfenwUx1+gBHfdzIEx
         kLMJb7fN6silXbuvdKw+ArFcZ44B0edAEOAQ9DxLgQ2ARthCfyou+TMV+tOmblotfV
         XzEXde1R0mn5goNybp1G1axagJ9HHcBpjlKHKXOqd2jj37UJboO6OTAxx648VGTGCd
         XSZtCl7RGuPLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 17/18] NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data
Date:   Sun,  9 Oct 2022 16:51:34 -0400
Message-Id: <20221009205136.1201774-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205136.1201774-1-sashal@kernel.org>
References: <20221009205136.1201774-1-sashal@kernel.org>
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
index 1e9690a061ec..01dd73ed5720 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3994,7 +3994,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	}
 	if (resp->xdr->buf->page_len && splice_ok) {
 		WARN_ON_ONCE(1);
-		return nfserr_resource;
+		return nfserr_serverfault;
 	}
 	xdr_commit_encode(xdr);
 
-- 
2.35.1

