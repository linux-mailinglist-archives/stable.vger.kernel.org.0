Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A38120DAE9
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgF2UBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:01:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387495AbgF2TkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91E222488A;
        Mon, 29 Jun 2020 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444386;
        bh=ke+E4ACwtF8UcIi+lq2rwLffvdLaAJALS7zP8w5TH0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJuDFe1KWYb4aKvcIgIrDT864y7laKSbQsTTFN015BBP6q+ZiUJ2dEcr3Pklvn6tc
         Y/oJiD5EZ2jdfIe0tFVooXJHPCtGj7xhsJhc7dOkeIlq9+u+GugjA1hNY+BK7O4SDq
         QCpx2th0poDq+Eyf8g0V9YEAu9gcCeSnSwdIHCIk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 063/178] ARM: OMAP2+: Fix legacy mode dss_reset
Date:   Mon, 29 Jun 2020 11:23:28 -0400
Message-Id: <20200629152523.2494198-64-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 77cad9dbc957f23a73169e8a8971186744296614 ]

We must check for "dss_core" instead of "dss" to avoid also matching
also "dss_dispc". This only matters for the mixed case of data
configured in device tree but with legacy booting ti,hwmods property
still enabled.

Fixes: 8b30919a4e3c ("ARM: OMAP2+: Handle reset quirks for dynamically allocated modules")
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/omap_hwmod.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 203664c40d3d2..eb74aa1826614 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -3535,7 +3535,7 @@ static const struct omap_hwmod_reset dra7_reset_quirks[] = {
 };
 
 static const struct omap_hwmod_reset omap_reset_quirks[] = {
-	{ .match = "dss", .len = 3, .reset = omap_dss_reset, },
+	{ .match = "dss_core", .len = 8, .reset = omap_dss_reset, },
 	{ .match = "hdq1w", .len = 5, .reset = omap_hdq1w_reset, },
 	{ .match = "i2c", .len = 3, .reset = omap_i2c_reset, },
 	{ .match = "wd_timer", .len = 8, .reset = omap2_wd_timer_reset, },
-- 
2.25.1

