Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513132C0BA7
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729821AbgKWN2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:41214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbgKWMac (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:30:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C81520781;
        Mon, 23 Nov 2020 12:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134631;
        bh=jiXUb3dHuj6wF3mgnGob5udyk4xvwnvCnIdVrrxyCAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lx8H3oObPqNDoT3A5W4WKhnpQ5Er+laEhHfeeqaCVcrLmQD8AmI7qxE1h/jvYbSrr
         qvuMCclcDaz2Df8GS0UtEldqWrouOh2AvgAW/W0/XoAnzEN3ZM7VG+nTFU9yXNzCVI
         kPutJdhyv+AIwMYJ1i7Q7oi1fIFI+VZ8sFavLBys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianqun Xu <jay.xu@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kever Yang <kever.yang@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 27/91] pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq
Date:   Mon, 23 Nov 2020 13:21:47 +0100
Message-Id: <20201123121810.643571132@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
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
index 005df24f5b3f1..4d3b62707524a 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2778,7 +2778,9 @@ static int rockchip_gpio_to_irq(struct gpio_chip *gc, unsigned offset)
 	if (!bank->domain)
 		return -ENXIO;
 
+	clk_enable(bank->clk);
 	virq = irq_create_mapping(bank->domain, offset);
+	clk_disable(bank->clk);
 
 	return (virq) ? : -ENXIO;
 }
-- 
2.27.0



