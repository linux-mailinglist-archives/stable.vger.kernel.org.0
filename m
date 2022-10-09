Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9295F8E8E
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiJIU7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbiJIU6p (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:58:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A6B19C37;
        Sun,  9 Oct 2022 13:54:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E46FB60CA4;
        Sun,  9 Oct 2022 20:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBD9C433D6;
        Sun,  9 Oct 2022 20:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348860;
        bh=KwiBHAeC4ATIsxRiekASCeySPN3bCa3arjbO0thAJmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UXfxdHC7WGnQN7yP9KZ8bE0pFz9rTu1ySBqEvF24bKDxVNtRoPx1Q02pHqvgXgpS8
         E2MLq/XigWjDT6lh0p6E8wjhBypxVaBXoDhap70r1aKH9zmXOz9FTKoho8OLrd94hT
         1NjQvFGotiCezecnIUaDlp5tKnYY9yNBVLHwE4cQ+SLg1vYIfirgh7+9FuQ3C+1QJ9
         gnhhXebwy9a1xmo+z9zmSGElCeqecHB5ovhGGE48kJujkEZJQ33pNmogYa/l2RA6Q7
         MWdwOI7psqtJxn0OpIDSw54byfTBZ++5LuUaYoEF6p2LfIhrjXL5eq1fqG7pk94M9y
         dyIfrk41Kbk7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jlayton@kernel.org,
        linux-nfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 09/10] NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data
Date:   Sun,  9 Oct 2022 16:53:48 -0400
Message-Id: <20221009205350.1203176-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205350.1203176-1-sashal@kernel.org>
References: <20221009205350.1203176-1-sashal@kernel.org>
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
index 46f825cf53f4..cc605ee0b2fa 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3871,7 +3871,7 @@ nfsd4_encode_read(struct nfsd4_compoundres *resp, __be32 nfserr,
 	if (resp->xdr.buf->page_len &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
 		WARN_ON_ONCE(1);
-		return nfserr_resource;
+		return nfserr_serverfault;
 	}
 	xdr_commit_encode(xdr);
 
-- 
2.35.1

