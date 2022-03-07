Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F794CF7AA
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:46:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbiCGJqp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbiCGJmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:42:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11C0F26ACD;
        Mon,  7 Mar 2022 01:41:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E4DBB810B2;
        Mon,  7 Mar 2022 09:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D26C340E9;
        Mon,  7 Mar 2022 09:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646084;
        bh=LEOfSxMZuEod8sNoK5GbKy9hMr9peXP/MVpD+L3jJ7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WN+qQBYgJVlJOsmvcZExNmA6zi7iJoOiqD5hMvTSW+68eM696WN11YrVMHPmmN2je
         jTmSYPMT83lFFp+d8jtYYcXrwdfqPMYJDy6UjBIDAhBRtONpH2zN7uuLbbTw5KVaOC
         rmjhLej7A+rnBqA1d0oSmtIv5mJr+ktsbhH7bDNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Cai Huoqing <cai.huoqing@linux.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/262] net: ethernet: litex: Add the dependency on HAS_IOMEM
Date:   Mon,  7 Mar 2022 10:17:50 +0100
Message-Id: <20220307091706.013985836@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



