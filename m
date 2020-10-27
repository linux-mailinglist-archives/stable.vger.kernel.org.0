Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF02F29C1F6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1762323AbgJ0OmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762318AbgJ0OmC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:42:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1240C206B2;
        Tue, 27 Oct 2020 14:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809722;
        bh=OKAIbu6QMwSa3X0tAJb2vIAb7E8W8uEIv2BcFZV3nyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XpM+neHQsESxY9lpJSOCp9jrFOq+9Xk9uzAEXmnS/TxCyxICT7+DItUraRUmEPQoz
         J70Y9POCNs9iZuD8/fy43kknTaJHDS4pwaG+0+6t8FNLkti4xGUm8ywvQdEBl/6ZlG
         klkRF3O2I4jOCXZ26hXZdYJiGN0n/3HzatyOz2CE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 297/408] ARM: at91: pm: of_node_put() after its usage
Date:   Tue, 27 Oct 2020 14:53:55 +0100
Message-Id: <20201027135508.814459785@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit e222f943519564978e082c152b4140a47e93392c ]

Put node after it has been used.

Fixes: 13f16017d3e3f ("ARM: at91: pm: Tie the USB clock mask to the pmc")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/1596616610-15460-4-git-send-email-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 6bc3000deb86e..676cc2a318f41 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -777,6 +777,7 @@ static void __init at91_pm_init(void (*pm_idle)(void))
 
 	pmc_np = of_find_matching_node_and_match(NULL, atmel_pmc_ids, &of_id);
 	soc_pm.data.pmc = of_iomap(pmc_np, 0);
+	of_node_put(pmc_np);
 	if (!soc_pm.data.pmc) {
 		pr_err("AT91: PM not supported, PMC not found\n");
 		return;
-- 
2.25.1



