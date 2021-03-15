Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B66F33BA42
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhCOOIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234126AbhCOOC6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A7464EED;
        Mon, 15 Mar 2021 14:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816978;
        bh=kcnnK6WDFQU8lLJFM3dyQCYTMLsnTb223hTde03XaC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1FDt35jmrvu4tYt7MM22ATHQhjB0mAHkm9ROsDhfDa8T+0WkI6VLl4bptzori0mwf
         /VmpHDGEeUo4IEIY9ZO8aaLojJLyAngy58WRk8WRA9C/GcHC1uCDPNcOMux3KENaWd
         WwA2qE4BCsr+ERXhqioSD44Lu7meIZSjeLrUhbLc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Atish Patra <atish.patra@wdc.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 241/306] net: macb: Add default usrio config to default gem config
Date:   Mon, 15 Mar 2021 14:55:04 +0100
Message-Id: <20210315135515.793306491@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Atish Patra <atish.patra@wdc.com>

[ Upstream commit b12422362ce947098ac420ac3c975fc006af4c02 ]

There is no usrio config defined for default gem config leading to
a kernel panic devices that don't define a data. This issue can be
reprdouced with microchip polar fire soc where compatible string
is defined as "cdns,macb".

Fixes: edac63861db7 ("add userio bits as platform configuration")

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 814a5b10141d..07cdb38e7d11 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3950,6 +3950,13 @@ static int macb_init(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct macb_usrio_config macb_default_usrio = {
+	.mii = MACB_BIT(MII),
+	.rmii = MACB_BIT(RMII),
+	.rgmii = GEM_BIT(RGMII),
+	.refclk = MACB_BIT(CLKEN),
+};
+
 #if defined(CONFIG_OF)
 /* 1518 rounded up */
 #define AT91ETHER_MAX_RBUFF_SZ	0x600
@@ -4435,13 +4442,6 @@ static int fu540_c000_init(struct platform_device *pdev)
 	return macb_init(pdev);
 }
 
-static const struct macb_usrio_config macb_default_usrio = {
-	.mii = MACB_BIT(MII),
-	.rmii = MACB_BIT(RMII),
-	.rgmii = GEM_BIT(RGMII),
-	.refclk = MACB_BIT(CLKEN),
-};
-
 static const struct macb_usrio_config sama7g5_usrio = {
 	.mii = 0,
 	.rmii = 1,
@@ -4590,6 +4590,7 @@ static const struct macb_config default_gem_config = {
 	.dma_burst_length = 16,
 	.clk_init = macb_clk_init,
 	.init = macb_init,
+	.usrio = &macb_default_usrio,
 	.jumbo_max_len = 10240,
 };
 
-- 
2.30.1



