Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA36260B01F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbiJXQBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiJXP7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:59:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E48148EAA;
        Mon, 24 Oct 2022 07:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25EE4B816AA;
        Mon, 24 Oct 2022 12:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77869C43470;
        Mon, 24 Oct 2022 12:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615866;
        bh=XpmReVoMW7d5ihKGQ00mFEMpfXqjUUDVz75T9D0teT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xZqjA1ZIOzI+sQmOg25Mb3udrBT32SavdN/gktWM12TT3g5qt9d0Xc+KTpxGTHPKH
         +am+ZV6yIlOHiiIoBhnv8er9m7FnCrvNk9Hi15BT56jiYQoV+6UD/+Cb1/wPa8qb1t
         zy5Elc65OnYYuHZ04hi/tXQfQYuRas4BxJ0Ht1Bk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 413/530] NFSD: Return nfserr_serverfault if splice_ok but buf->pages have data
Date:   Mon, 24 Oct 2022 13:32:37 +0200
Message-Id: <20221024113103.791066596@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3988,7 +3988,7 @@ nfsd4_encode_read(struct nfsd4_compoundr
 	if (resp->xdr->buf->page_len &&
 	    test_bit(RQ_SPLICE_OK, &resp->rqstp->rq_flags)) {
 		WARN_ON_ONCE(1);
-		return nfserr_resource;
+		return nfserr_serverfault;
 	}
 	xdr_commit_encode(xdr);
 


