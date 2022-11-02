Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A9A6159C7
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbiKBDSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiKBDR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:17:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFFC24F18
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:17:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED0EA617BF
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D47AC433D6;
        Wed,  2 Nov 2022 03:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359074;
        bh=JnaJN0rXePnDNtj7gAlXNDHY89D7eBTKxx+xfMoBdX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqEvEeSZTP+gk4AZntWxmbH1yRwLEKr9BtuEtSPvbCDq9CjlJdfgqJvekx5UniO/1
         9hgVa3jqojPoY3bfYg/jKNTaCCIjAB9LnXYnt/vrivQlSYkgVrFyaAvN0vCvctByHv
         fPGRQ/WHXNuUf0rODB83iHwAZbVHSjS74mEh+F1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/91] net: netsec: fix error handling in netsec_register_mdio()
Date:   Wed,  2 Nov 2022 03:33:28 +0100
Message-Id: <20221102022056.310426750@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 94423589689124e8cd145b38a1034be7f25835b2 ]

If phy_device_register() fails, phy_device_free() need be called to
put refcount, so memory of phy device and device name can be freed
in callback function.

If get_phy_device() fails, mdiobus_unregister() need be called,
or it will cause warning in mdiobus_free() and kobject is leaked.

Fixes: 533dd11a12f6 ("net: socionext: Add Synquacer NetSec driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221019064104.3228892-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/socionext/netsec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index ef3634d1b9f7..b9acee214bb6 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1958,11 +1958,13 @@ static int netsec_register_mdio(struct netsec_priv *priv, u32 phy_addr)
 			ret = PTR_ERR(priv->phydev);
 			dev_err(priv->dev, "get_phy_device err(%d)\n", ret);
 			priv->phydev = NULL;
+			mdiobus_unregister(bus);
 			return -ENODEV;
 		}
 
 		ret = phy_device_register(priv->phydev);
 		if (ret) {
+			phy_device_free(priv->phydev);
 			mdiobus_unregister(bus);
 			dev_err(priv->dev,
 				"phy_device_register err(%d)\n", ret);
-- 
2.35.1



