Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590B62E3E0E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439212AbgL1OXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439198AbgL1OW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:22:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16CE2206E5;
        Mon, 28 Dec 2020 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165338;
        bh=Tx1vtWgUCMvdAmoYjMA8T8oel78Nl0iT5cbRkDrgrMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l/Lhr56IvNgmIzDCTH9aCQjzm9OaieAYspCjGIZ0rC3XamB82WrB7nh0xPC99Ngt0
         m3CPvQ72RN55ymAyVHW5Cp9Ep95jzS+okFd68viofi8C1X0ukTGYpBalVeOo5elMtk
         ZoazVrlTPcOum9NsANKsSMgewaOdgyA2LNp7lcY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 495/717] clk: at91: sama7g5: fix compilation error
Date:   Mon, 28 Dec 2020 13:48:13 +0100
Message-Id: <20201228125044.680226617@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 91274497c79170aaadc491d4ffe4de35495a060d ]

pmc_data_allocate() has been changed. pmc_data_free() was removed.
Adapt the code taking this into consideration. With this the programmable
clocks were also saved in sama7g5_pmc so that they could be later
referenced.

Fixes: cb783bbbcf54 ("clk: at91: sama7g5: add clock support for sama7g5")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Tested-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/1605800597-16720-2-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sama7g5.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/sama7g5.c b/drivers/clk/at91/sama7g5.c
index 0db2ab3eca147..a092a940baa40 100644
--- a/drivers/clk/at91/sama7g5.c
+++ b/drivers/clk/at91/sama7g5.c
@@ -838,7 +838,7 @@ static void __init sama7g5_pmc_setup(struct device_node *np)
 	sama7g5_pmc = pmc_data_allocate(PMC_I2S1_MUX + 1,
 					nck(sama7g5_systemck),
 					nck(sama7g5_periphck),
-					nck(sama7g5_gck));
+					nck(sama7g5_gck), 8);
 	if (!sama7g5_pmc)
 		return;
 
@@ -980,6 +980,8 @@ static void __init sama7g5_pmc_setup(struct device_node *np)
 						    sama7g5_prog_mux_table);
 		if (IS_ERR(hw))
 			goto err_free;
+
+		sama7g5_pmc->pchws[i] = hw;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(sama7g5_systemck); i++) {
@@ -1052,7 +1054,7 @@ err_free:
 		kfree(alloc_mem);
 	}
 
-	pmc_data_free(sama7g5_pmc);
+	kfree(sama7g5_pmc);
 }
 
 /* Some clks are used for a clocksource */
-- 
2.27.0



