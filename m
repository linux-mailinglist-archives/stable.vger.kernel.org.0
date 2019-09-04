Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C724CA8C4F
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfIDQMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732598AbfIDQAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 403E52087E;
        Wed,  4 Sep 2019 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612814;
        bh=qmsEjHrRZCpwx/XrFU4kSpvkC/FoRbT7gOt7GZYWx0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P4SQLB89Ymt5uVGjZohcPr0zvPO1MrlrnsYKYkxmd/OpuU3IYLlSXNH3abYEQawsX
         ijMHYurAIrrLdcHoptWrxP9gHBP4QK82UP9fdXMcIJNMMji7lOl0Ap1e1AHcx7bSK8
         D8iih6vy2VvurDqaXwu7fZU0X26Z0W9ozsTK5oVs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/52] ARM: OMAP2+: Fix omap4 errata warning on other SoCs
Date:   Wed,  4 Sep 2019 11:59:19 -0400
Message-Id: <20190904160004.3671-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
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
index b226c8aaf8b1c..7074cfd1ff413 100644
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

