Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E59E51134E5
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbfLDS0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:26:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:34580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728358AbfLDR67 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:58:59 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4641420863;
        Wed,  4 Dec 2019 17:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482338;
        bh=r7wqaF6k5AKKWznTAOwQ33pGuMlmJ/ecwfN0IvJdRUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LF1WPbnU7rirtLM8uoc1F3OaAel2ucuLPRDrJBXHkyvMgq015Q1W9SHjoh+Gdi+Kk
         lmLjcO8QZlopMqMkYp0pwA8UQvvIAj60fj23js9oo9ZCkKPFJHE5Q4Zr0De/cDnTFl
         CFhKykznCBy52sA4ddqcIlhd2jPlCDlcTRH45jAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Reported-by: Marian Mihailescu" <mihailescu2m@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/92] clk: samsung: exynos5420: Preserve PLL configuration during suspend/resume
Date:   Wed,  4 Dec 2019 18:49:03 +0100
Message-Id: <20191204174328.318163643@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit e9323b664ce29547d996195e8a6129a351c39108 ]

Properly save and restore all top PLL related configuration registers
during suspend/resume cycle. So far driver only handled EPLL and RPLL
clocks, all other were reset to default values after suspend/resume cycle.
This caused for example lower G3D (MALI Panfrost) performance after system
resume, even if performance governor has been selected.

Reported-by: Reported-by: Marian Mihailescu <mihailescu2m@gmail.com>
Fixes: 773424326b51 ("clk: samsung: exynos5420: add more registers to restore list")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos5420.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index bde71b07f15e7..c94de13ce3627 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -166,12 +166,18 @@ static unsigned long exynos5x_clk_regs[] __initdata = {
 	GATE_BUS_CPU,
 	GATE_SCLK_CPU,
 	CLKOUT_CMU_CPU,
+	CPLL_CON0,
+	DPLL_CON0,
 	EPLL_CON0,
 	EPLL_CON1,
 	EPLL_CON2,
 	RPLL_CON0,
 	RPLL_CON1,
 	RPLL_CON2,
+	IPLL_CON0,
+	SPLL_CON0,
+	VPLL_CON0,
+	MPLL_CON0,
 	SRC_TOP0,
 	SRC_TOP1,
 	SRC_TOP2,
-- 
2.20.1



