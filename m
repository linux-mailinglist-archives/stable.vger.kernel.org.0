Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC70B329066
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242875AbhCAUIQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:08:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236524AbhCAT4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:56:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63E7565380;
        Mon,  1 Mar 2021 17:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621347;
        bh=6WToUgPurUbK+0/2Pjaf7HX+UxnmuyEcac10To0teZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2JALIzw+DmwCRsPTz9ixt84Fh7ox9Eg9W0DHcoPvZlXxtifz/ChB1EkgCRQ3OGJhQ
         ZfxNcZrxwpeQfhQoKyyfcW0dIeTaedOipsdnazKnYbj/PnCsopGO6LdUDQj7Dcf47D
         FLe1WjsIb8xduM8LciHS0nkcVHDLVEfl7wcHi/tY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Marek Vasut <marek.vasut+renesas@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-renesas-soc@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 482/775] PCI: rcar: Always allocate MSI addresses in 32bit space
Date:   Mon,  1 Mar 2021 17:10:50 +0100
Message-Id: <20210301161225.352173156@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marek.vasut+renesas@gmail.com>

[ Upstream commit c4e0fec2f7ee013dbf86445394ff47f719408f99 ]

This fixes MSI operation on legacy PCI cards, which cannot issue 64bit MSIs.
The R-Car controller only has one MSI trigger address instead of two, one
for 64bit and one for 32bit MSI, set the address to 32bit PCIe space so that
legacy PCI cards can also trigger MSIs.

Link: https://lore.kernel.org/r/20201016120431.7062-1-marek.vasut@gmail.com
Fixes: 290c1fb35860 ("PCI: rcar: Add MSI support for PCIe")
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Marek Vasut <marek.vasut+renesas@gmail.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: linux-renesas-soc@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-rcar-host.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rcar-host.c b/drivers/pci/controller/pcie-rcar-host.c
index 4d1c4b24e5370..a728e8f9ad3c8 100644
--- a/drivers/pci/controller/pcie-rcar-host.c
+++ b/drivers/pci/controller/pcie-rcar-host.c
@@ -735,7 +735,7 @@ static int rcar_pcie_enable_msi(struct rcar_pcie_host *host)
 	}
 
 	/* setup MSI data target */
-	msi->pages = __get_free_pages(GFP_KERNEL, 0);
+	msi->pages = __get_free_pages(GFP_KERNEL | GFP_DMA32, 0);
 	rcar_pcie_hw_enable_msi(host);
 
 	return 0;
-- 
2.27.0



