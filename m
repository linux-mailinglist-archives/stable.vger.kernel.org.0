Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 970E12FC803
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 03:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729685AbhATCbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:31:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:47344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730680AbhATB3B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:29:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DA3C23132;
        Wed, 20 Jan 2021 01:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611106047;
        bh=owIngL+z287/Db33e2oPnaB1cVU/Og2SEo74Yox/CZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qATTsf3CUlGFqOD3WhwiI6KEkT5LJ8+TePLhxnfA0cdwyCym3Wys2dhHo5uzjfxgr
         E4BQLnL8R1Wa4IddPeAJT1CBqRwgTscbgNq05sVNwcAVe8xMrU4aapkMr1KLRfnvfO
         zd7UEjQ84pmgictEkdUBbvWO2V6OoDP28JW+mVKymvANXgIa9KLyq1/MunMF6NJBb3
         muqvapx4OAtu2YHPcooHegWi/o/objNJNR7Ta5wdAyImJkM9lLBQw2nZoozqF+nkVA
         eiDVY21m7+IPqALwEHEEH5wzgZDI3i92c+r2I+k2mNpT6T7C0blehve9lPk9RS6Msq
         nVtIKYCFxzhlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sagar Shrikant Kadam <sagar.kadam@sifive.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 17/26] dts: phy: fix missing mdio device and probe failure of vsc8541-01 device
Date:   Tue, 19 Jan 2021 20:26:54 -0500
Message-Id: <20210120012704.770095-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012704.770095-1-sashal@kernel.org>
References: <20210120012704.770095-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagar Shrikant Kadam <sagar.kadam@sifive.com>

[ Upstream commit be969b7cfbcfa8a835a528f1dc467f0975c6d883 ]

HiFive unleashed A00 board has VSC8541-01 ethernet phy, this device is
identified as a Revision B device as described in device identification
registers. In order to use this phy in the unmanaged mode, it requires
a specific reset sequence of logical 0-1-0-1 transition on the NRESET pin
as documented here [1].

Currently, the bootloader (fsbl or u-boot-spl) takes care of the phy reset.
If due to some reason the phy device hasn't received the reset by the prior
stages before the linux macb driver comes into the picture, the MACB mii
bus gets probed but the mdio scan fails and is not even able to read the
phy ID registers. It gives an error message:

"libphy: MACB_mii_bus: probed
mdio_bus 10090000.ethernet-ffffffff: MDIO device at address 0 is missing."

Thus adding the device OUI (Organizationally Unique Identifier) to the phy
device node helps to probe the phy device.

[1]: VSC8541-01 datasheet:
https://www.mouser.com/ds/2/523/Microsemi_VSC8541-01_Datasheet_10496_V40-1148034.pdf

Signed-off-by: Sagar Shrikant Kadam <sagar.kadam@sifive.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
index 88cfcb96bf233..cc04e66752aac 100644
--- a/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unleashed-a00.dts
@@ -83,6 +83,7 @@ &eth0 {
 	phy-mode = "gmii";
 	phy-handle = <&phy0>;
 	phy0: ethernet-phy@0 {
+		compatible = "ethernet-phy-id0007.0771";
 		reg = <0>;
 	};
 };
-- 
2.27.0

