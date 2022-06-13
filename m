Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4223B54885C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384793AbiFMOek (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385459AbiFMObN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:31:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8D6ABE42;
        Mon, 13 Jun 2022 04:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14B19B80EE2;
        Mon, 13 Jun 2022 11:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667D2C34114;
        Mon, 13 Jun 2022 11:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120891;
        bh=di+rlPStseU+iqxIuStF2OeBZTDVaIS8ROUsB/WG8bY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vsX8UthsGuT0jL/6gTTld2pnRc0jYzB+/xS8EiInsznZ6jFnO1qv+mDeM9H7OhK3+
         UMrz8hngzXAG5r0gqBphAF1rDiGqavK48KS3kFaX0gvXdSjZNqKvMBHDLrs4IRcEF7
         zxkReOs11RZ20GhXJGvDFBt4C6+9rFi/vGSOyQ8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 173/298] stmmac: intel: Fix an error handling path in intel_eth_pci_probe()
Date:   Mon, 13 Jun 2022 12:11:07 +0200
Message-Id: <20220613094930.180659430@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 5e74a4b3ec1816e3bbfd715d46ae29d2508079cb ]

When the managed API is used, there is no need to explicitly call
pci_free_irq_vectors().

This looks to be a left-over from the commit in the Fixes tag. Only the
.remove() function had been updated.

So remove this unused function call and update goto label accordingly.

Fixes: 8accc467758e ("stmmac: intel: use managed PCI function on probe and resume")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Link: https://lore.kernel.org/r/1ac9b6787b0db83b0095711882c55c77c8ea8da0.1654462241.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 6f87e296a410..502fbbc082fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1073,13 +1073,11 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
 	if (ret) {
-		goto err_dvr_probe;
+		goto err_alloc_irq;
 	}
 
 	return 0;
 
-err_dvr_probe:
-	pci_free_irq_vectors(pdev);
 err_alloc_irq:
 	clk_disable_unprepare(plat->stmmac_clk);
 	clk_unregister_fixed_rate(plat->stmmac_clk);
-- 
2.35.1



