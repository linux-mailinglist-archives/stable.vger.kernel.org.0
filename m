Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4841B689625
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbjBCK0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbjBCKZ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:25:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F7329E07
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:25:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C31BD61EC2
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C5EC433D2;
        Fri,  3 Feb 2023 10:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419941;
        bh=umkUf+5D1xScySsFuEDErZfzGsoQr1emY0Ux8g6f1+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNS55dfNzjv3Mkot9Hxe2IArg29KFcOm51neXXG0DwP8CNliIuM+ugPipKsVVTYyB
         89bASttulu+0+s07/N15F5G5DX3tPEIDfICL7++pQms7fJVyiAEo5/P3v311zn2XGn
         mZm5ImeYCx19PITdyhGzyg9lsETJcu1x9iWXWl+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fabio Estevam <festevam@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 007/134] ARM: imx31: Retrieve the IIM base address from devicetree
Date:   Fri,  3 Feb 2023 11:11:52 +0100
Message-Id: <20230203101024.183651231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 3172225d45bd918a5c4865e7cd8eb0c9d79f8530 ]

Now that imx31 has been converted to a devicetree-only platform,
retrieve the IIM base address from devicetree.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 87b30c4b0efb ("ARM: imx: add missing of_node_put()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/cpu-imx31.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/cpu-imx31.c b/arch/arm/mach-imx/cpu-imx31.c
index 3ee684b71006..b9c24b851d1a 100644
--- a/arch/arm/mach-imx/cpu-imx31.c
+++ b/arch/arm/mach-imx/cpu-imx31.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/of_address.h>
 #include <linux/io.h>
 
 #include "common.h"
@@ -32,10 +33,16 @@ static struct {
 
 static int mx31_read_cpu_rev(void)
 {
+	void __iomem *iim_base;
+	struct device_node *np;
 	u32 i, srev;
 
+	np = of_find_compatible_node(NULL, NULL, "fsl,imx31-iim");
+	iim_base = of_iomap(np, 0);
+	BUG_ON(!iim_base);
+
 	/* read SREV register from IIM module */
-	srev = imx_readl(MX31_IO_ADDRESS(MX31_IIM_BASE_ADDR + MXC_IIMSREV));
+	srev = imx_readl(iim_base + MXC_IIMSREV);
 	srev &= 0xff;
 
 	for (i = 0; i < ARRAY_SIZE(mx31_cpu_type); i++)
-- 
2.39.0



