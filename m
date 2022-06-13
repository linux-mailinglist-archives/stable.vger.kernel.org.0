Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D894854898C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383609AbiFMObq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385033AbiFMOac (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:30:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66128A7E3E;
        Mon, 13 Jun 2022 04:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45CB2B80EDE;
        Mon, 13 Jun 2022 11:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A325CC34114;
        Mon, 13 Jun 2022 11:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120854;
        bh=rnyRN8uJNieEChc6O58lyP6uWMUtgSC8w2CYZauwB94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HAR45XppdIlFBmDQI7Wo1tW9kmgcFZMb8bUmqEANlWWBeAOUELaPIxSlyb0H9mxc/
         zIzZiW/UggwAAPgnEVmuCS1QY2D842d1GjoeObw9je3njZhxWxS9GdSWf3V+RUAMvv
         V6VDk7vVBqOjCtpjXf6V2WXegOC8Kix7pIhyTdg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 182/298] net: mdio: unexport __init-annotated mdio_bus_init()
Date:   Mon, 13 Jun 2022 12:11:16 +0200
Message-Id: <20220613094930.451844213@linuxfoundation.org>
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



