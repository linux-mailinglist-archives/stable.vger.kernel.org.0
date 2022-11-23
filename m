Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7443635838
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236479AbiKWJwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiKWJvW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:51:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED56A56EC0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:48:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB476B81E60
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0514C433C1;
        Wed, 23 Nov 2022 09:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196911;
        bh=6TDrox1pFcyPxL42kEX1fUpLGFpDOc7GVAip7FwfN6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9TOmVTxE/rlenV4qErxS57j0x3zf+KroQF1HIXoSqw0KYOWzaXcb1e7vKPjr9d8F
         8jXFhbvR12xK1Cl7N6o0Evjp9PAM/SzZVNUNcooqNJUEcF7rPoEcMDwuafUG81Sb+A
         wbvbe/QAhumiqchAsns5LaWb94iOTBKY9CSEVzrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiaolei Wang <xiaolei.wang@windriver.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 154/314] soc: imx8m: Enable OCOTP clock before reading the register
Date:   Wed, 23 Nov 2022 09:49:59 +0100
Message-Id: <20221123084632.548358688@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 836fb30949d9edf91d7de696a884ceeae7e426d2 ]

Commit 7d981405d0fd ("soc: imx8m: change to use platform driver") ever
removed the dependency on bootloader for enabling OCOTP clock.  It
helped to fix a kexec kernel hang issue.  But unfortunately it caused
a regression on CAAM driver and got reverted.

This is the second try to enable the OCOTP clock by directly calling
clock API instead of indirectly enabling the clock via nvmem API.

Fixes: ac34de14ac30 ("Revert "soc: imx8m: change to use platform driver"")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index cc57a384d74d..28144c699b0c 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -11,6 +11,7 @@
 #include <linux/platform_device.h>
 #include <linux/arm-smccc.h>
 #include <linux/of.h>
+#include <linux/clk.h>
 
 #define REV_B1				0x21
 
@@ -56,6 +57,7 @@ static u32 __init imx8mq_soc_revision(void)
 	void __iomem *ocotp_base;
 	u32 magic;
 	u32 rev;
+	struct clk *clk;
 
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mq-ocotp");
 	if (!np)
@@ -63,6 +65,13 @@ static u32 __init imx8mq_soc_revision(void)
 
 	ocotp_base = of_iomap(np, 0);
 	WARN_ON(!ocotp_base);
+	clk = of_clk_get_by_name(np, NULL);
+	if (!clk) {
+		WARN_ON(!clk);
+		return 0;
+	}
+
+	clk_prepare_enable(clk);
 
 	/*
 	 * SOC revision on older imx8mq is not available in fuses so query
@@ -79,6 +88,8 @@ static u32 __init imx8mq_soc_revision(void)
 	soc_uid <<= 32;
 	soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW);
 
+	clk_disable_unprepare(clk);
+	clk_put(clk);
 	iounmap(ocotp_base);
 	of_node_put(np);
 
-- 
2.35.1



