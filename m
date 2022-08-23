Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A09E59D976
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348206AbiHWJMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348451AbiHWJKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:10:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE92027CD3;
        Tue, 23 Aug 2022 01:30:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F4DB81C59;
        Tue, 23 Aug 2022 08:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D17C433D7;
        Tue, 23 Aug 2022 08:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243407;
        bh=Ivg1RtIfWpntWqpOEmsfcxyH9dZBFGT8p91JPEwm8JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJFrLPCEN4RTCkHHHHEAIn2vBino/fV9pjD+aGM3go1zjZx8hM5WKO9jn+/PsFUhc
         0X1SSU/EncmTgXuiMyZKS0leQmJqvO4kqzMAM2HwA7fbpcSSHHMfo6xImjq3vfxpX6
         4jHpLy3XcuBd6QamJAO1KDuz0pdMcIskbrsRC+70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 237/365] stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()
Date:   Tue, 23 Aug 2022 10:02:18 +0200
Message-Id: <20220823080128.152003986@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 5c23d6b717e4e956376f3852b90f58e262946b50 upstream.

Commit 09f012e64e4b ("stmmac: intel: Fix clock handling on error and remove
paths") removed this clk_disable_unprepare()

This was partly revert by commit ac322f86b56c ("net: stmmac: Fix clock
handling on remove path") which removed this clk_disable_unprepare()
because:
"
   While unloading the dwmac-intel driver, clk_disable_unprepare() is
   being called twice in stmmac_dvr_remove() and
   intel_eth_pci_remove(). This causes kernel panic on the second call.
"

However later on, commit 5ec55823438e8 ("net: stmmac: add clocks management
for gmac driver") has updated stmmac_dvr_remove() which do not call
clk_disable_unprepare() anymore.

So this call should now be called from intel_eth_pci_remove().

Fixes: 5ec55823438e8 ("net: stmmac: add clocks management for gmac driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/d7c8c1dadf40df3a7c9e643f76ffadd0ccc1ad1b.1660659689.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1104,6 +1104,7 @@ static void intel_eth_pci_remove(struct
 
 	stmmac_dvr_remove(&pdev->dev);
 
+	clk_disable_unprepare(priv->plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));


