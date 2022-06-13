Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6330854940C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383747AbiFMO1p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383845AbiFMOYJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2894705B;
        Mon, 13 Jun 2022 04:45:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86A2AB80EA7;
        Mon, 13 Jun 2022 11:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B1CC34114;
        Mon, 13 Jun 2022 11:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120728;
        bh=5UwgwA5uk3m1yjQ3cSjIclyEbz390K7LIh5k5M5FNEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2rsaoQh+/nBWTTKvRcz6AO+vRGxjYTJyajxfHm31Sa4S0pHuv4/6CCNir8cxrqK2
         lzeMnq7FGpQOIdzGvfn3wlMxBzW0Yso0bq8lMDCnWPcfz2QwIx4h0LOEvagW+WL/Gm
         PgmliJ69gV3iYiADYddYLzg50SO5tWZ/dmkvByxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Walker <benjamin.walker@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 135/298] dmaengine: idxd: set DMA_INTERRUPT cap bit
Date:   Mon, 13 Jun 2022 12:10:29 +0200
Message-Id: <20220613094929.038299754@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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



