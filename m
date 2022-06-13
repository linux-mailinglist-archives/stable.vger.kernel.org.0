Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9691548FAC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378926AbiFMNnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378217AbiFMNmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:42:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F8B2A72F;
        Mon, 13 Jun 2022 04:31:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A39361037;
        Mon, 13 Jun 2022 11:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A56BC34114;
        Mon, 13 Jun 2022 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119886;
        bh=5UwgwA5uk3m1yjQ3cSjIclyEbz390K7LIh5k5M5FNEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lEY+l748/kNDAMEzKGnWYVP/b8eSv+u8WOUKxXZBKOHcV8YfhB73XjmUPA5ytQGUe
         8cA4thF4FqblVjImiduVW6T/UpAK/8tUEveKb+IOBohkVTaZd2djvWcajIy/BE5aGJ
         MPIRhhxauAptMS+MP7LKuQCenDAZo1hkWWqFuk/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Walker <benjamin.walker@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 154/339] dmaengine: idxd: set DMA_INTERRUPT cap bit
Date:   Mon, 13 Jun 2022 12:09:39 +0200
Message-Id: <20220613094931.354949193@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 4e5a4eb20393b851590b4465f1197a8041c2076b ]

Even though idxd driver has always supported interrupt, it never actually
set the DMA_INTERRUPT cap bit. Rectify this mistake so the interrupt
capability is advertised.

Reported-by: Ben Walker <benjamin.walker@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/164971497859.2201379.17925303210723708961.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index bfff59617d04..13e061944db9 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -193,6 +193,7 @@ int idxd_register_dma_device(struct idxd_device *idxd)
 	INIT_LIST_HEAD(&dma->channels);
 	dma->dev = dev;
 
+	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
 	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
 	dma_cap_set(DMA_COMPLETION_NO_ORDER, dma->cap_mask);
 	dma->device_release = idxd_dma_release;
-- 
2.35.1



