Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7C4A6FA7
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbfICQeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:34:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731051AbfICQ2K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B13EE238C6;
        Tue,  3 Sep 2019 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528089;
        bh=zOEvKuP84iy7xxd7ym7VPI3TVVXP8RVt/WegrSzIvrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQW2UsDvYwmrtT8aFI3ULarBUAvxeaOr8Uip+82CaWcRrEfHSAHb8mWwg2jTSrvxD
         jvPsz8EtEHaKC/8pvxTBnY7CjF351RW8A89jsXNE6aYVzh+PcY7tUvE6kbAiQ4Iio6
         Fw2IijX6tiqDGKEVi1WkxTArJIW7xO+sKIRPXveA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 099/167] ARM: dts: qcom: ipq4019: Fix MSI IRQ type
Date:   Tue,  3 Sep 2019 12:24:11 -0400
Message-Id: <20190903162519.7136-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@linaro.org>

[ Upstream commit 97131f85c08e024df49480ed499aae8fb754067f ]

The databook clearly states that the MSI IRQ (msi_ctrl_int) is a level
triggered interrupt.

The msi_ctrl_int will be high for as long as any MSI status bit is set,
thus the IRQ type should be set to IRQ_TYPE_LEVEL_HIGH, causing the
IRQ handler to keep getting called, as long as any MSI status bit is set.

A git grep shows that ipq4019 is the only SoC using snps,dw-pcie that has
configured this IRQ incorrectly.

Not having the correct IRQ type defined will cause us to lose interrupts,
which in turn causes timeouts in the PCIe endpoint drivers.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq4019.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index 2c3168d95a2d5..814ab7283228a 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -389,7 +389,7 @@
 			ranges = <0x81000000 0 0x40200000 0x40200000 0 0x00100000
 				  0x82000000 0 0x40300000 0x40300000 0 0x400000>;
 
-			interrupts = <GIC_SPI 141 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
 			#interrupt-cells = <1>;
 			interrupt-map-mask = <0 0 0 0x7>;
-- 
2.20.1

