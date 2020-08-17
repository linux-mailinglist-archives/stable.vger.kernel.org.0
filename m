Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB52C24779F
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732692AbgHQTvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgHQPSq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:18:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 827DE206FA;
        Mon, 17 Aug 2020 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677526;
        bh=aYFQSt6KXZxgKtvmLhTIs84s0J4Db4P+g7kKUrTJG78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bKOjZ3sG1TBYEUE2a/gc5U/qrBwoV5erPHPEZCcZyQP5/YbYeKkAFOulcuPMn1Sh8
         hs2pSAOBo15Ea60rHOKV5Jv0HOMYEo1UDbsPsFP0A7VQ37hYvq7AO9wrYYKqEa6+Lp
         906mTXRsoIOc1ftqLG8192lXeqmOxOMGjhdPp3BM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 015/464] arm64: dts: rockchip: fix rk3399-puma vcc5v0-host gpio
Date:   Mon, 17 Aug 2020 17:09:28 +0200
Message-Id: <20200817143834.486624183@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

[ Upstream commit 7a7184f6cfa9279f1a1c10a1845d247d7fad54ff ]

The puma vcc5v0_host regulator node currently uses opposite active-values
for the enable pin. The gpio-declaration uses active-high while the
separate enable-active-low property marks the pin as active low.

While on the kernel side this works ok, other DT users may get
confused - as seen with uboot right now.

So bring this in line and make both properties match, similar to the
gmac fix.

Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Link: https://lore.kernel.org/r/20200604091239.424318-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index 07694b196fdbe..063f59a420b65 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -101,7 +101,7 @@ vcc3v3_sys: vcc3v3-sys {
 
 	vcc5v0_host: vcc5v0-host-regulator {
 		compatible = "regulator-fixed";
-		gpio = <&gpio4 RK_PA3 GPIO_ACTIVE_HIGH>;
+		gpio = <&gpio4 RK_PA3 GPIO_ACTIVE_LOW>;
 		enable-active-low;
 		pinctrl-names = "default";
 		pinctrl-0 = <&vcc5v0_host_en>;
-- 
2.25.1



