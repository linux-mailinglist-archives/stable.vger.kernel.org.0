Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3AC60423B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiJSK5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbiJSK4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:56:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB7B166994;
        Wed, 19 Oct 2022 03:27:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 844B6B82497;
        Wed, 19 Oct 2022 09:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E495BC433D6;
        Wed, 19 Oct 2022 09:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170499;
        bh=HDYsHqlawLyMenwDf+zZ2I9OXsat/1lMky2g1FD+N7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdxQxcm6HuDXEtYVpCYY/L3yZ2qc7jeLBrqvbGGzN6wM2220SlbWLKzj0S21L64mX
         U/YWzD69FFU/IQjc4We4hzwj94PwuIkQZhb88GYiBUJUQoFSELshj/jjMNizxdx9Ay
         aaef2j4gLKVCLfe1kLosbyVO/qXBJopiKGKyLPn0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Koba Ko <koba.ko@canonical.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 636/862] crypto: ccp - Release dma channels before dmaengine unrgister
Date:   Wed, 19 Oct 2022 10:32:03 +0200
Message-Id: <20221019083318.037257498@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koba Ko <koba.ko@canonical.com>

[ Upstream commit 68dbe80f5b510c66c800b9e8055235c5b07e37d1 ]

A warning is shown during shutdown,

__dma_async_device_channel_unregister called while 2 clients hold a reference
WARNING: CPU: 15 PID: 1 at drivers/dma/dmaengine.c:1110 __dma_async_device_channel_unregister+0xb7/0xc0

Call dma_release_channel for occupied channles before dma_async_device_unregister.

Fixes: 54cce8ecb925 ("crypto: ccp - ccp_dmaengine_unregister release dma channels")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Koba Ko <koba.ko@canonical.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-dmaengine.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index 7d4b4ad1db1f..9f753cb4f5f1 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -641,6 +641,10 @@ static void ccp_dma_release(struct ccp_device *ccp)
 	for (i = 0; i < ccp->cmd_q_count; i++) {
 		chan = ccp->ccp_dma_chan + i;
 		dma_chan = &chan->dma_chan;
+
+		if (dma_chan->client_count)
+			dma_release_channel(dma_chan);
+
 		tasklet_kill(&chan->cleanup_tasklet);
 		list_del_rcu(&dma_chan->device_node);
 	}
@@ -766,8 +770,8 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	if (!dmaengine)
 		return;
 
-	dma_async_device_unregister(dma_dev);
 	ccp_dma_release(ccp);
+	dma_async_device_unregister(dma_dev);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
-- 
2.35.1



