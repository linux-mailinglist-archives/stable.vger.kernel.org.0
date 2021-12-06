Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45B0469ABF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346975AbhLFPJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:09:51 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40904 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346114AbhLFPHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:07:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C910B8111D;
        Mon,  6 Dec 2021 15:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919DDC341D8;
        Mon,  6 Dec 2021 15:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803062;
        bh=hkam3F7NZ3IfoR2Ceszi9aCVAxg108DljbPsai7NXI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRVqZnq3WbW6YCvKMy5Z1whnkMUcIvLV9jKxV2/ckgczaAScmjk9aN00l+QXOwNlV
         Vh3g6zF7YWPkSs9SzmCpU8zyAzBJcsPf6s44pWc53tMWlUQJxmJFKYIIqud+ZuBdeJ
         1yHA1Dt4OtPkKXKS0Dhbdci2GZha1012IHKlBktg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 015/106] ARM: dts: BCM5301X: Fix I2C controller interrupt
Date:   Mon,  6 Dec 2021 15:55:23 +0100
Message-Id: <20211206145555.912158983@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
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
index 165fd1c1461a0..01a4935598915 100644
--- a/arch/arm/boot/dts/bcm5301x.dtsi
+++ b/arch/arm/boot/dts/bcm5301x.dtsi
@@ -365,7 +365,7 @@ mdio: mdio@18003000 {
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



