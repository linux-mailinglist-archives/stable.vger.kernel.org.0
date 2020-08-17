Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346882471DE
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390887AbgHQSex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:47142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730991AbgHQP7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:59:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D321A206FA;
        Mon, 17 Aug 2020 15:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679990;
        bh=9Wfo/T5nRMTrgQs2EpSoH9Fb8QXefxTIJ/cvjSqMFsg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+82carvd4elV1M+bo5IgUFLmEA9PtO/UKmuOGTyom9Cbs01NyQP9LwMHYcvm7G3n
         V0ov5SfxZZwrrldFO9wUJooq2D/6aufaYrFwqA4qIgBqFi5RHpgQpfXW/bisUejsQS
         VFjIhkCzjjRMsYqwoJzp428Fcz/7HvFDNXWllWXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heiko Stuebner <heiko.stuebner@theobroma-systems.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/270] arm64: dts: rockchip: fix rk3399-puma gmac reset gpio
Date:   Mon, 17 Aug 2020 17:13:32 +0200
Message-Id: <20200817143756.372058371@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>

[ Upstream commit 8a445086f8af0b7b9bd8d1901d6f306bb154f70d ]

The puma gmac node currently uses opposite active-values for the
gmac phy reset pin. The gpio-declaration uses active-high while the
separate snps,reset-active-low property marks the pin as active low.

While on the kernel side this works ok, other DT users may get
confused - as seen with uboot right now.

So bring this in line and make both properties match, similar to the
other Rockchip board.

Fixes: 2c66fc34e945 ("arm64: dts: rockchip: add RK3399-Q7 (Puma) SoM")
Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
Link: https://lore.kernel.org/r/20200603132836.362519-1-heiko@sntech.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
index fb47e4046f4e4..45b86933c6ea0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-puma.dtsi
@@ -157,7 +157,7 @@ &gmac {
 	phy-mode = "rgmii";
 	pinctrl-names = "default";
 	pinctrl-0 = <&rgmii_pins>;
-	snps,reset-gpio = <&gpio3 RK_PC0 GPIO_ACTIVE_HIGH>;
+	snps,reset-gpio = <&gpio3 RK_PC0 GPIO_ACTIVE_LOW>;
 	snps,reset-active-low;
 	snps,reset-delays-us = <0 10000 50000>;
 	tx_delay = <0x10>;
-- 
2.25.1



