Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA1514B4C1E
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348507AbiBNKhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348688AbiBNKfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:35:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DCE193FB;
        Mon, 14 Feb 2022 02:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 170B160DB7;
        Mon, 14 Feb 2022 10:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC5DC340E9;
        Mon, 14 Feb 2022 10:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832932;
        bh=LEOfSxMZuEod8sNoK5GbKy9hMr9peXP/MVpD+L3jJ7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8ORmY+7ln70D5TrbjVWMqpQGeb1Upo0VhfnMxsS712GB/x/e5v1gdo3MeE1XIhOb
         BiEkmClBm6cnxKNrdxS9UATALnG4+xJJxqBE+4nRbV3RlRjq6apb2SD0rx1BMsqdRO
         J6nvQNXzJ5jc7D1ilkSS2JZ2w04Ojz+uxQPL+kEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cai Huoqing <cai.huoqing@linux.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 143/203] net: ethernet: litex: Add the dependency on HAS_IOMEM
Date:   Mon, 14 Feb 2022 10:26:27 +0100
Message-Id: <20220214092515.095578047@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cai Huoqing <cai.huoqing@linux.dev>

[ Upstream commit 2427f03fb42f9dc14c53108f2c9b5563eb37e770 ]

The LiteX driver uses devm io function API which
needs HAS_IOMEM enabled, so add the dependency on HAS_IOMEM.

Fixes: ee7da21ac4c3 ("net: Add driver for LiteX's LiteETH network interface")
Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
Link: https://lore.kernel.org/r/20220208013308.6563-1-cai.huoqing@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/litex/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
index f99adbf26ab4e..04345b929d8e5 100644
--- a/drivers/net/ethernet/litex/Kconfig
+++ b/drivers/net/ethernet/litex/Kconfig
@@ -17,7 +17,7 @@ if NET_VENDOR_LITEX
 
 config LITEX_LITEETH
 	tristate "LiteX Ethernet support"
-	depends on OF
+	depends on OF && HAS_IOMEM
 	help
 	  If you wish to compile a kernel for hardware with a LiteX LiteEth
 	  device then you should answer Y to this.
-- 
2.34.1



