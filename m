Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AD766CDC3
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbjAPRjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbjAPRjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:39:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C9A4C6CD
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 09:15:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8101E60F7C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 17:15:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FDFC433D2;
        Mon, 16 Jan 2023 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673889317;
        bh=R97asc3rfpP3fL8DjOmjs4qrMRoArGcqYJT5ulHS7hE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pd+go63bShqt40WBZVK7XnVsWAGbjThzgP9C6W/940UaTR6fV7m20Bo2vU4C65vUF
         Z4Uq09M+uZzj90QTnyownQgmQAUAIZknaoBvzs/1B9fK9et4R7a7ZsylFn0LSIhJy6
         pIF+xvpzuIRRUFgKsqXsSvNzUptWAAFNYNpSHkY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 312/338] net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
Date:   Mon, 16 Jan 2023 16:53:05 +0100
Message-Id: <20230116154834.733714444@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit d039535850ee47079d59527e96be18d8e0daa84b ]

of_phy_find_device() return device node with refcount incremented.
Call put_device() to relese it when not needed anymore.

Fixes: ab4e6ee578e8 ("net: phy: xgmiitorgmii: Check phy_driver ready before accessing")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/xilinx_gmii2rgmii.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/xilinx_gmii2rgmii.c b/drivers/net/phy/xilinx_gmii2rgmii.c
index aef525467af0..55157c3197bd 100644
--- a/drivers/net/phy/xilinx_gmii2rgmii.c
+++ b/drivers/net/phy/xilinx_gmii2rgmii.c
@@ -89,6 +89,7 @@ static int xgmiitorgmii_probe(struct mdio_device *mdiodev)
 
 	if (!priv->phy_dev->drv) {
 		dev_info(dev, "Attached phy not ready\n");
+		put_device(&priv->phy_dev->mdio.dev);
 		return -EPROBE_DEFER;
 	}
 
-- 
2.35.1



