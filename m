Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7D85656E1
	for <lists+stable@lfdr.de>; Mon,  4 Jul 2022 15:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiGDNTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jul 2022 09:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGDNTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jul 2022 09:19:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2AEB42
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 06:19:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B38AB80EEC
        for <stable@vger.kernel.org>; Mon,  4 Jul 2022 13:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B2DC3411E;
        Mon,  4 Jul 2022 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656940786;
        bh=QzSApdUBQByHYwAD1g/oQ74kaY5RtHVp6Dla6o+Z1BE=;
        h=Subject:To:Cc:From:Date:From;
        b=MqNS01TXyAF2/OPHIlz8JVGK1JbGvwjI8pEFrKa0hAmQYP6ASZH3wD1zYgRHzJIxJ
         GHlReWE5ZNQL6zg8Pijtd93YhFo85eG3grz9Hixu8eUtqMsbDKOB55bRnScKSSvWtH
         MiX2dkfc6xyk/Z/U72GSP0XBkK/ud8ye55B5YIG0=
Subject: FAILED: patch "[PATCH] epic100: fix use after free on rmmod" failed to apply to 4.19-stable tree
To:     ztong0001@gmail.com, kuba@kernel.org, romieu@fr.zoreil.com,
        yiluwu@cs.stonybrook.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 04 Jul 2022 15:19:35 +0200
Message-ID: <165694077521720@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8ee9d82cd0a45e7d050ade598c9f33032a0f2891 Mon Sep 17 00:00:00 2001
From: Tong Zhang <ztong0001@gmail.com>
Date: Sun, 26 Jun 2022 21:33:48 -0700
Subject: [PATCH] epic100: fix use after free on rmmod

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

diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index a0654e88444c..0329caf63279 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -1515,14 +1515,14 @@ static void epic_remove_one(struct pci_dev *pdev)
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

