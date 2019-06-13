Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1E1D43FE3
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfFMQBN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:01:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731446AbfFMIsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:48:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC117206BA;
        Thu, 13 Jun 2019 08:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415721;
        bh=rraj97k7zDYe9z8zD/fcg57TdIgNelm35EhWc+8XDKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HcIgBm/e1ZMrKZMkShijGGUTu/QQR19N5GI6m2zChmv278l9hLtrYJ+owL2EE2+vC
         M9GSYaGtcITkLOYCfOe2sdASJtzGdbicyin5vhtL6N6GaRI+HPxJystkhITNlRmDpz
         pkW1Ly+F9vXOirgvOsiTqbAm6qKsuxUJdu8UyKmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 103/155] soc: rockchip: Set the proper PWM for rk3288
Date:   Thu, 13 Jun 2019 10:33:35 +0200
Message-Id: <20190613075658.788889347@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
index 96882ffde67e..3b81e1d75a97 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -66,9 +66,11 @@ static const struct rockchip_grf_info rk3228_grf __initconst = {
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



