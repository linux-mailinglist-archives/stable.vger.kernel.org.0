Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E235497E8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382142AbiFMOQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383218AbiFMOPb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:15:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E24699CF51;
        Mon, 13 Jun 2022 04:42:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6A976B80EDD;
        Mon, 13 Jun 2022 11:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14FBC34114;
        Mon, 13 Jun 2022 11:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120577;
        bh=nrF/adwgwx9MgAPpcT7qaXo0qs8+u+oOf8h/HKdJwhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6c2pywff9FQqjzDNkXyQRQ21+Jbuky3Ot3PUc50cS901Fsff5jOOTgI/fawP2drZ
         fBnEWAC9L/2cI+zEc5aI4kLMDtk6req4fmmkYkqMt20K37GIiuZ/zbAkjwG+rCC/Vi
         vXyC/lDAenmQJxHYmzl36QR6VTZVzFomr1uNbvYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 082/298] net: lan966x: check devm_of_phy_get() for -EDEFER_PROBE
Date:   Mon, 13 Jun 2022 12:09:36 +0200
Message-Id: <20220613094927.433965236@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index fee148bbf13e..b0cb3b65cd5b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -948,8 +948,13 @@ static int lan966x_probe(struct platform_device *pdev)
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



