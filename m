Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0894C65D873
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239914AbjADQOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbjADQOj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:14:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED9341D77
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:14:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADF4D6179F
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A309AC433D2;
        Wed,  4 Jan 2023 16:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848846;
        bh=EG94yDk3p9gBjrX3vaY88CsBNJcK0tVoHICSCY6KvSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5n0aHdvQedv9P9kDN5k0w25jqwPf8LGSk5zh67ZM5Cd/Z15NEpjWl4L83C29U89t
         xyVMTzKE1JaQd9Ck/oHTg7U6xBzDr9E0nOW3o2e36NjbYGHGtH5lYCpYiDaxwxwF3/
         j/BSfQzCgzkjbdMUQ5VsWkx88Kg85hYNSofLGJm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wenchao Chen <wenchao.chen@unisoc.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 015/177] mmc: sdhci-sprd: Disable CLK_AUTO when the clock is less than 400K
Date:   Wed,  4 Jan 2023 17:05:06 +0100
Message-Id: <20230104160508.119018476@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -228,13 +228,15 @@ static inline void _sdhci_sprd_set_clock
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
 


