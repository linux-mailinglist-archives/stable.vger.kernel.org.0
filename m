Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7887F122034
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbfLQAw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:52:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35478 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727152AbfLQAvp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:45 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003ND-93; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005aQ-4u; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Reported-by: Marian Mihailescu" <mihailescu2m@gmail.com>,
        "Sylwester Nawrocki" <s.nawrocki@samsung.com>
Date:   Tue, 17 Dec 2019 00:47:06 +0000
Message-ID: <lsq.1576543535.482826178@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 092/136] clk: samsung: exynos5420: Preserve PLL
 configuration during suspend/resume
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit e9323b664ce29547d996195e8a6129a351c39108 upstream.

Properly save and restore all top PLL related configuration registers
during suspend/resume cycle. So far driver only handled EPLL and RPLL
clocks, all other were reset to default values after suspend/resume cycle.
This caused for example lower G3D (MALI Panfrost) performance after system
resume, even if performance governor has been selected.

Reported-by: Reported-by: Marian Mihailescu <mihailescu2m@gmail.com>
Fixes: 773424326b51 ("clk: samsung: exynos5420: add more registers to restore list")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/clk/samsung/clk-exynos5420.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -162,12 +162,18 @@ static unsigned long exynos5x_clk_regs[]
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

