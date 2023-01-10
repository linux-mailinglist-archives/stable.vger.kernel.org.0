Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C39E664965
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239268AbjAJSVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239092AbjAJSUV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:20:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC6613CCC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:18:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA576186E
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF874C433D2;
        Tue, 10 Jan 2023 18:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374701;
        bh=qR6ssOcePY4bE+MRpEZp0lPnMh4TA3sLIpcorx5sMZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHjUhCo9DyJjRDtW7OkfC1+OcdVMElDZ2q7SeBWWMqkiNJ1twvmOTU9MLf+pUW04y
         eDqRUSumC5QNvx4LPsS7fVBFBEzFC9z/fI9DdLQLtG4TwxviULepesK8v12BYIsOEQ
         3HdcNNoLtFciEW9o56SG1O/Nzhxhl8QufK/QIZB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/159] net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe
Date:   Tue, 10 Jan 2023 19:03:42 +0100
Message-Id: <20230110180020.666800414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index 8dcb49ed1f3d..7fd9fe6a602b 100644
--- a/drivers/net/phy/xilinx_gmii2rgmii.c
+++ b/drivers/net/phy/xilinx_gmii2rgmii.c
@@ -105,6 +105,7 @@ static int xgmiitorgmii_probe(struct mdio_device *mdiodev)
 
 	if (!priv->phy_dev->drv) {
 		dev_info(dev, "Attached phy not ready\n");
+		put_device(&priv->phy_dev->mdio.dev);
 		return -EPROBE_DEFER;
 	}
 
-- 
2.35.1



