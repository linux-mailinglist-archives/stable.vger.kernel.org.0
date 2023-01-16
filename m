Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B2366C82E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbjAPQgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjAPQgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:36:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FDB31E38
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:25:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E760B81077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:25:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC099C433D2;
        Mon, 16 Jan 2023 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886301;
        bh=UM+IYEQ+Mjb3PLieg5k5RFgn+VtJTGcvD3sCgYIhO1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xvu11ZwUGeN9p7WPaco5vaD7uVweJXHrNUqkYo2HfRVKaUt5xl9DnO9yU5J2IROZI
         MCpSZM9uLoTKox6nve1RJTLTawDPcSXlqa+VhjGLBhLSfoe8tFp6wdaPrAjolKueqW
         u4nh0Rid/5MixumGhz0ncoMowjJujkWfNbxnndmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 377/658] r6040: Fix kmemleak in probe and remove
Date:   Mon, 16 Jan 2023 16:47:45 +0100
Message-Id: <20230116154926.808426012@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 7e43039a49c2da45edc1d9d7c9ede4003ab45a5f ]

There is a memory leaks reported by kmemleak:

  unreferenced object 0xffff888116111000 (size 2048):
    comm "modprobe", pid 817, jiffies 4294759745 (age 76.502s)
    hex dump (first 32 bytes):
      00 c4 0a 04 81 88 ff ff 08 10 11 16 81 88 ff ff  ................
      08 10 11 16 81 88 ff ff 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff815bcd82>] kmalloc_trace+0x22/0x60
      [<ffffffff827e20ee>] phy_device_create+0x4e/0x90
      [<ffffffff827e6072>] get_phy_device+0xd2/0x220
      [<ffffffff827e7844>] mdiobus_scan+0xa4/0x2e0
      [<ffffffff827e8be2>] __mdiobus_register+0x482/0x8b0
      [<ffffffffa01f5d24>] r6040_init_one+0x714/0xd2c [r6040]
      ...

The problem occurs in probe process as follows:
  r6040_init_one:
    mdiobus_register
      mdiobus_scan    <- alloc and register phy_device,
                         the reference count of phy_device is 3
    r6040_mii_probe
      phy_connect     <- connect to the first phy_device,
                         so the reference count of the first
                         phy_device is 4, others are 3
    register_netdev   <- fault inject succeeded, goto error handling path

    // error handling path
    err_out_mdio_unregister:
      mdiobus_unregister(lp->mii_bus);
    err_out_mdio:
      mdiobus_free(lp->mii_bus);    <- the reference count of the first
                                       phy_device is 1, it is not released
                                       and other phy_devices are released
  // similarly, the remove process also has the same problem

The root cause is traced to the phy_device is not disconnected when
removes one r6040 device in r6040_remove_one() or on error handling path
after r6040_mii probed successfully. In r6040_mii_probe(), a net ethernet
device is connected to the first PHY device of mii_bus, in order to
notify the connected driver when the link status changes, which is the
default behavior of the PHY infrastructure to handle everything.
Therefore the phy_device should be disconnected when removes one r6040
device or on error handling path.

Fix it by adding phy_disconnect() when removes one r6040 device or on
error handling path after r6040_mii probed successfully.

Fixes: 3831861b4ad8 ("r6040: implement phylib")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221213125614.927754-1-lizetao1@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/rdc/r6040.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/rdc/r6040.c b/drivers/net/ethernet/rdc/r6040.c
index f158fdf3aab2..b66689e0e6f2 100644
--- a/drivers/net/ethernet/rdc/r6040.c
+++ b/drivers/net/ethernet/rdc/r6040.c
@@ -1162,10 +1162,12 @@ static int r6040_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	err = register_netdev(dev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to register net device\n");
-		goto err_out_mdio_unregister;
+		goto err_out_phy_disconnect;
 	}
 	return 0;
 
+err_out_phy_disconnect:
+	phy_disconnect(dev->phydev);
 err_out_mdio_unregister:
 	mdiobus_unregister(lp->mii_bus);
 err_out_mdio:
@@ -1189,6 +1191,7 @@ static void r6040_remove_one(struct pci_dev *pdev)
 	struct r6040_private *lp = netdev_priv(dev);
 
 	unregister_netdev(dev);
+	phy_disconnect(dev->phydev);
 	mdiobus_unregister(lp->mii_bus);
 	mdiobus_free(lp->mii_bus);
 	netif_napi_del(&lp->napi);
-- 
2.35.1



