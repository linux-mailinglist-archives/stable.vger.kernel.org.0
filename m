Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B86F5154C22
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgBFTYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:24:42 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60835 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbgBFTYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:24:42 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AD8BD2207A;
        Thu,  6 Feb 2020 14:24:40 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 06 Feb 2020 14:24:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=reL5mB
        +1kPJjAEOGK715RpB69MESaiPf/2aeD04HgEU=; b=s2aWXaaaQOarYASqrxrpyP
        suYliEsMC4m3WzhU9hd+dUwPeG/gMcC1r6uZT7cSW1gEeqROYwvxaUAV3xf94mGq
        QVA/v5IHXnSOj3njuKvuYUfvNG//PjxKlWNsRpD0Z6IGOY7X8k5ctBHiIZsf7BzK
        9bVCUYqZkvpIJH0jq3h4G5v9xEq1/X3ZZl4EGUM++usIomsd8sqlZ2gfcxwE0V59
        v2kHOpU7i2o5OvshF3J7HQu61ogqLjPbh8OPhWunqDKGnJO8nylmlcbWBESQN4JX
        5axYa8NWcPj/rLO1GDdAeDG6y5mA2LoFFDfPggGHrFx2yxTk4ZImXAgeO2cBy9VA
        ==
X-ME-Sender: <xms:-Gc8Xnd7ibWqr6V7J0isjXP7UPXaDFwqLInzvIVIwKxR-sndnkLD0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheefgdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-Gc8XhdxT3WDE7gDzQ-2nbrC3ej41v0ChXPYvhVAlukLQDKYnc5_lA>
    <xmx:-Gc8Xri9TEc26nBNrg7VSwvRWTGDKrwBIn8PFWsTp_waIrZUIXcXxw>
    <xmx:-Gc8XtQgv9L4Et2C5zBI5IGou67_tN9tWzxcVVju4kdU1oJFtHlCRA>
    <xmx:-Gc8XnPu-RUkIvJPDOunCRt1ir9S6N7z_CeZR0xS0GpUEHtXBXfAnA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D4C130600DC;
        Thu,  6 Feb 2020 14:24:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] PCI: keystone: Fix link training retries initiation" failed to apply to 4.14-stable tree
To:     monakov.y@gmail.com, andrew.murray@arm.com,
        lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 06 Feb 2020 20:06:45 +0100
Message-ID: <1581016005211144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

