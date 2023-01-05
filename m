Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBBA65EB9B
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbjAENAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbjAENAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:00:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB8250E5D
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:00:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B8E3B81A84
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F43C433F0;
        Thu,  5 Jan 2023 13:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923630;
        bh=xCu08noo0OME+DC4M8plLe/vMlzqqIKyIMHAJ9gTezY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x+T8XZ5upY5PuNEQBBnoruKfMGargL8JwRFr5UJpz9BZ/6o02bu/hLrDXenPq5V9e
         Mc0AjGoyJnetnFT9pSRacp9GM+UZM2kDWAGnm5QO2yf9cmFyjpETwP/nADgTHhHDc3
         k1+VbL6WKRu3to4fcundEdD8wlp28AFrgkIfcLzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 081/251] SUNRPC: Fix missing release socket in rpc_sockname()
Date:   Thu,  5 Jan 2023 13:53:38 +0100
Message-Id: <20230105125338.499465882@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
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

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 50fa355bc0d75911fe9d5072a5ba52cdb803aff7 ]

socket dynamically created is not released when getting an unintended
address family type in rpc_sockname(), direct to out_release for calling
sock_release().

Fixes: 2e738fdce22f ("SUNRPC: Add API to acquire source address")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index eef2f732fbe3..9447670b5a63 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1275,7 +1275,7 @@ static int rpc_sockname(struct net *net, struct sockaddr *sap, size_t salen,
 		break;
 	default:
 		err = -EAFNOSUPPORT;
-		goto out;
+		goto out_release;
 	}
 	if (err < 0) {
 		dprintk("RPC:       can't bind UDP socket (%d)\n", err);
-- 
2.35.1



