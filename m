Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225B9689655
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbjBCK0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbjBCKZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45A99D587
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:25:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A044F61ECA
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795D5C433AE;
        Fri,  3 Feb 2023 10:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419943;
        bh=JJxOZ7bUBlyeM1DhtHhyLPVzDSmOjFPCdLBcrSiANaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tv5FDqd5vkkdAIrzkkXET+mJPpW/1XQGyw5Yjln7CPXfHQCstAyjSlQoW61aT7Ivf
         SNDthZS5Nn+UK8LSPKW41NFV3eV8cx8KPm/rKZsOrFzmJIS7gl2OI6/njOMJm6C78p
         1+gVm84LdXNX5GWRqthjzJIBjdFPIjql1HfwBCoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/134] ARM: imx35: Retrieve the IIM base address from devicetree
Date:   Fri,  3 Feb 2023 11:11:53 +0100
Message-Id: <20230203101024.223472888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit f68ea682d1da77e0133a7726640c22836a900a67 ]

Now that imx35 has been converted to a devicetree-only platform,
retrieve the IIM base address from devicetree.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 87b30c4b0efb ("ARM: imx: add missing of_node_put()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/cpu-imx35.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/cpu-imx35.c b/arch/arm/mach-imx/cpu-imx35.c
index ebb3cdabd506..80e7d8ab9f1b 100644
--- a/arch/arm/mach-imx/cpu-imx35.c
+++ b/arch/arm/mach-imx/cpu-imx35.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
  */
 #include <linux/module.h>
+#include <linux/of_address.h>
 #include <linux/io.h>
 
 #include "hardware.h"
@@ -14,9 +15,15 @@ static int mx35_cpu_rev = -1;
 
 static int mx35_read_cpu_rev(void)
 {
+	void __iomem *iim_base;
+	struct device_node *np;
 	u32 rev;
 
-	rev = imx_readl(MX35_IO_ADDRESS(MX35_IIM_BASE_ADDR + MXC_IIMSREV));
+	np = of_find_compatible_node(NULL, NULL, "fsl,imx35-iim");
+	iim_base = of_iomap(np, 0);
+	BUG_ON(!iim_base);
+
+	rev = imx_readl(iim_base + MXC_IIMSREV);
 	switch (rev) {
 	case 0x00:
 		return IMX_CHIP_REVISION_1_0;
-- 
2.39.0



