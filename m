Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB2B549447
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378328AbiFMNlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379008AbiFMNji (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:39:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227B479808;
        Mon, 13 Jun 2022 04:28:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B467461120;
        Mon, 13 Jun 2022 11:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42DDC3411E;
        Mon, 13 Jun 2022 11:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119708;
        bh=lb1NRHIneZZckJbWqJqCUNgsGp3oaxQWuts+N2qVL5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koYGnRW3BPWsP5d436X9o0XQZfi5aLLdpQlHVACrBy5/VlAF4/GPn4fsI+UUdF4jj
         jqQ+oGVpwDzSA1Rmap8LFXKiOlBfb6ACH4Y+cqxdXV86epU+d/50TrFwY6bY0fa84d
         66vrd1MhgAx+ht0zac2wf8PY5euh+OBcpS9yRI+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 092/339] net: lan966x: check devm_of_phy_get() for -EDEFER_PROBE
Date:   Mon, 13 Jun 2022 12:08:37 +0200
Message-Id: <20220613094929.305199521@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Michael Walle <michael@walle.cc>

[ Upstream commit b58cdd4388b1d8f5bee9f5a3897a7e780d1eaa48 ]

At the moment, if devm_of_phy_get() returns an error the serdes
simply isn't set. While it is bad to ignore an error in general, there
is a particular bug that network isn't working if the serdes driver is
compiled as a module. In that case, devm_of_phy_get() returns
-EDEFER_PROBE and the error is silently ignored.

The serdes is optional, it is not there if the port is using RGMII, in
which case devm_of_phy_get() returns -ENODEV. Rearrange the error
handling so that -ENODEV will be handled but other error codes will
abort the probing.

Fixes: d28d6d2e37d1 ("net: lan966x: add port module support")
Signed-off-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20220525231239.1307298-1-michael@walle.cc
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 05f6dcc9dfd5..f180a157eea4 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1080,8 +1080,13 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x->ports[p]->fwnode = fwnode_handle_get(portnp);
 
 		serdes = devm_of_phy_get(lan966x->dev, to_of_node(portnp), NULL);
-		if (!IS_ERR(serdes))
-			lan966x->ports[p]->serdes = serdes;
+		if (PTR_ERR(serdes) == -ENODEV)
+			serdes = NULL;
+		if (IS_ERR(serdes)) {
+			err = PTR_ERR(serdes);
+			goto cleanup_ports;
+		}
+		lan966x->ports[p]->serdes = serdes;
 
 		lan966x_port_init(lan966x->ports[p]);
 	}
-- 
2.35.1



