Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38F41154C23
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727949AbgBFTYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:43 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39367 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:43 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B3EE21DC6;
        Thu,  6 Feb 2020 14:24:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4ztaDo
        pn73hTjDXY3iqr9tlJSKn8Xyk+g/OBX0iNdWA=; b=o6cuuwrGyFAlhX4HUARnmQ
        V+Q6ZW6WY92Km/SFkqirhOdPXE7Nm+tC+t6D1ma/OMBgZZ1oJPK63dbj9qX8cLbd
        YTrNKyQUtrVi8832QLFn+y1K7WIXL/q4xAJ/cR/e5GNKybDi5O0Z0kRGUR4743ov
        Y3keBDlZSrXSaqAyz3yJfAzMDvEjIf4vpD6VhrZCnAaJGJxVJRdIR6b0P20ow4UJ
        XEKUP/FIyu9O32fDJ0Agytd9pTS6fvkK/hfUXuI51kEPVW5tYiZB6ZqaAWOFxNKQ
        a0DnNF1ybFi1jnw+jR5UuvxC4mH9pN+HYDosV2avjITST8mmGuV7DYLVzDsc28mQ
        ==
X-ME-Sender: <xms:-mc8Xo3Zwnfa9UTS0ihDtxIEFSmpc9U0v3wmk2xfUIATSXcUDjSKeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-mc8Xj2ruGXTXXbX1FJiAhgBUkw1oi2ksIqWGH6udvqeIbgNWCuwig>
    <xmx:-mc8XiuFKxsHXZxuMyjvUUvwlJvtsjmX-oTACZEc6oX7-MFs-ucujg>
    <xmx:-mc8XoJEOxoShjdqVA21AtVcxQuBvSi2TpfTQ5K5Q-jcJUQx8qznqQ>
    <xmx:-mc8XvCpB1x4vxNrrUv6OJBg9ws7fgxiN9yZfnUDO-TxQ40k-J6GRA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0CFA030600DC;
        Thu,  6 Feb 2020 14:24:41 -0500 (EST)
Subject: FAILED: patch "[PATCH] PCI: keystone: Fix link training retries initiation" failed to apply to 4.9-stable tree
To:     monakov.y@gmail.com, andrew.murray@arm.com,
        lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:06:45 +0100
Message-ID: <1581016005161100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

