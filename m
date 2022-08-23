Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40C059E344
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353352AbiHWMSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359543AbiHWMPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:15:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E35F7A759;
        Tue, 23 Aug 2022 02:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDD836148E;
        Tue, 23 Aug 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE27C433C1;
        Tue, 23 Aug 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247616;
        bh=RlS+b8Vyy/m/NXrnEpfLUDK64uMIFP9NpLwnxs/c8NM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KMhFxp6K6VJ6XMCCOQER2GEhS9AjVF22Nt4HnIkDDyqNrRcGG3+AubI1sgx/vmxN5
         Q20afCXFNkgsxrviXcqGM5swguqi7df1LbWdIK3914kHfZX89gPBE/0EDA29HuVlgx
         J74hwZFwg9+d4NFNjS9ZLX2USM0yOuSe7opRbe0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 091/158] stmmac: intel: Add a missing clk_disable_unprepare() call in intel_eth_pci_remove()
Date:   Tue, 23 Aug 2022 10:27:03 +0200
Message-Id: <20220823080049.712401502@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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
@@ -669,6 +669,7 @@ static void intel_eth_pci_remove(struct
 
 	pci_free_irq_vectors(pdev);
 
+	clk_disable_unprepare(priv->plat->stmmac_clk);
 	clk_unregister_fixed_rate(priv->plat->stmmac_clk);
 
 	pcim_iounmap_regions(pdev, BIT(0));


