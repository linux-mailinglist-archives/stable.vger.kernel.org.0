Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E79667533
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235687AbjALOTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbjALOSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:18:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9D65D8A2
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:10:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E090FB81E6C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A82BC433D2;
        Thu, 12 Jan 2023 14:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532619;
        bh=KMHOMXOBIGBLUfThaRP2aQ7LUPmY+bXru+OjApyD2eo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J7Kat2QX1lzamdwch0TJp3ARw1GRmjaNDhjDE9S9BQBZnk0aQlTwCr23DSwxJ1oJ4
         JacLACs5HBLYdrchxMrvyMal6CacqiGPny4ziCM9ixd3CP8FBaEEYxZdB2EUoYiyTD
         T0smGJEHZKPb6XZ8JF19fezIuUCNecHb1ve/ue5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang ShaoBo <bobo.shaobowang@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/783] SUNRPC: Fix missing release socket in rpc_sockname()
Date:   Thu, 12 Jan 2023 14:48:57 +0100
Message-Id: <20230112135534.606420438@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 78c6648af782..c478108ca6a6 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1361,7 +1361,7 @@ static int rpc_sockname(struct net *net, struct sockaddr *sap, size_t salen,
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



