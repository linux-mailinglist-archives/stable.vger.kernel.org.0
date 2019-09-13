Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8E6B2031
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390122AbfIMNSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390142AbfIMNSC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:02 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00E14206BB;
        Fri, 13 Sep 2019 13:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380681;
        bh=27MRX826Pi+M9axRz0cHbmgXj6AyIpoE/Xg4HHm+8WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEF16Yh4Q2LaPccTSdZv5NXE27MH7DeXqKlAYDh99ol+l13P7kTNWs4gzDKwaGEvk
         DBanhgle0LZFg69iMUFYer9TsyQHVs2NGm+J45Py3AMaph75jMc5XrxPJhfrv8n71R
         /FHxrZbZrgFL+OfA23M8qKTe1pEg67ATSiismgaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 120/190] ARM: dts: qcom: ipq4019: Fix MSI IRQ type
Date:   Fri, 13 Sep 2019 14:06:15 +0100
Message-Id: <20190913130609.412047637@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



