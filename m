Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697CE2B5FD8
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgKQM53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728625AbgKQM52 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD543246B3;
        Tue, 17 Nov 2020 12:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617847;
        bh=nSlSpaDNHRKZweh1WkMRoomRVitUFX3MT3jYGTWMGM4=;
        h=From:To:Cc:Subject:Date:From;
        b=rgDIMhm6074hLDUJIfG65tksW4Vu2NkHSRL2SoViR527pQkMFHkKfQFXLqC3VLNsH
         +rf8mEMMbaddJblprkVHAM6ACtVWTCg1gd2L3g/lV7ipjoRwMydla78KUITV08mRx1
         X/SmcBxP6bLq8f8H8FhmLyqxNy3XSvTGyGJ3g1NE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianqun Xu <jay.xu@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Kever Yang <kever.yang@rock-chips.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 01/11] pinctrl: rockchip: enable gpio pclk for rockchip_gpio_to_irq
Date:   Tue, 17 Nov 2020 07:57:15 -0500
Message-Id: <20201117125725.599833-1-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

