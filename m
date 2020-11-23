Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68822C0B5F
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731505AbgKWNXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:23:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731475AbgKWMfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:35:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 578BA21D93;
        Mon, 23 Nov 2020 12:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134902;
        bh=nSlSpaDNHRKZweh1WkMRoomRVitUFX3MT3jYGTWMGM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcrXKoMN8BXOIRC2Hbb647IzzVIWh3L4d08D5h8qhCjUskC/h1tu32TrKm4rQ0MZz
         KCiVSKJj9mraO3CSWBbypD1SIEunqMtoXOHg00l7wCSK0V4ghHCkQycOTVFG0fB92b
         la1/uvhH9u/dH8E3czj1tQLUApfXirWFmp5l86do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianqun Xu <jay.xu@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kever Yang <kever.yang@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 034/158] pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq
Date:   Mon, 23 Nov 2020 13:21:02 +0100
Message-Id: <20201123121821.583145119@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianqun Xu <jay.xu@rock-chips.com>

[ Upstream commit 63fbf8013b2f6430754526ef9594f229c7219b1f ]

There need to enable pclk_gpio when do irq_create_mapping, since it will
do access to gpio controller.

Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Kever Yang<kever.yang@rock-chips.com>
Link: https://lore.kernel.org/r/20201013063731.3618-3-jay.xu@rock-chips.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-rockchip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 1bd8840e11a6e..930edfc32f597 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2811,7 +2811,9 @@ static int rockchip_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 	if (!bank->domain)
 		return -ENXIO;
 
+	clk_enable(bank->clk);
 	virq = irq_create_mapping(bank->domain, offset);
+	clk_disable(bank->clk);
 
 	return (virq) ? : -ENXIO;
 }
-- 
2.27.0



