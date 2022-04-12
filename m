Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C195F4FD626
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377449AbiDLHuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359092AbiDLHma (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015905523C;
        Tue, 12 Apr 2022 00:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A546FB81B6A;
        Tue, 12 Apr 2022 07:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CF4C385A5;
        Tue, 12 Apr 2022 07:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748011;
        bh=xUTyRZPsMXwHoFuxnBfly520MoRrE/Fv7qY+hGuZ+EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O14b2SptY1m/3b9c7Xa2L9toUNGW8HUfSyIUsBLCGuUopANFw/UKysrDA6vva6vHM
         TTM2PtM2mi9W6FacUU3TipI3OiGusc8sZ30cM3B36J5c/ABlrIghmIYMGOFkXiU3z3
         y8YhhYVDQTL8tsOTI3pNY1Ygch5pSVB3DEIShWeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.17 288/343] spi: core: add dma_map_dev for __spi_unmap_msg()
Date:   Tue, 12 Apr 2022 08:31:46 +0200
Message-Id: <20220412062959.640623253@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Vinod Koul <vkoul@kernel.org>

commit 409543cec01a84610029d6440c480c3fdd7214fb upstream.

Commit b470e10eb43f ("spi: core: add dma_map_dev for dma device") added
dma_map_dev for _spi_map_msg() but missed to add for unmap routine,
__spi_unmap_msg(), so add it now.

Fixes: b470e10eb43f ("spi: core: add dma_map_dev for dma device")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20220406132238.1029249-1-vkoul@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1149,11 +1149,15 @@ static int __spi_unmap_msg(struct spi_co
 
 	if (ctlr->dma_tx)
 		tx_dev = ctlr->dma_tx->device->dev;
+	else if (ctlr->dma_map_dev)
+		tx_dev = ctlr->dma_map_dev;
 	else
 		tx_dev = ctlr->dev.parent;
 
 	if (ctlr->dma_rx)
 		rx_dev = ctlr->dma_rx->device->dev;
+	else if (ctlr->dma_map_dev)
+		rx_dev = ctlr->dma_map_dev;
 	else
 		rx_dev = ctlr->dev.parent;
 


