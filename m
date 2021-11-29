Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5313A462708
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbhK2XAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbhK2W77 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:59:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1213C1A0D3B;
        Mon, 29 Nov 2021 10:36:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE04ACE167C;
        Mon, 29 Nov 2021 18:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B46DC53FAD;
        Mon, 29 Nov 2021 18:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211005;
        bh=DZEcyCzzjQcbzjwkOX2pM4OIHwwP8oL3ciGgribPy2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uuo5zLm+PWh/uzx2OXeHmFJhpbvlKq8SEkZI8ystL8ifrhc8LePPo8jqlrOPptMRu
         5b13z0XDDoXkchZvBPsNaqrumIEfAU0FEgkJRIZci2FPTOKfW/KEnECyiVtWWGiZ6l
         9LdYEhBapGQtoSDaLrh+O3LNLvx2n7tSN6qgwdI8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 071/179] ARM: dts: BCM5301X: Fix I2C controller interrupt
Date:   Mon, 29 Nov 2021 19:17:45 +0100
Message-Id: <20211129181721.287516869@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 754c4050a00e802e122690112fc2c3a6abafa7e2 ]

The I2C interrupt controller line is off by 32 because the datasheet
describes interrupt inputs into the GIC which are for Shared Peripheral
Interrupts and are starting at offset 32. The ARM GIC binding expects
the SPI interrupts to be numbered from 0 relative to the SPI base.

Fixes: bb097e3e0045 ("ARM: dts: BCM5301X: Add I2C support to the DT")
Tested-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm5301x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm5301x.dtsi b/arch/arm/boot/dts/bcm5301x.dtsi
index d4f355015e3ca..437a2b0f68de3 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -408,7 +408,7 @@ uart2: serial@18008000 {
 	i2c0: i2c@18009000 {
 		compatible = "brcm,iproc-i2c";
 		reg = <0x18009000 0x50>;
-		interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
 		#address-cells = <1>;
 		#size-cells = <0>;
 		clock-frequency = <100000>;
-- 
2.33.0



