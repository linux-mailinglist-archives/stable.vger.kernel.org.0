Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0677A8B79
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732927AbfIDQDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732460AbfIDQDG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:03:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B293422CF5;
        Wed,  4 Sep 2019 16:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612986;
        bh=j1iYY3kQO3B/s0ayC98GlO6pXuKeFJHAECORyA+XmSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1AP0bcLQOs7vySkGD/8wdoaDzoCcjVPSvGU1J66tiE2jk22sudesp4TOvrBber5YF
         4scpRoujloahihmvpQw2MuQhVA1s1xJO8Sku65MupsOsSw0/zW+x+MCc+dviZyW/+3
         boBlmD4goyJcQ30IksLwueCAc4q1LaeKgy25IOSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/20] ARM: OMAP2+: Fix omap4 errata warning on other SoCs
Date:   Wed,  4 Sep 2019 12:02:45 -0400
Message-Id: <20190904160303.5062-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160303.5062-1-sashal@kernel.org>
References: <20190904160303.5062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 45da5e09dd32fa98c32eaafe2513db6bd75e2f4f ]

We have errata i688 workaround produce warnings on SoCs other than
omap4 and omap5:

omap4_sram_init:Unable to allocate sram needed to handle errata I688
omap4_sram_init:Unable to get sram pool needed to handle errata I688

This is happening because there is no ti,omap4-mpu node, or no SRAM
to configure for the other SoCs, so let's remove the warning based
on the SoC revision checks.

As nobody has complained it seems that the other SoC variants do not
need this workaround.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap4-common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 949696b6f17b6..511fd08c784ba 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -131,6 +131,9 @@ static int __init omap4_sram_init(void)
 	struct device_node *np;
 	struct gen_pool *sram_pool;
 
+	if (!soc_is_omap44xx() && !soc_is_omap54xx())
+		return 0;
+
 	np = of_find_compatible_node(NULL, NULL, "ti,omap4-mpu");
 	if (!np)
 		pr_warn("%s:Unable to allocate sram needed to handle errata I688\n",
-- 
2.20.1

