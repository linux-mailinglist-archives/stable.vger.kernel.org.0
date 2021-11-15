Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC97451E0D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353453AbhKPAe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344494AbhKOTYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3B163496;
        Mon, 15 Nov 2021 18:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002720;
        bh=bXPZUQ1+zJ2VrSu3sHGFXyCNvVpfRl8lMWzzj+ExAWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ps2CliQAaXG/k3p0UGljwIB8fB141Q84/DAl5PWBFSpTK7vGuYjD7HFyX6YUVR/f7
         sdVsGITwzGKFHnrTKNMexv9ry+4lc0lys7iumPIy6/BZ+Vz8HuduSo0h8i53QRQRm4
         0PfFILqhGnlm8Ebh/h5FJ7S5OQLzDF6hwvnleOiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 673/917] clk: at91: clk-master: fix prescaler logic
Date:   Mon, 15 Nov 2021 18:02:48 +0100
Message-Id: <20211115165451.712443410@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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



