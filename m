Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE085500F10
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 15:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244092AbiDNNXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244212AbiDNNWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:22:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F279968C;
        Thu, 14 Apr 2022 06:18:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2382FB8296D;
        Thu, 14 Apr 2022 13:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81061C385A1;
        Thu, 14 Apr 2022 13:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942283;
        bh=EnoRi90t2aXVSaNfGJ3GBgBtQ7W53wdXYf2h8PwtT8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uU2ma198w2r2Bx7mgPhy5wY861sQ1Jay2UpoD47uMezaTk8NbWblrNcc6Xh2upAa6
         hz7AZuls8kZ4+2CeFz6okH4uI//lVqzhhehYcWo1meQ4YD/ZdwJ7SHq81Y/yIQSHZs
         wITzp26J4HeCkkJRx/3HQDTIXDTCI8Ck546zgcRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?D=C4=81vis=20Mos=C4=81ns?= <davispuh@gmail.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 081/338] crypto: ccp - ccp_dmaengine_unregister release dma channels
Date:   Thu, 14 Apr 2022 15:09:44 +0200
Message-Id: <20220414110841.205744426@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index a83588d6ba72..8209273eb85b 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -631,6 +631,20 @@ static int ccp_terminate_all(struct dma_chan *dma_chan)
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
@@ -732,6 +746,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
 	return 0;
 
 err_reg:
+	ccp_dma_release(ccp);
 	kmem_cache_destroy(ccp->dma_desc_cache);
 
 err_cache:
@@ -745,6 +760,7 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	struct dma_device *dma_dev = &ccp->dma_dev;
 
 	dma_async_device_unregister(dma_dev);
+	ccp_dma_release(ccp);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
-- 
2.34.1



