Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D176B548881
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379124AbiFMNuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379247AbiFMNrn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:47:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4624B222B0;
        Mon, 13 Jun 2022 04:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65D70B80E59;
        Mon, 13 Jun 2022 11:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69ADC3411C;
        Mon, 13 Jun 2022 11:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119976;
        bh=rnyRN8uJNieEChc6O58lyP6uWMUtgSC8w2CYZauwB94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9rBv3zhL1rJBd9z/Me6YyQpdn1nf4ZVgFAd8fh77X9d/jOBnvJ0mmxQDdAVEpVPa
         blNPLkBF7+Kc8o2h5bsTIchYJKZUZvVrsodCsL3Xu0XxZZf7bEqqEi+IUpbwA66N1x
         Y3sARP1ghwkAj5Rw2bqYZl443EdRL2287m3vkXTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 206/339] net: mdio: unexport __init-annotated mdio_bus_init()
Date:   Mon, 13 Jun 2022 12:10:31 +0200
Message-Id: <20220613094932.911618579@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 35b42dce619701f1300fb8498dae82c9bb1f0263 ]

EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

modpost used to detect it, but it has been broken for a decade.

Recently, I fixed modpost so it started to warn it again, then this
showed up in linux-next builds.

There are two ways to fix it:

  - Remove __init
  - Remove EXPORT_SYMBOL

I chose the latter for this case because the only in-tree call-site,
drivers/net/phy/phy_device.c is never compiled as modular.
(CONFIG_PHYLIB is boolean)

Fixes: 90eff9096c01 ("net: phy: Allow splitting MDIO bus/device support from PHYs")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 58d602985877..8a2dbe849866 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -1046,7 +1046,6 @@ int __init mdio_bus_init(void)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mdio_bus_init);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 void mdio_bus_exit(void)
-- 
2.35.1



