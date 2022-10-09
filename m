Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE6E5F8EBC
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 23:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiJIVEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 17:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiJIVDT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 17:03:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E79B2FC3C;
        Sun,  9 Oct 2022 13:57:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6E84B80DC6;
        Sun,  9 Oct 2022 20:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F071BC43143;
        Sun,  9 Oct 2022 20:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348907;
        bh=yxPrtX9CbNfBgVgzqmzwqBKqwbTagH6YcualEdEN0T4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxWfN3wwjCJLfKpbks5a1vSowAafKRsSWiPOZuR5A6vevXmCbmIa11mUnrBtyUg7U
         mz5bbBL/R6D7lZZKwl6R7ByIuYUOzV/Tno+jZPVkdg57DLQ7bMMFczLdcj98r++fwJ
         JwvklYhEFygQkOt0oxrI3FUhDXOfBGnY9ig/QdtmtpJET+ZnhOclYUR3VZbTo9DN2Y
         x0inIDAHzPPeTlYVEXIEWQGzP/bHJTneEZVEmBVEUK5hHnbLVYto4iruPS2imQQsmB
         8syHcrp+pPIqpoBlj8e3yTh8UJHT6brEstmkjhLiymCAlWJmHwqh/nNqXiBKRbDWJL
         LKllsUAjVbiqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 6/6] NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data
Date:   Sun,  9 Oct 2022 16:54:55 -0400
Message-Id: <20221009205456.1203807-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205456.1203807-1-sashal@kernel.org>
References: <20221009205456.1203807-1-sashal@kernel.org>
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
index 2e7349b2dd4d..c5c10b7dc63e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3550,7 +3550,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	if (resp->xdr.buf->page_len &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
 		WARN_ON_ONCE(1);
-		return nfserr_resource;
+		return nfserr_serverfault;
 	}
 	xdr_commit_encode(xdr);
 
-- 
2.35.1

