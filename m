Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAEC6C18F9
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjCTP3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjCTP2m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:28:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7E832E46
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:21:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC261615B5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7267C433D2;
        Mon, 20 Mar 2023 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325715;
        bh=gVDUWofQpGjrvDcWpgA6d4EKOgvTcNdL4WkyriL8SBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUyzZGKV9Zviihk80sBD9/0k/IQok4pEEiZtiMWtnWm+6KJi7UUoimT8eXAKGMhUn
         2qd8Tuxckwzl23WHy0sWgBqEr8jrysfTaMIZObABf05Txl7G+LXenb2s0uk7JHTm8v
         emjqJkk9Kwsza7RjGVevwfKRdvWSk59O8H5ZE6do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 089/211] i825xx: sni_82596: use eth_hw_addr_set()
Date:   Mon, 20 Mar 2023 15:53:44 +0100
Message-Id: <20230320145517.035138995@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

[ Upstream commit f38373345c65529639a01fba3675eb8cb4c579c3 ]

netdev->dev_addr is now const, we can't write to it directly.
Copy scrambled mac address octects into an array then eth_hw_addr_set().

Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://lore.kernel.org/r/20230315134117.79511-1-tsbogend@alpha.franken.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/i825xx/sni_82596.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/i825xx/sni_82596.c b/drivers/net/ethernet/i825xx/sni_82596.c
index daec9ce04531b..54bb4d9a0d1ea 100644
--- a/drivers/net/ethernet/i825xx/sni_82596.c
+++ b/drivers/net/ethernet/i825xx/sni_82596.c
@@ -78,6 +78,7 @@ static int sni_82596_probe(struct platform_device *dev)
 	void __iomem *mpu_addr;
 	void __iomem *ca_addr;
 	u8 __iomem *eth_addr;
+	u8 mac[ETH_ALEN];
 
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	ca = platform_get_resource(dev, IORESOURCE_MEM, 1);
@@ -109,12 +110,13 @@ static int sni_82596_probe(struct platform_device *dev)
 		goto probe_failed;
 
 	/* someone seems to like messed up stuff */
-	netdevice->dev_addr[0] = readb(eth_addr + 0x0b);
-	netdevice->dev_addr[1] = readb(eth_addr + 0x0a);
-	netdevice->dev_addr[2] = readb(eth_addr + 0x09);
-	netdevice->dev_addr[3] = readb(eth_addr + 0x08);
-	netdevice->dev_addr[4] = readb(eth_addr + 0x07);
-	netdevice->dev_addr[5] = readb(eth_addr + 0x06);
+	mac[0] = readb(eth_addr + 0x0b);
+	mac[1] = readb(eth_addr + 0x0a);
+	mac[2] = readb(eth_addr + 0x09);
+	mac[3] = readb(eth_addr + 0x08);
+	mac[4] = readb(eth_addr + 0x07);
+	mac[5] = readb(eth_addr + 0x06);
+	eth_hw_addr_set(netdevice, mac);
 	iounmap(eth_addr);
 
 	if (netdevice->irq < 0) {
-- 
2.39.2



