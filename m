Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B841A8C49
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731742AbfIDQMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732625AbfIDQAR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:00:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 569652339E;
        Wed,  4 Sep 2019 16:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612817;
        bh=B68nc9OKkAQbmzyRHs40pHmAXAslMRrZ1Tb5cmtIk74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdILO6OPZRV591Sr8z3qhgW3DQm5zj9RTpSbWpSLkyyECdYrRDhE3E3yumwTs2T/k
         lGyvPyAUpRB3OQ0m4IxZQVzNLbKR1n5wziTLoh7FSouu4mqspIShoAbuh9L8I2Qgt7
         QzQvkJlFJSx6JN+zTRc40pvFkZgr7PEEMupjSlS8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/52] ARM: OMAP1: ams-delta-fiq: Fix missing irq_ack
Date:   Wed,  4 Sep 2019 11:59:21 -0400
Message-Id: <20190904160004.3671-9-sashal@kernel.org>
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

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit fa8397e45c64e60c80373bc19ee56e42a6bed9b6 ]

Non-serio path of Amstrad Delta FIQ deferred handler depended on
irq_ack() method provided by OMAP GPIO driver.  That method has been
removed by commit 693de831c6e5 ("gpio: omap: remove irq_ack method").
Remove useless code from the deferred handler and reimplement the
missing operation inside the base FIQ handler.

Should another dependency - irq_unmask() - be ever removed from the OMAP
GPIO driver, WARN once if missing.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap1/ams-delta-fiq-handler.S | 3 ++-
 arch/arm/mach-omap1/ams-delta-fiq.c         | 4 +---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap1/ams-delta-fiq-handler.S b/arch/arm/mach-omap1/ams-delta-fiq-handler.S
index ddc27638ba2a5..017c792be0a07 100644
--- a/arch/arm/mach-omap1/ams-delta-fiq-handler.S
+++ b/arch/arm/mach-omap1/ams-delta-fiq-handler.S
@@ -135,6 +135,8 @@ restart:
 	orr r11, r11, r13			@ mask all requested interrupts
 	str r11, [r12, #OMAP1510_GPIO_INT_MASK]
 
+	str r13, [r12, #OMAP1510_GPIO_INT_STATUS] @ ack all requested interrupts
+
 	ands r10, r13, #KEYBRD_CLK_MASK		@ extract keyboard status - set?
 	beq hksw				@ no - try next source
 
@@ -142,7 +144,6 @@ restart:
 	@@@@@@@@@@@@@@@@@@@@@@
 	@ Keyboard clock FIQ mode interrupt handler
 	@ r10 now contains KEYBRD_CLK_MASK, use it
-	str r10, [r12, #OMAP1510_GPIO_INT_STATUS]	@ ack the interrupt
 	bic r11, r11, r10				@ unmask it
 	str r11, [r12, #OMAP1510_GPIO_INT_MASK]
 
diff --git a/arch/arm/mach-omap1/ams-delta-fiq.c b/arch/arm/mach-omap1/ams-delta-fiq.c
index b0dc7ddf5877d..b8ba763fe1086 100644
--- a/arch/arm/mach-omap1/ams-delta-fiq.c
+++ b/arch/arm/mach-omap1/ams-delta-fiq.c
@@ -73,9 +73,7 @@ static irqreturn_t deferred_fiq(int irq, void *dev_id)
 			 * interrupts default to since commit 80ac93c27441
 			 * requires interrupt already acked and unmasked.
 			 */
-			if (irq_chip->irq_ack)
-				irq_chip->irq_ack(d);
-			if (irq_chip->irq_unmask)
+			if (!WARN_ON_ONCE(!irq_chip->irq_unmask))
 				irq_chip->irq_unmask(d);
 		}
 		for (; irq_counter[gpio] < fiq_count; irq_counter[gpio]++)
-- 
2.20.1

