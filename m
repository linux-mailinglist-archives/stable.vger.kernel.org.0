Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D8C28B6D3
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbgJLNiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:38:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:39316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730985AbgJLNh3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:37:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE0E22074F;
        Mon, 12 Oct 2020 13:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509837;
        bh=UHGZ4hUMmiCGvC+PBGaDBkqGgUCgsJ58/a3ZU0Tv/Hg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gql/jt7d8YkHVdUOcOkP2V0RmVksXMtajop1TJn1ztk843tefGx1aYra+QGTSG0hk
         /l7ujgPBymvAIJDVQAiK1gg4APJo2V92VrDqjrQa21JbXcgMJL3ET/ijxgnwQnpMAb
         D3yUY+Pb9ewAKFPUtVQ2hpa2Aa+3B99Qok1pliwI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/70] clk: samsung: exynos4: mark chipid clock as CLK_IGNORE_UNUSED
Date:   Mon, 12 Oct 2020 15:26:36 +0200
Message-Id: <20201012132631.198641384@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
References: <20201012132630.201442517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit f3bb0f796f5ffe32f0fbdce5b1b12eb85511158f ]

The ChipID IO region has it's own clock, which is being disabled while
scanning for unused clocks. It turned out that some CPU hotplug, CPU idle
or even SOC firmware code depends on the reads from that area. Fix the
mysterious hang caused by entering deep CPU idle state by ignoring the
'chipid' clock during unused clocks scan, as there are no direct clients
for it which will keep it enabled.

Fixes: e062b571777f ("clk: exynos4: register clocks using common clock framework")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20200922124046.10496-1-m.szyprowski@samsung.com
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
index 3d30262219275..2d269cc6a6688 100644
--- a/drivers/clk/samsung/clk-exynos4.c
+++ b/drivers/clk/samsung/clk-exynos4.c
@@ -1075,7 +1075,7 @@ static const struct samsung_gate_clock exynos4210_gate_clks[] __initconst = {
 	GATE(CLK_PCIE, "pcie", "aclk133", GATE_IP_FSYS, 14, 0, 0),
 	GATE(CLK_SMMU_PCIE, "smmu_pcie", "aclk133", GATE_IP_FSYS, 18, 0, 0),
 	GATE(CLK_MODEMIF, "modemif", "aclk100", GATE_IP_PERIL, 28, 0, 0),
-	GATE(CLK_CHIPID, "chipid", "aclk100", E4210_GATE_IP_PERIR, 0, 0, 0),
+	GATE(CLK_CHIPID, "chipid", "aclk100", E4210_GATE_IP_PERIR, 0, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SYSREG, "sysreg", "aclk100", E4210_GATE_IP_PERIR, 0,
 			CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_HDMI_CEC, "hdmi_cec", "aclk100", E4210_GATE_IP_PERIR, 11, 0,
@@ -1116,7 +1116,7 @@ static const struct samsung_gate_clock exynos4x12_gate_clks[] __initconst = {
 		0),
 	GATE(CLK_TSADC, "tsadc", "aclk133", E4X12_GATE_BUS_FSYS1, 16, 0, 0),
 	GATE(CLK_MIPI_HSI, "mipi_hsi", "aclk133", GATE_IP_FSYS, 10, 0, 0),
-	GATE(CLK_CHIPID, "chipid", "aclk100", E4X12_GATE_IP_PERIR, 0, 0, 0),
+	GATE(CLK_CHIPID, "chipid", "aclk100", E4X12_GATE_IP_PERIR, 0, CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_SYSREG, "sysreg", "aclk100", E4X12_GATE_IP_PERIR, 1,
 			CLK_IGNORE_UNUSED, 0),
 	GATE(CLK_HDMI_CEC, "hdmi_cec", "aclk100", E4X12_GATE_IP_PERIR, 11, 0,
-- 
2.25.1



