Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922BC63DF86
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiK3SsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231396AbiK3SsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:48:03 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF231AF15
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 79FBBCE1ADC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7E8C43470;
        Wed, 30 Nov 2022 18:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834077;
        bh=3q6CbR9Daz+CWEQlDNBBRQRCzD7MDoU9zpaxHvt2D10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+9tTT4n62UhjmOxPyLo7jGP2f08POClDLSyeaPYGkyYB4gcg3L6qLOXRCJI3eEhr
         YdsHKudqJkzq/Z2EtMiSQRdOpI/vCK7eoXouQRM5ARx31sIrS5esBD+VC6ySk9SrKS
         cn7pO9l4+MyEj7vnOiHuwahG6uDBCGacZg1ZcyZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Jian <liujian56@huawei.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 121/289] net: sparx5: fix error handling in sparx5_port_open()
Date:   Wed, 30 Nov 2022 19:21:46 +0100
Message-Id: <20221130180546.883777666@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 4305fe232b8aa59af3761adc9fe6b6aa40913960 ]

If phylink_of_phy_connect() fails, the port should be disabled.
If sparx5_serdes_set()/phy_power_on() fails, the port should be
disabled and the phylink should be stopped and disconnected.

Fixes: 946e7fd5053a ("net: sparx5: add port module support")
Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Tested-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
Reviewed-by: Steen Hegelund <steen.hegelund@microchip.com>
Link: https://lore.kernel.org/r/20221117125918.203997-1-liujian56@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index af4d3e1f1a6d..3f112a897a60 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -103,7 +103,7 @@ static int sparx5_port_open(struct net_device *ndev)
 	err = phylink_of_phy_connect(port->phylink, port->of_node, 0);
 	if (err) {
 		netdev_err(ndev, "Could not attach to PHY\n");
-		return err;
+		goto err_connect;
 	}
 
 	phylink_start(port->phylink);
@@ -115,10 +115,20 @@ static int sparx5_port_open(struct net_device *ndev)
 			err = sparx5_serdes_set(port->sparx5, port, &port->conf);
 		else
 			err = phy_power_on(port->serdes);
-		if (err)
+		if (err) {
 			netdev_err(ndev, "%s failed\n", __func__);
+			goto out_power;
+		}
 	}
 
+	return 0;
+
+out_power:
+	phylink_stop(port->phylink);
+	phylink_disconnect_phy(port->phylink);
+err_connect:
+	sparx5_port_enable(port, false);
+
 	return err;
 }
 
-- 
2.35.1



