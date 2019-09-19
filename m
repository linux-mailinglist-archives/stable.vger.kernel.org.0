Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE370B843B
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393497AbfISWJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393461AbfISWJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A03C218AF;
        Thu, 19 Sep 2019 22:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930945;
        bh=2GL256L2/6vJG33uyRE6ssbbk6KXwoAxkQYI36Ywbvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5Du6DjrBYY5zQWENrYjVOwXkwCTKm3pkPQfW0W2KasooGsUKcsUiWuONs+TBlXs3
         p0Tx5sOCKQITHM+JRTEWrgnNx8qD5XBz1ykxRTXzDUEoeDEuDLSwE4fYuyo5mdZj7T
         B7PlDenQFpASViVEciYdCgdjuRkGltPglnySDg/s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 040/124] ARM: OMAP1: ams-delta-fiq: Fix missing irq_ack
Date:   Fri, 20 Sep 2019 00:02:08 +0200
Message-Id: <20190919214820.466235900@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 81159af44862e..14a6c3eb32985 100644
--- a/arch/arm/mach-omap1/ams-delta-fiq-handler.S
+++ b/arch/arm/mach-omap1/ams-delta-fiq-handler.S
@@ -126,6 +126,8 @@ restart:
 	orr r11, r11, r13			@ mask all requested interrupts
 	str r11, [r12, #OMAP1510_GPIO_INT_MASK]
 
+	str r13, [r12, #OMAP1510_GPIO_INT_STATUS] @ ack all requested interrupts
+
 	ands r10, r13, #KEYBRD_CLK_MASK		@ extract keyboard status - set?
 	beq hksw				@ no - try next source
 
@@ -133,7 +135,6 @@ restart:
 	@@@@@@@@@@@@@@@@@@@@@@
 	@ Keyboard clock FIQ mode interrupt handler
 	@ r10 now contains KEYBRD_CLK_MASK, use it
-	str r10, [r12, #OMAP1510_GPIO_INT_STATUS]	@ ack the interrupt
 	bic r11, r11, r10				@ unmask it
 	str r11, [r12, #OMAP1510_GPIO_INT_MASK]
 
diff --git a/arch/arm/mach-omap1/ams-delta-fiq.c b/arch/arm/mach-omap1/ams-delta-fiq.c
index 0af2bf6f99331..fd87382a3f183 100644
--- a/arch/arm/mach-omap1/ams-delta-fiq.c
+++ b/arch/arm/mach-omap1/ams-delta-fiq.c
@@ -69,9 +69,7 @@ static irqreturn_t deferred_fiq(int irq, void *dev_id)
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



