Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EC23E7E94
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbhHJReW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:34:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229649AbhHJRdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:33:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77A8861019;
        Tue, 10 Aug 2021 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628616802;
        bh=E349f0OlEBh8xcTlEdRFJx9D+TdKNo9hTQiGfDU067Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uFnP/ZdPxOtjPo86b75DV5NWt5f2Sz+DjRnyyG5ZNMKBbmwsaTW+ktWlHFwHGG5J9
         7OSo+35Xrurp8WfaFolLhvQJz0XQKGZSPuekt8l/h41tunDCP0j/wAftLcx83sn6gL
         w6U0ABEA6c/zAaGO5hxknwBzbAKhX/LMnqJ3gJiU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 54/54] ARM: imx: add mmdc ipg clock operation for mmdc
Date:   Tue, 10 Aug 2021 19:30:48 +0200
Message-Id: <20210810172945.984707951@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172944.179901509@linuxfoundation.org>
References: <20210810172944.179901509@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 9454a0caff6ac6d2a5ea17dd624dc13387bbfcd3 ]

i.MX6 SoCs have MMDC ipg clock for registers access, to make
sure MMDC registers access successfully, add optional clock
enable for MMDC driver.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-imx/mmdc.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index 1d340fda5e4f..ae0a61c61a6e 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -11,6 +11,7 @@
  * http://www.gnu.org/copyleft/gpl.html
  */
 
+#include <linux/clk.h>
 #include <linux/hrtimer.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -547,7 +548,20 @@ static int imx_mmdc_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	void __iomem *mmdc_base, *reg;
+	struct clk *mmdc_ipg_clk;
 	u32 val;
+	int err;
+
+	/* the ipg clock is optional */
+	mmdc_ipg_clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(mmdc_ipg_clk))
+		mmdc_ipg_clk = NULL;
+
+	err = clk_prepare_enable(mmdc_ipg_clk);
+	if (err) {
+		dev_err(&pdev->dev, "Unable to enable mmdc ipg clock.\n");
+		return err;
+	}
 
 	mmdc_base = of_iomap(np, 0);
 	WARN_ON(!mmdc_base);
-- 
2.30.2



