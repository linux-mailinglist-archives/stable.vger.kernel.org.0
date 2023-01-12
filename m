Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21CA667531
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbjALOTY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbjALOSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:18:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15D658813
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FFCF62026
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52299C433D2;
        Thu, 12 Jan 2023 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532613;
        bh=TjTx/Aw6QLentYJOM35GIxSm5jJH7XCLPS+eNsKlrgA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzdnEV86OmR+c1GfaBn7lTA6z5szdXZc6qqXWC35Tmyrfoa+RpnpoDIPlOsnkxcav
         Ryxfejdi5JfT0bg6Qfeo+GYDFe7NPIC5YSj9cZJosULaY/4rZP3WWwIZbvc4jtX56c
         YVS9U4zAC0mFmFtkqTlYzVbHXauAAzjzwTAJVR5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 220/783] xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()
Date:   Thu, 12 Jan 2023 14:48:56 +0100
Message-Id: <20230112135534.553761825@linuxfoundation.org>
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

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 9181f40fb2952fd59ecb75e7158620c9c669eee3 ]

If rdma receive buffer allocate failed, should call rpcrdma_regbuf_free()
to free the send buffer, otherwise, the buffer data will be leaked.

Fixes: bb93a1ae2bf4 ("xprtrdma: Allocate req's regbufs at xprt create time")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index dcc1992b14d7..338b06de86d1 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -866,7 +866,7 @@ struct rpcrdma_req *rpcrdma_req_create(struct rpcrdma_xprt *r_xprt, size_t size,
 	return req;
 
 out3:
-	kfree(req->rl_sendbuf);
+	rpcrdma_regbuf_free(req->rl_sendbuf);
 out2:
 	kfree(req);
 out1:
-- 
2.35.1



