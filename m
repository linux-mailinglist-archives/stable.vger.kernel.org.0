Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0840621557
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiKHOKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiKHOKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:10:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB5D77203
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:10:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51A93B81ADD
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B200C433C1;
        Tue,  8 Nov 2022 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916635;
        bh=gKe/AsOUBAgy/7U2puBv1Miz7mLvMNE5qLNpWRM0Kdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlubq4QTmp+zS4MTKuC0v+sZQ8QofqVgTi52uyzy7y6ym7vhrEKrnoOyFb4RBtT+D
         9D9kD5wcdNqhLATrUvCd8DjqkhiRtyvGr3pe6Hs3YgLZ83HqKh5TSb5kTL/uFuooCu
         JmhqrWW7SkRXgGa3U947gI6IKz5HBwMoGxX/U98M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Peibao <liupeibao@loongson.cn>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 057/197] stmmac: dwmac-loongson: fix invalid mdio_node
Date:   Tue,  8 Nov 2022 14:38:15 +0100
Message-Id: <20221108133357.415136507@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Peibao <liupeibao@loongson.cn>

[ Upstream commit 2ae34111fe4eebb69986f6490015b57c88804373 ]

In current code "plat->mdio_node" is always NULL, the mdio
support is lost as there is no "mdio_bus_data". The original
driver could work as the "mdio" variable is never set to
false, which is described in commit <b0e03950dd71> ("stmmac:
dwmac-loongson: fix uninitialized variable ......"). And
after this commit merged, the "mdio" variable is always
false, causing the mdio supoort logic lost.

Fixes: 30bba69d7db4 ("stmmac: pci: Add dwmac support for Loongson")
Signed-off-by: Liu Peibao <liupeibao@loongson.cn>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20221101060218.16453-1-liupeibao@loongson.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
index 017dbbda0c1c..79fa7870563b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
@@ -51,7 +51,6 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	struct stmmac_resources res;
 	struct device_node *np;
 	int ret, i, phy_mode;
-	bool mdio = false;
 
 	np = dev_of_node(&pdev->dev);
 
@@ -69,12 +68,10 @@ static int loongson_dwmac_probe(struct pci_dev *pdev, const struct pci_device_id
 	if (!plat)
 		return -ENOMEM;
 
+	plat->mdio_node = of_get_child_by_name(np, "mdio");
 	if (plat->mdio_node) {
-		dev_err(&pdev->dev, "Found MDIO subnode\n");
-		mdio = true;
-	}
+		dev_info(&pdev->dev, "Found MDIO subnode\n");
 
-	if (mdio) {
 		plat->mdio_bus_data = devm_kzalloc(&pdev->dev,
 						   sizeof(*plat->mdio_bus_data),
 						   GFP_KERNEL);
-- 
2.35.1



