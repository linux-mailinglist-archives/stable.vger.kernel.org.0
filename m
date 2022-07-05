Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54545566DC3
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbiGEM07 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbiGEMZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:25:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967A51902B;
        Tue,  5 Jul 2022 05:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 331F561AC4;
        Tue,  5 Jul 2022 12:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAA0C341C7;
        Tue,  5 Jul 2022 12:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023466;
        bh=S/jElzlayL1J+y5ZjSboB6qcAO1oqCfb2sqhoDqm/rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wj8sGVZv7Ur14bLeJFdsuN2wArK9Xmyt7B1lNjLHsofAGAv9OPqx1QbqB22Nmr/0u
         mq0Pea0DRlVkN+KgZ2BEbc8VOWVRIMtFavXxp7tuGK/cjJQjSd5naJGaYIkIZCTgHq
         5qJaI5RjFQQIe68lyS7jueWMC8pnmjz1m3t8wrG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yilun Wu <yiluwu@cs.stonybrook.edu>,
        Tong Zhang <ztong0001@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 069/102] epic100: fix use after free on rmmod
Date:   Tue,  5 Jul 2022 13:58:35 +0200
Message-Id: <20220705115620.364534662@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

commit 8ee9d82cd0a45e7d050ade598c9f33032a0f2891 upstream.

epic_close() calls epic_rx() and uses dma buffer, but in epic_remove_one()
we already freed the dma buffer. To fix this issue, reorder function calls
like in the .probe function.

BUG: KASAN: use-after-free in epic_rx+0xa6/0x7e0 [epic100]
Call Trace:
 epic_rx+0xa6/0x7e0 [epic100]
 epic_close+0xec/0x2f0 [epic100]
 unregister_netdev+0x18/0x20
 epic_remove_one+0xaa/0xf0 [epic100]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yilun Wu <yiluwu@cs.stonybrook.edu>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Reviewed-by: Francois Romieu <romieu@fr.zoreil.com>
Link: https://lore.kernel.org/r/20220627043351.25615-1-ztong0001@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/smsc/epic100.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -1515,14 +1515,14 @@ static void epic_remove_one(struct pci_d
 	struct net_device *dev = pci_get_drvdata(pdev);
 	struct epic_private *ep = netdev_priv(dev);
 
+	unregister_netdev(dev);
 	dma_free_coherent(&pdev->dev, TX_TOTAL_SIZE, ep->tx_ring,
 			  ep->tx_ring_dma);
 	dma_free_coherent(&pdev->dev, RX_TOTAL_SIZE, ep->rx_ring,
 			  ep->rx_ring_dma);
-	unregister_netdev(dev);
 	pci_iounmap(pdev, ep->ioaddr);
-	pci_release_regions(pdev);
 	free_netdev(dev);
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	/* pci_power_off(pdev, -1); */
 }


