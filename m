Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3D9154C25
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgBFTYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:46 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45405 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:46 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7FA9F21D28;
        Thu,  6 Feb 2020 14:24:45 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8cVRzL
        0bcZRizeVzre5S7YP19AAUkq4UwSWp1QzzUE0=; b=H+aVz+AdFN2TB80190/aGK
        7iyntONShdhr0cNSVS7LHmfdIeTwaOwTWCQggYtvPgbf0frFEunAlK6rj1jEl5YM
        oq1h+N9yflrwgZHQMj1Y09H8zd4jD17eA8bMFs5ZS4TrqChN689CKtM+tckTCLFi
        eCHh5qYLFajIHoIOBTDaNtL2SzgOIYHAjrYykcoRlsjOUy4fh5QCbr9whmcRHe+v
        QfWEL5BNft9QW/iSjU18X7IyuvzGxqvO2Fm7nNPC746O+xAjL4o1iwaq2JtR5UOA
        F5ABquLatWVLqhKD5LOqhKmPgdkVMn/L6Cvii+ZSHIbcIcRla0qKhF+rhK3IWbXg
        ==
X-ME-Sender: <xms:_Wc8XmqjZEWJhbVuY98b-FsEZCOeJkJ_54hGbkiykB3BAcIPCcWv4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_Wc8Xn73DbXBEOh_N9bZ45KSb4xgEdLze4EjJxSKOf2YbUrI5hF7Kw>
    <xmx:_Wc8XvQABRnoes4hPKeI1Sy-DH4V9VmuStbov_WoAEnhGlD0PyhEuQ>
    <xmx:_Wc8Xv7ad2dojLoJwL_mExLZnzeEVPY2nb7nZvmWMRKPipgMMedqRA>
    <xmx:_Wc8Xj8izsXz-uuSlIYKS7jDUmwvU-BUeIZPH5Mgs3Jf_YO80_pcag>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 15AFF30606FB;
        Thu,  6 Feb 2020 14:24:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] PCI: keystone: Fix link training retries initiation" failed to apply to 4.4-stable tree
To:     monakov.y@gmail.com, andrew.murray@arm.com,
        lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:06:46 +0100
Message-ID: <158101600690191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

