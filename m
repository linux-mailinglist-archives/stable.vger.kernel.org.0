Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 246766579E1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbiL1PFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiL1PFp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:05:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A89B69
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00CFBB816D6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FABDC433D2;
        Wed, 28 Dec 2022 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239941;
        bh=AURp8llk8cjLk2SquN5QyRHwglvat3pCE3+uszkf+Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI5Q478ng97MwUFrMTFRiA0OmssDlfvl+1KtHucALLG4ITPqs6QCpk/zGKl5JRhon
         kgI5WgrZLhugLXi9Px7nruQtNhH7ZpNSWyWl9ImWbh2CLPhZoQUxyvDAmjCqfjqFly
         NMDDb4bjVo3p/3uJBTY3CcPa0ns2GnGsF0Lhdnzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/731] SUNRPC: Fix missing release socket in rpc_sockname()
Date:   Wed, 28 Dec 2022 15:36:35 +0100
Message-Id: <20221228144304.917637802@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index ca2a494d727b..bbeb80e1133d 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1375,7 +1375,7 @@ static int rpc_sockname(struct net *net, struct sockaddr *sap, size_t salen,
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



