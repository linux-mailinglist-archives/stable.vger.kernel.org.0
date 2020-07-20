Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A9D226612
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731954AbgGTQAE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:00:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732348AbgGTQAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:00:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D8EC22BEF;
        Mon, 20 Jul 2020 16:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260802;
        bh=GSGYs6BnJdboLJOwsvcqcct0UCOLTzlmL+V4yzMOjUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfIhsOCd+3Y+2hyYlXocWaR8hzC8dcZ1AXiYdWsHjpFQadi3ORIRCW50AAlo/t0Zi
         sglqcHFZySZtNZvCJT04bKIrDHhU8qDKPOFINCtr8j7O+/kWJAWEv2fe9j28RBINFa
         8awAbuwuOZrChvWcX4gI+SOHnJrFeC+9eJH5vXu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/215] ARM: at91: pm: add quirk for sam9x60s ulp1
Date:   Mon, 20 Jul 2020 17:35:53 +0200
Message-Id: <20200720152823.590075573@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit bb1a0e87e1c54cd884e9b92b1cec06b186edc7a0 ]

On SAM9X60 2 nop operations has to be introduced after setting
WAITMODE bit in CKGR_MOR.

Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/1579522208-19523-9-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm_suspend.S | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-at91/pm_suspend.S b/arch/arm/mach-at91/pm_suspend.S
index ed57c879d4e17..2591cba61937b 100644
--- a/arch/arm/mach-at91/pm_suspend.S
+++ b/arch/arm/mach-at91/pm_suspend.S
@@ -268,6 +268,10 @@ ENDPROC(at91_backup_mode)
 	orr	tmp1, tmp1, #AT91_PMC_KEY
 	str	tmp1, [pmc, #AT91_CKGR_MOR]
 
+	/* Quirk for SAM9X60's PMC */
+	nop
+	nop
+
 	wait_mckrdy
 
 	/* Enable the crystal oscillator */
-- 
2.25.1



