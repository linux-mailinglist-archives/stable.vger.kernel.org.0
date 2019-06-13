Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ECE44198
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732435AbfFMQPd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:15:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:58960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731171AbfFMIls (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:41:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16E9421479;
        Thu, 13 Jun 2019 08:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415307;
        bh=rraj97k7zDYe9z8zD/fcg57TdIgNelm35EhWc+8XDKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLwWWc6rDDl+la4+iLbm3gXcMsZ2FwKRqU97XYKFqMCKaQUpkfy2h3gR9ghz4v/S3
         ujJBb6NClCccZ5LQYou4UsGiI5FVAy67ZMDNqRLM8MxtQjunPRPxlCbqfpSLK/hTKK
         tpijoD5NRd3edp6jbYHj7GAqqUiFVe2DcIO+TXQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 079/118] soc: rockchip: Set the proper PWM for rk3288
Date:   Thu, 13 Jun 2019 10:33:37 +0200
Message-Id: <20190613075648.414597062@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
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



