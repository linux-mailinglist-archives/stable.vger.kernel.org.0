Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 705E1E9FBC
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 16:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbfJ3Pv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 11:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbfJ3Pv1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:51:27 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74C06208C0;
        Wed, 30 Oct 2019 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450686;
        bh=Jcb41jK/gNTOcohgptRyqBDiCEXmFksh7t2MhPz/fk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMRBS3LFbJsx2GZwh1IkIuNYtVwBWNjmA8TLDfo+umrZ5//lsyLd6e4Kilwkrx1Fw
         dZHV0D22BNNn//xXX+xR0iibX2gY6EA+I7PetQQV2FIt9RbaM083UDU7eJCQpGzDtH
         qvhfj1tSU7E5ptXm1H2MX0rwEZ38kACyPvoUGSgU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Soeren Moch <smoch@web.de>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 25/81] arm64: dts: rockchip: fix RockPro64 vdd-log regulator settings
Date:   Wed, 30 Oct 2019 11:48:31 -0400
Message-Id: <20191030154928.9432-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030154928.9432-1-sashal@kernel.org>
References: <20191030154928.9432-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soeren Moch <smoch@web.de>

[ Upstream commit 0990c5e7573098117c69651821647c228483e31b ]

The RockPro64 schematic [1] page 18 states a min voltage of 0.8V and a
max voltage of 1.4V for the VDD_LOG pwm regulator. However, there is an
additional note that the pwm parameter needs to be modified.
From the schematics a voltage range of 0.8V to 1.7V can be calculated.
Additional voltage measurements on the board show that this fix indeed
leads to the correct voltage, while without this fix the voltage was set
too high.

[1] http://files.pine64.org/doc/rockpro64/rockpro64_v21-SCH.pdf

Fixes: e4f3fb490967 ("arm64: dts: rockchip: add initial dts support for Rockpro64")
Signed-off-by: Soeren Moch <smoch@web.de>
Link: https://lore.kernel.org/r/20191003215036.15023-1-smoch@web.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
index 5818b85255123..cad314f708300 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dts
@@ -166,7 +166,7 @@
 		regulator-always-on;
 		regulator-boot-on;
 		regulator-min-microvolt = <800000>;
-		regulator-max-microvolt = <1400000>;
+		regulator-max-microvolt = <1700000>;
 		vin-supply = <&vcc5v0_sys>;
 	};
 };
-- 
2.20.1

