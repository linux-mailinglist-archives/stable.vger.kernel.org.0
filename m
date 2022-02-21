Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C784BDB6E
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232924AbiBUJOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:14:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349922AbiBUJND (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:13:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6B82DA99;
        Mon, 21 Feb 2022 01:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 398B5CE0E86;
        Mon, 21 Feb 2022 09:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B070C340E9;
        Mon, 21 Feb 2022 09:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434366;
        bh=vbbTpbP9u2rFn29GMsI3A4vpEDTwyx0tyee7vlCQGaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uewza1N1Nq7LCiDH8k8PlCMJg9Sjry2z7rS0bddPtGpIw97h38JOAOdr6MBC+UFuc
         gYEVvrOXyb+R/UP4rVgvwoY8ZEN0MgRsRE8Zbu14pnmaJCC7/6Wr8FqU7aXeubb2+A
         N9MibrWA7LlJ24/DKmhV/qZ/X+a22xTJ4UJyS/JM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan.aloni@vastdata.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/121] xprtrdma: fix pointer derefs in error cases of rpcrdma_ep_create
Date:   Mon, 21 Feb 2022 09:49:57 +0100
Message-Id: <20220221084924.738812675@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Aloni <dan.aloni@vastdata.com>

[ Upstream commit a9c10b5b3b67b3750a10c8b089b2e05f5e176e33 ]

If there are failures then we must not leave the non-NULL pointers with
the error value, otherwise `rpcrdma_ep_destroy` gets confused and tries
free them, resulting in an Oops.

Signed-off-by: Dan Aloni <dan.aloni@vastdata.com>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 25554260a5931..dcc1992b14d76 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -449,6 +449,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 					      IB_POLL_WORKQUEUE);
 	if (IS_ERR(ep->re_attr.send_cq)) {
 		rc = PTR_ERR(ep->re_attr.send_cq);
+		ep->re_attr.send_cq = NULL;
 		goto out_destroy;
 	}
 
@@ -457,6 +458,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 					      IB_POLL_WORKQUEUE);
 	if (IS_ERR(ep->re_attr.recv_cq)) {
 		rc = PTR_ERR(ep->re_attr.recv_cq);
+		ep->re_attr.recv_cq = NULL;
 		goto out_destroy;
 	}
 	ep->re_receive_count = 0;
@@ -495,6 +497,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 	ep->re_pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(ep->re_pd)) {
 		rc = PTR_ERR(ep->re_pd);
+		ep->re_pd = NULL;
 		goto out_destroy;
 	}
 
-- 
2.34.1



