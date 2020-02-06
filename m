Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADB4C154C24
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBFTYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:44 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38235 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E2A9921DC6;
        Thu,  6 Feb 2020 14:24:43 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fFEwnW
        gD+xWTmJxzgxRjj+vA7Q1h5FpE5u6PMA650VI=; b=irr32GfP4ojNUQhGp8tMyC
        EL2HXRw6NZ8U9KaieBcXNwIG2dj3daaFxSepb2+S10Dq7e/12qvNEafflu5ioRQj
        xAfokQ1eKxSQc7HTU9ThUNYMvXQTTunmjvLACGqdhMoGnH1IXfRoCXXXxeHXzPQZ
        m14DkT9OzD6llEP4FHDZiAxg0xQgGJS7Y9NvKyL9Drbn+TsA72oXrikART9+XhhI
        JaoYMNNMSfHwB0ZmmvmG/9zq9pHE+TpVNcv7oIpMaJEiSYf9U4bd0DzaEuOSlkZY
        qzHSMVvWQbr0I4WqXSGhEYhv0KUMqp8l10IR0M4k2XlSrdKW0Vrh7GH9Wx5Mwufw
        ==
X-ME-Sender: <xms:-2c8Xs1Hc3Nc_mDWMNFTYLjmq1oEZEj9aaOIzSykCxoZDosgJVpVYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-2c8XjatPnPLKS36cGdrv0eaKTzJycsu6Ayp3BwS_lXGRUIUf0peYQ>
    <xmx:-2c8XnpNFfJ4t6vfgqfHdR2PCig0kENuQxhVwQUIgz3eVufvNonAGQ>
    <xmx:-2c8Xno4uUeY8AttAAmpQ1cDctFIt89bE-Hfpr6CG5lOz3Ryay_M3A>
    <xmx:-2c8Xrm8_MVgH0piK24B5qJ9ZXiIGUnKLV6C4TY7RtXzU1OO32gT8g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7BFFA328005E;
        Thu,  6 Feb 2020 14:24:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] PCI: keystone: Fix link training retries initiation" failed to apply to 4.19-stable tree
To:     monakov.y@gmail.com, andrew.murray@arm.com,
        lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:06:45 +0100
Message-ID: <158101600590150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 6df19872d881641e6394f93ef2938cffcbdae5bb Mon Sep 17 00:00:00 2001
From: Yurii Monakov <monakov.y@gmail.com>
Date: Tue, 17 Dec 2019 14:38:36 +0300
Subject: [PATCH] PCI: keystone: Fix link training retries initiation

ks_pcie_stop_link() function does not clear LTSSM_EN_VAL bit so
link training was not triggered more than once after startup.
In configurations where link can be unstable during early boot,
for example, under low temperature, it will never be established.

Fixes: 0c4ffcfe1fbc ("PCI: keystone: Add TI Keystone PCIe driver")
Signed-off-by: Yurii Monakov <monakov.y@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Andrew Murray <andrew.murray@arm.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index af677254a072..d4de4f6cff8b 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -510,7 +510,7 @@ static void ks_pcie_stop_link(struct dw_pcie *pci)
 	/* Disable Link training */
 	val = ks_pcie_app_readl(ks_pcie, CMD_STATUS);
 	val &= ~LTSSM_EN_VAL;
-	ks_pcie_app_writel(ks_pcie, CMD_STATUS, LTSSM_EN_VAL | val);
+	ks_pcie_app_writel(ks_pcie, CMD_STATUS, val);
 }
 
 static int ks_pcie_start_link(struct dw_pcie *pci)

