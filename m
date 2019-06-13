Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C75442BD
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392169AbfFMQZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730979AbfFMIgn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:36:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA42D20851;
        Thu, 13 Jun 2019 08:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415003;
        bh=Qp5Wd0ROX/RHBmbhi3RKPN5/Lw9BqNZEdXAlSwvVVNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2alHauzqkANmJO2yEZ3R4cUhtiJxwFrEJDQzuaqz7YA/F02xJlm6nXybEAeTfqlv
         rmNdN4aWIJIgUt8h4MCg0f97wK2hHJz9NFudvmkbzAhu/+0HUehwVcvCVFGIsqcz8D
         c9NaOU4PjBhkA6tddTBoGvS23hQ0NXtsUtJURmUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/81] soc: rockchip: Set the proper PWM for rk3288
Date:   Thu, 13 Jun 2019 10:33:34 +0200
Message-Id: <20190613075653.003195266@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit bbdc00a7de24cc90315b1775fb74841373fe12f7 ]

The rk3288 SoC has two PWM implementations available, the "old"
implementation and the "new" one.  You can switch between the two of
them by flipping a bit in the grf.

The "old" implementation is the default at chip power up but isn't the
one that's officially supposed to be used.  ...and, in fact, the
driver that gets selected in Linux using the rk3288 device tree only
supports the "new" implementation.

Long ago I tried to get a switch to the right IP block landed in the
PWM driver (search for "rk3288: Switch to use the proper PWM IP") but
that got rejected.  In the mean time the grf has grown a full-fledged
driver that already sets other random bits like this.  That means we
can now get the fix landed.

For those wondering how things could have possibly worked for the last
4.5 years, folks have mostly been relying on the bootloader to set
this bit.  ...but occasionally folks have pointed back to my old patch
series [1] in downstream kernels.

[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1391597.html

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/rockchip/grf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soc/rockchip/grf.c b/drivers/soc/rockchip/grf.c
index 15e71fd6c513..0931ddb0b384 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -44,9 +44,11 @@ static const struct rockchip_grf_info rk3036_grf __initconst = {
 };
 
 #define RK3288_GRF_SOC_CON0		0x244
+#define RK3288_GRF_SOC_CON2		0x24c
 
 static const struct rockchip_grf_value rk3288_defaults[] __initconst = {
 	{ "jtag switching", RK3288_GRF_SOC_CON0, HIWORD_UPDATE(0, 1, 12) },
+	{ "pwm select", RK3288_GRF_SOC_CON2, HIWORD_UPDATE(1, 1, 0) },
 };
 
 static const struct rockchip_grf_info rk3288_grf __initconst = {
-- 
2.20.1



