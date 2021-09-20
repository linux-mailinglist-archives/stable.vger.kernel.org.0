Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39D04125CD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384637AbhITSsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384049AbhITSq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:46:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A63EB61B00;
        Mon, 20 Sep 2021 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159205;
        bh=J++Xue/OUKFhVvOxY3tDh0wvNGzwBHc61OJQ/vIxcDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=utNnSxlLUDbghXRzPou4ztxtm+xSqsWAY8eKYbbQHXNixkopNHdDxL5mpSXwXpxHn
         hLCKAF4vLW8iCFm1R2ckzuvl3S6+kRml4sERBYmDKWAgPoyJ3VHN4VUmxGRRLnp02L
         cSq66nF03uw+72mqNYoj1viXngxGb0r6ZGziAWNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Roman Bacik <roman.bacik@broadcom.com>,
        Bharat Gooty <bharat.gooty@broadcom.com>,
        Abhishek Shah <abhishek.shah@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 124/168] PCI: of: Dont fail devm_pci_alloc_host_bridge() on missing ranges
Date:   Mon, 20 Sep 2021 18:44:22 +0200
Message-Id: <20210920163925.737206408@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit d277f6e88c88729b1d57d40bbfb00d0bfc961972 ]

Commit 669cbc708122 ("PCI: Move DT resource setup into
devm_pci_alloc_host_bridge()") made devm_pci_alloc_host_bridge() fail on
any DT resource parsing errors, but Broadcom iProc uses
devm_pci_alloc_host_bridge() on BCMA bus devices that don't have DT
resources. In particular, there is no 'ranges' property. Fix iProc by
making 'ranges' optional.

If 'ranges' is required by a platform, there's going to be more errors
latter on if it is missing.

Link: https://lore.kernel.org/r/20210803215656.3803204-1-robh@kernel.org
Fixes: 669cbc708122 ("PCI: Move DT resource setup into devm_pci_alloc_host_bridge()")
Reported-by: Rafał Miłecki <zajec5@gmail.com>
Tested-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Srinath Mannam <srinath.mannam@broadcom.com>
Cc: Roman Bacik <roman.bacik@broadcom.com>
Cc: Bharat Gooty <bharat.gooty@broadcom.com>
Cc: Abhishek Shah <abhishek.shah@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: Ray Jui <ray.jui@broadcom.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>
Cc: Scott Branden <sbranden@broadcom.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/of.c b/drivers/pci/of.c
index a143b02b2dcd..d84381ce82b5 100644
--- a/drivers/pci/of.c
+++ b/drivers/pci/of.c
@@ -310,7 +310,7 @@ static int devm_of_pci_get_host_bridge_resources(struct device *dev,
 	/* Check for ranges property */
 	err = of_pci_range_parser_init(&parser, dev_node);
 	if (err)
-		goto failed;
+		return 0;
 
 	dev_dbg(dev, "Parsing ranges property...\n");
 	for_each_of_pci_range(&parser, &range) {
-- 
2.30.2



