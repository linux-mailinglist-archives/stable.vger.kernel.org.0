Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370E1EA0CB
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfJ3PyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727486AbfJ3PyL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:54:11 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F9D21734;
        Wed, 30 Oct 2019 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450850;
        bh=OskzKgyekS9GSE+7yGkOwIcQl8F2JurHkstQr69ZI+o=;
        h=From:To:Cc:Subject:Date:From;
        b=CH2bQoS7PiHgVLFUHW2UzUpDvMgcR8DdPndHITxuO5x9DwFTBkMQ934s8MY/hgint
         iyG/RfPQkmBDqGKH1V0S5m5DVsdPA/FY7z/SA1CUh1xTt0xiS4qPh2mGgPECtrdUTS
         oXBez+EmMl+CC7TOIFsmxj4qSy7I96pGjvyNHqbA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 01/38] regulator: of: fix suspend-min/max-voltage parsing
Date:   Wed, 30 Oct 2019 11:53:29 -0400
Message-Id: <20191030155406.10109-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 131cb1210d4b58acb0695707dad2eb90dcb50a2a ]

Currently the regulator-suspend-min/max-microvolt must be within the
root regulator node but the dt-bindings specifies it as subnode
properties for the regulator-state-[mem/disk/standby] node. The only DT
using this bindings currently is the at91-sama5d2_xplained.dts and this
DT uses it correctly. I don't know if it isn't tested but it can't work
without this fix.

Fixes: f7efad10b5c4 ("regulator: add PM suspend and resume hooks")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Link: https://lore.kernel.org/r/20190917154021.14693-3-m.felsch@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/of_regulator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 210fc20f7de7a..b255590aef36e 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -214,12 +214,12 @@ static void of_get_regulation_constraints(struct device_node *np,
 					"regulator-off-in-suspend"))
 			suspend_state->enabled = DISABLE_IN_SUSPEND;
 
-		if (!of_property_read_u32(np, "regulator-suspend-min-microvolt",
-					  &pval))
+		if (!of_property_read_u32(suspend_np,
+				"regulator-suspend-min-microvolt", &pval))
 			suspend_state->min_uV = pval;
 
-		if (!of_property_read_u32(np, "regulator-suspend-max-microvolt",
-					  &pval))
+		if (!of_property_read_u32(suspend_np,
+				"regulator-suspend-max-microvolt", &pval))
 			suspend_state->max_uV = pval;
 
 		if (!of_property_read_u32(suspend_np,
-- 
2.20.1

