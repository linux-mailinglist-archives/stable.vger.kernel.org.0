Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BA46DEFAA
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjDLIww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbjDLIwr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5F5A273
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2635631A6
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0199CC433D2;
        Wed, 12 Apr 2023 08:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289538;
        bh=yfHVAB1ta4cuVF/XZNxPndZG2NyQxCWtZKA2fJQmlaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P+IHCoRfcFn20eI807p5TovaDxBp/O0TAK3ZUQJbgqt1yCapiXYSJU16CYAJWkFXy
         Kc/lxW1/n8a89jhbcykB0rSA+a/jz1v+gQVED0w/D3dFMohEXF3wm1Ojqa/BGSPCkn
         xA2rTAh7HPT6A5gQoLwZdWaJwj1nmGIKqn0gmKrs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.2 120/173] net: stmmac: Add queue reset into stmmac_xdp_open() function
Date:   Wed, 12 Apr 2023 10:34:06 +0200
Message-Id: <20230412082842.953599879@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Yoong Siang <yoong.siang.song@intel.com>

commit 24e3fce00c0b557491ff596c0682a29dee6fe848 upstream.

Queue reset was moved out from __init_dma_rx_desc_rings() and
__init_dma_tx_desc_rings() functions. Thus, the driver fails to transmit
and receive packet after XDP prog setup.

This commit adds the missing queue reset into stmmac_xdp_open() function.

Fixes: f9ec5723c3db ("net: ethernet: stmicro: stmmac: move queue reset to dedicated functions")
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20230404044823.3226144-1-yoong.siang.song@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6629,6 +6629,8 @@ int stmmac_xdp_open(struct net_device *d
 		goto init_error;
 	}
 
+	stmmac_reset_queues_param(priv);
+
 	/* DMA CSR Channel configuration */
 	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);


