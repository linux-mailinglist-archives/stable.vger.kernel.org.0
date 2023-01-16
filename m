Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D821866C8DF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjAPQoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbjAPQnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:43:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108E75B8E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:31:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C02EEB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EA1C433D2;
        Mon, 16 Jan 2023 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886659;
        bh=23aIuIpSz0GmorfB4Zw8S7EL8gnoi0Bvprkul4f1nus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBnwPF6jqmLauGWMJpm9snDEnUQ7pam+iadZX6hrfeeBhfwbcs0x2VxkGZEFZj1Y9
         kWZoqciDsMTc2h5Ho4qt8sbikoyPPa84cUAVOwJEqFA4I2PVN/S9AVnNbCXf2xk9cv
         PzdcE8iKRzvmlOz/wF/NTYSA1+eW4+e19AaUt16c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenchao Chen <wenchao.chen@unisoc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 483/658] mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K
Date:   Mon, 16 Jan 2023 16:49:31 +0100
Message-Id: <20230116154931.606766170@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Wenchao Chen <wenchao.chen@unisoc.com>

commit ff874dbc4f868af128b412a9bd92637103cf11d7 upstream.

When the clock is less than 400K, some SD cards fail to initialize
because CLK_AUTO is enabled.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Signed-off-by: Wenchao Chen <wenchao.chen@unisoc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221207051909.32126-1-wenchao.chen@unisoc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-sprd.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -223,13 +223,15 @@ static inline void _sdhci_sprd_set_clock
 	div = ((div & 0x300) >> 2) | ((div & 0xFF) << 8);
 	sdhci_enable_clk(host, div);
 
-	/* enable auto gate sdhc_enable_auto_gate */
-	val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);
-	mask = SDHCI_SPRD_BIT_OUTR_CLK_AUTO_EN |
-	       SDHCI_SPRD_BIT_INNR_CLK_AUTO_EN;
-	if (mask != (val & mask)) {
-		val |= mask;
-		sdhci_writel(host, val, SDHCI_SPRD_REG_32_BUSY_POSI);
+	/* Enable CLK_AUTO when the clock is greater than 400K. */
+	if (clk > 400000) {
+		val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);
+		mask = SDHCI_SPRD_BIT_OUTR_CLK_AUTO_EN |
+			SDHCI_SPRD_BIT_INNR_CLK_AUTO_EN;
+		if (mask != (val & mask)) {
+			val |= mask;
+			sdhci_writel(host, val, SDHCI_SPRD_REG_32_BUSY_POSI);
+		}
 	}
 }
 


