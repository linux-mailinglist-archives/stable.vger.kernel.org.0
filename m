Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F0554871E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349257AbiFMMU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354714AbiFMMRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E0E55499;
        Mon, 13 Jun 2022 04:02:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C31961346;
        Mon, 13 Jun 2022 11:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96769C34114;
        Mon, 13 Jun 2022 11:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118156;
        bh=o3Wu0J4jFNlg/VFDmbxPFZwL8LXmJMBJygGAvRw29Zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFcxw3gpdBRCwDFw/gWq95IVp9DWYYrupCyNGNvSeBaWGSuecDFIRoxKb2ucmO3m5
         2mRzGz2jzNiKq/5Mk/z4d8O1tzsjOuHgFVdx9Ls9EhG/CipNrBKOdX8on9nq29hmQI
         mrOsrzpaEYICZSmRWEtxl+kq48gPnNO/3lRXKorM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 246/287] net: altera: Fix refcount leak in altera_tse_mdio_create
Date:   Mon, 13 Jun 2022 12:11:10 +0200
Message-Id: <20220613094931.474674146@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 11ec18b1d8d92b9df307d31950dcba0b3dd7283c ]

Every iteration of for_each_child_of_node() decrements
the reference count of the previous node.
When break from a for_each_child_of_node() loop,
we need to explicitly call of_node_put() on the child node when
not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220607041144.7553-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 1b4dfd357383..1b9fb78ef824 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -174,7 +174,8 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 	mdio = mdiobus_alloc();
 	if (mdio == NULL) {
 		netdev_err(dev, "Error allocating MDIO bus\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto put_node;
 	}
 
 	mdio->name = ALTERA_TSE_RESOURCE_NAME;
@@ -191,6 +192,7 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 			   mdio->id);
 		goto out_free_mdio;
 	}
+	of_node_put(mdio_node);
 
 	if (netif_msg_drv(priv))
 		netdev_info(dev, "MDIO bus %s: created\n", mdio->id);
@@ -200,6 +202,8 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 out_free_mdio:
 	mdiobus_free(mdio);
 	mdio = NULL;
+put_node:
+	of_node_put(mdio_node);
 	return ret;
 }
 
-- 
2.35.1



