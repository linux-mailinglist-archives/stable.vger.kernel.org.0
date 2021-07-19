Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E713CDD0C
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237781AbhGSOzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:46246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237692AbhGSOxU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:53:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53ECE60241;
        Mon, 19 Jul 2021 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708761;
        bh=aQHCC15zZqYn21UNqXYFRjJ9Vs2G/EVMrFA975quW4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oobpwkQ+BOGYObDzyQ5XvroksyjuvD54owDWWhxXOZ2l4AABZV5eN24FoKjbc17q+
         0YsdsYveuOlvzVHhsn/WLn4aDHcHnuWIvaX+QDC+KBc3PEO8B9Ah6ksa1BafAU8EpY
         3Fq8F+ONps2OmHWuWUKXT/ptQOl2OmMAPOw1ZX98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Flavio Suligoi <f.suligoi@asem.it>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/421] net: pch_gbe: Propagate error from devm_gpio_request_one()
Date:   Mon, 19 Jul 2021 16:48:52 +0200
Message-Id: <20210719144950.743617507@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 9e3617a7b84512bf96c04f9cf82d1a7257d33794 ]

If GPIO controller is not available yet we need to defer
the probe of GBE until provider will become available.

While here, drop GPIOF_EXPORT because it's deprecated and
may not be available.

Fixes: f1a26fdf5944 ("pch_gbe: Add MinnowBoard support")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Flavio Suligoi <f.suligoi@asem.it>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 3a4225837049..70f3276539c4 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2546,9 +2546,13 @@ static int pch_gbe_probe(struct pci_dev *pdev,
 	adapter->pdev = pdev;
 	adapter->hw.back = adapter;
 	adapter->hw.reg = pcim_iomap_table(pdev)[PCH_GBE_PCI_BAR];
+
 	adapter->pdata = (struct pch_gbe_privdata *)pci_id->driver_data;
-	if (adapter->pdata && adapter->pdata->platform_init)
-		adapter->pdata->platform_init(pdev);
+	if (adapter->pdata && adapter->pdata->platform_init) {
+		ret = adapter->pdata->platform_init(pdev);
+		if (ret)
+			goto err_free_netdev;
+	}
 
 	adapter->ptp_pdev =
 		pci_get_domain_bus_and_slot(pci_domain_nr(adapter->pdev->bus),
@@ -2643,7 +2647,7 @@ err_free_netdev:
  */
 static int pch_gbe_minnow_platform_init(struct pci_dev *pdev)
 {
-	unsigned long flags = GPIOF_DIR_OUT | GPIOF_INIT_HIGH | GPIOF_EXPORT;
+	unsigned long flags = GPIOF_OUT_INIT_HIGH;
 	unsigned gpio = MINNOW_PHY_RESET_GPIO;
 	int ret;
 
-- 
2.30.2



