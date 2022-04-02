Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26224F01D4
	for <lists+stable@lfdr.de>; Sat,  2 Apr 2022 14:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354844AbiDBNBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Apr 2022 09:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354841AbiDBNBL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Apr 2022 09:01:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C571D13F1E
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 05:59:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DAF3B80882
        for <stable@vger.kernel.org>; Sat,  2 Apr 2022 12:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3EBC340EC;
        Sat,  2 Apr 2022 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648904357;
        bh=Lw1ADKMKafq++3NcwB1/+4D+wmXfyt+HeOIUv24NhJU=;
        h=Subject:To:Cc:From:Date:From;
        b=AF/FbWzV55mHnEYHfXmOn6AdxyPzLXla99yq07EUOVGe5+XQKCUHRC6J/JPtnIFvU
         UnwHdgdvS6WHt5nrrDsLCuGxbnS97+csXZVSkL/2KEfDSoa7PnRDWW7abwGjuvFIsb
         k+MS83V2BkP0RvW6XqPKnZxHVtdNIucZiXQZnNVQ=
Subject: FAILED: patch "[PATCH] brcmfmac: pcie: Fix crashes due to early IRQs" failed to apply to 4.9-stable tree
To:     marcan@marcan.st, andy.shevchenko@gmail.com,
        arend.vanspriel@broadcom.com, kvalo@kernel.org,
        linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 02 Apr 2022 14:59:04 +0200
Message-ID: <1648904344179253@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b50255c83b914defd61a57fbc81d452334b63f4c Mon Sep 17 00:00:00 2001
From: Hector Martin <marcan@marcan.st>
Date: Tue, 1 Feb 2022 01:07:10 +0900
Subject: [PATCH] brcmfmac: pcie: Fix crashes due to early IRQs

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

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3f3ca7612bcd..55f0111283c9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1315,6 +1315,18 @@ static void brcmf_pcie_down(struct device *dev)
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
@@ -1423,6 +1435,7 @@ static int brcmf_pcie_reset(struct device *dev)
 }
 
 static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
+	.preinit = brcmf_pcie_preinit,
 	.txdata = brcmf_pcie_tx,
 	.stop = brcmf_pcie_down,
 	.txctl = brcmf_pcie_tx_ctlpkt,
@@ -1795,9 +1808,6 @@ static void brcmf_pcie_setup(struct device *dev, int ret,
 
 	init_waitqueue_head(&devinfo->mbdata_resp_wait);
 
-	brcmf_pcie_intr_enable(devinfo);
-	brcmf_pcie_hostready(devinfo);
-
 	ret = brcmf_attach(&devinfo->pdev->dev);
 	if (ret)
 		goto fail;

