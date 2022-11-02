Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB116158C2
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiKBC6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbiKBC6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:58:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB392253A
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:58:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFA00617BA
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C985C433D6;
        Wed,  2 Nov 2022 02:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357883;
        bh=Ipssz5fsqLq6JqOrIvz0LitNzM3XyZf0npGBV0xsWjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3PP31XQ9aMnW+Mf42JsP4J22UYs9VilK2w0ipwMnBnfkABlYNBIbA4rASOqOsKoz
         8IeNnaWGo5Z1WzCHh9KAzcicghaVHXa9uk9kL5biiZ6rs6Zh6q36cMrYSpAiGdxw2j
         goOPKeowSsYUi1LiMvMMpvuz8hXlqGKWaBILLGFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Florian Fainelli <f.fainelli@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 217/240] net: bcmsysport: Indicate MAC is in charge of PHY PM
Date:   Wed,  2 Nov 2022 03:33:12 +0100
Message-Id: <20221102022116.308995456@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 9f172134dde7e4f5bf4b9139f23a1e741ec1c36e ]

Avoid the PHY library call unnecessarily into the suspend/resume
functions by setting phydev->mac_managed_pm to true. The SYSTEMPORT
driver essentially does exactly what mdio_bus_phy_resume() does by
calling phy_resume().

Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221025234201.2549360-1-f.fainelli@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 47fc8e6963d5..2f01d4b0a9aa 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1991,6 +1991,9 @@ static int bcm_sysport_open(struct net_device *dev)
 		goto out_clk_disable;
 	}
 
+	/* Indicate that the MAC is responsible for PHY PM */
+	phydev->mac_managed_pm = true;
+
 	/* Reset house keeping link status */
 	priv->old_duplex = -1;
 	priv->old_link = -1;
-- 
2.35.1



