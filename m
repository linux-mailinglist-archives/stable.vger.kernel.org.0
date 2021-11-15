Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467F94522AC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349376AbhKPBPl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243268AbhKOTMp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:12:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34BEE63406;
        Mon, 15 Nov 2021 18:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000397;
        bh=bXPZUQ1+zJ2VrSu3sHGFXyCNvVpfRl8lMWzzj+ExAWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0u+YoHmj3+ZAVIirOPrMlt4qw2PuUNvIvx+WZ48of2CCfiNnnOQPJJi6yM/Y4KV08
         uhBM8sY1B0G7ZvqULqDL3ybp7MD5wH72PMyKtKn65E3AMk1FLVhwxekhGJF6AiAwF/
         oqvnLc7svhuVlUJqwoCrOG6GnLVimcR4SPMDfaF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 646/849] clk: at91: clk-master: fix prescaler logic
Date:   Mon, 15 Nov 2021 18:02:09 +0100
Message-Id: <20211115165442.124665890@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 0ef99f8202c5078a72c05af76bfaed2ea4daab19 ]

When prescaler value read from register is MASTER_PRES_MAX it means
that the input clock will be divided by 3. Fix the code to reflect
this.

Fixes: 7a110b9107ed8 ("clk: at91: clk-master: re-factor master clock")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20211011112719.3951784-11-claudiu.beznea@microchip.com
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/clk-master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-master.c b/drivers/clk/at91/clk-master.c
index 2e410815a3405..04d0dd8385945 100644
--- a/drivers/clk/at91/clk-master.c
+++ b/drivers/clk/at91/clk-master.c
@@ -309,7 +309,7 @@ static unsigned long clk_master_pres_recalc_rate(struct clk_hw *hw,
 	spin_unlock_irqrestore(master->lock, flags);
 
 	pres = (val >> master->layout->pres_shift) & MASTER_PRES_MASK;
-	if (pres == 3 && characteristics->have_div3_pres)
+	if (pres == MASTER_PRES_MAX && characteristics->have_div3_pres)
 		pres = 3;
 	else
 		pres = (1 << pres);
-- 
2.33.0



