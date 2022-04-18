Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914F35057BB
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244069AbiDRN4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244276AbiDRNyk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C1E49909;
        Mon, 18 Apr 2022 06:04:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF57F60B6E;
        Mon, 18 Apr 2022 13:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BF9C385A1;
        Mon, 18 Apr 2022 13:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650287070;
        bh=dg3+yoGPi8qGBLxN0RWRW4Fy4x8tFrAICEJV8MCbabA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=if7X9XdvETTzW7vWDo/PV0xKiXdiEm4yNGRnuC3OIzega0BsPm4UdWfMrM+CCTSiy
         G0EICCDC6kjUYBI3u+5UTFvgjOiuB5+G0Q0yKPkHFM1hFDPWoHtVrVdIqblB3LifMV
         O3ukM8+TRLJQlr+hScfjK4KyTiW9lh2lXlF80Djo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?D=C4=81vis=20Mos=C4=81ns?= <davispuh@gmail.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 049/218] crypto: ccp - ccp_dmaengine_unregister release dma channels
Date:   Mon, 18 Apr 2022 14:11:55 +0200
Message-Id: <20220418121201.014736647@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dāvis Mosāns <davispuh@gmail.com>

[ Upstream commit 54cce8ecb9254f971b40a72911c6da403720a2d2 ]

ccp_dmaengine_register adds dma_chan->device_node to dma_dev->channels list
but ccp_dmaengine_unregister didn't remove them.
That can cause crashes in various dmaengine methods that tries to use dma_dev->channels

Fixes: 58ea8abf4904 ("crypto: ccp - Register the CCP as a DMA...")
Signed-off-by: Dāvis Mosāns <davispuh@gmail.com>
Acked-by: John Allen <john.allen@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-dmaengine.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index c4581510c3a1..6f9e228fc8ad 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -621,6 +621,20 @@ static int ccp_terminate_all(struct dma_chan *dma_chan)
 	return 0;
 }
 
+static void ccp_dma_release(struct ccp_device *ccp)
+{
+	struct ccp_dma_chan *chan;
+	struct dma_chan *dma_chan;
+	unsigned int i;
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		chan = ccp->ccp_dma_chan + i;
+		dma_chan = &chan->dma_chan;
+		tasklet_kill(&chan->cleanup_tasklet);
+		list_del_rcu(&dma_chan->device_node);
+	}
+}
+
 int ccp_dmaengine_register(struct ccp_device *ccp)
 {
 	struct ccp_dma_chan *chan;
@@ -715,6 +729,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
 	return 0;
 
 err_reg:
+	ccp_dma_release(ccp);
 	kmem_cache_destroy(ccp->dma_desc_cache);
 
 err_cache:
@@ -728,6 +743,7 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	struct dma_device *dma_dev = &ccp->dma_dev;
 
 	dma_async_device_unregister(dma_dev);
+	ccp_dma_release(ccp);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
-- 
2.34.1



