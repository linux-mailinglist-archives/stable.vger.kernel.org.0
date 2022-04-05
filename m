Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A9B4F25EF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbiDEHwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232505AbiDEHvK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:51:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9481B931A4;
        Tue,  5 Apr 2022 00:47:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7138A616BF;
        Tue,  5 Apr 2022 07:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ECEC3410F;
        Tue,  5 Apr 2022 07:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144841;
        bh=Zx4lWtvKcRuOo75kaWAnuXqPkXeLmjn2MI0+fP+jJTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9wF6nvl0QaUnNBOBeNaB4kR4gQ7ZskXi0DXD3l93j3pJFlrVqn/QYVZqPaVdK0Sk
         z9NgIOUcpBVllsjAuG/M/TgN8+LWPfrcymXAwX+csnI/B5Na6TtduXqwRc0zAy3dPj
         GnjEZqrMxuVfby1rHwrGODR4QrEFXvDN6kO/woKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hector Martin <marcan@marcan.st>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.17 0191/1126] brcmfmac: pcie: Fix crashes due to early IRQs
Date:   Tue,  5 Apr 2022 09:15:38 +0200
Message-Id: <20220405070413.212788470@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

commit b50255c83b914defd61a57fbc81d452334b63f4c upstream.

The driver was enabling IRQs before the message processing was
initialized. This could cause IRQs to come in too early and crash the
driver. Instead, move the IRQ enable and hostready to a bus preinit
function, at which point everything is properly initialized.

Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: stable@vger.kernel.org
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220131160713.245637-7-marcan@marcan.st
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1315,6 +1315,18 @@ static void brcmf_pcie_down(struct devic
 {
 }
 
+static int brcmf_pcie_preinit(struct device *dev)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
+	struct brcmf_pciedev *buspub = bus_if->bus_priv.pcie;
+
+	brcmf_dbg(PCIE, "Enter\n");
+
+	brcmf_pcie_intr_enable(buspub->devinfo);
+	brcmf_pcie_hostready(buspub->devinfo);
+
+	return 0;
+}
 
 static int brcmf_pcie_tx(struct device *dev, struct sk_buff *skb)
 {
@@ -1423,6 +1435,7 @@ static int brcmf_pcie_reset(struct devic
 }
 
 static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
+	.preinit = brcmf_pcie_preinit,
 	.txdata = brcmf_pcie_tx,
 	.stop = brcmf_pcie_down,
 	.txctl = brcmf_pcie_tx_ctlpkt,
@@ -1795,9 +1808,6 @@ static void brcmf_pcie_setup(struct devi
 
 	init_waitqueue_head(&devinfo->mbdata_resp_wait);
 
-	brcmf_pcie_intr_enable(devinfo);
-	brcmf_pcie_hostready(devinfo);
-
 	ret = brcmf_attach(&devinfo->pdev->dev);
 	if (ret)
 		goto fail;


