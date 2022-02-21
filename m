Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1798A4BE424
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbiBUJ7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:59:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353725AbiBUJ5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F0D245A0;
        Mon, 21 Feb 2022 01:27:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CC88B80EDF;
        Mon, 21 Feb 2022 09:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8BBC33A37;
        Mon, 21 Feb 2022 09:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435625;
        bh=hHohSxgqCDRAYo2TzGlcEJxO0dJ5McJl7zKU55IAVrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dv0Y7sRbvF58dbo9491bPkaHcy6Q1hZy//JYrzEWtJ4a+YHpkpsVsjAI0IRpZzdt7
         9tX/JwMps+zzHgRVXvoII/tERT4rxuWzKxX23vwYHArDJpTKi0dWkEh2yXEX3+/dLP
         28mDuW/QTaeLBkEDmyXvh6pu1AGuCM71TdYkYdLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Aloni <dan.aloni@vastdata.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 218/227] xprtrdma: fix pointer derefs in error cases of rpcrdma_ep_create
Date:   Mon, 21 Feb 2022 09:50:37 +0100
Message-Id: <20220221084942.055792377@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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
index 3d3673ba9e1e5..2a2e1514ac79a 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -436,6 +436,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 					      IB_POLL_WORKQUEUE);
 	if (IS_ERR(ep->re_attr.send_cq)) {
 		rc = PTR_ERR(ep->re_attr.send_cq);
+		ep->re_attr.send_cq = NULL;
 		goto out_destroy;
 	}
 
@@ -444,6 +445,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 					      IB_POLL_WORKQUEUE);
 	if (IS_ERR(ep->re_attr.recv_cq)) {
 		rc = PTR_ERR(ep->re_attr.recv_cq);
+		ep->re_attr.recv_cq = NULL;
 		goto out_destroy;
 	}
 	ep->re_receive_count = 0;
@@ -482,6 +484,7 @@ static int rpcrdma_ep_create(struct rpcrdma_xprt *r_xprt)
 	ep->re_pd = ib_alloc_pd(device, 0);
 	if (IS_ERR(ep->re_pd)) {
 		rc = PTR_ERR(ep->re_pd);
+		ep->re_pd = NULL;
 		goto out_destroy;
 	}
 
-- 
2.34.1



