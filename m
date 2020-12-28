Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E6B2E416D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388727AbgL1OKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:44566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439014AbgL1OKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AFA2207B2;
        Mon, 28 Dec 2020 14:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164607;
        bh=nA7BVO8Yh1YrGNDD4Vvrfez7DOcgb9i2BKJgaCMdYT8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rwS6uuyGs+bf+GBA2nxh/mW4238bEG1elu9kfIFXiEa9BiO5UR74k5P613VLLIn4
         7rIQxf+Z6lWaZlDDQ0Zbk9XVOU46zbux1LUD1ZX+7YJYIb3aVmhRCOVKQK1WXC/R6P
         lTwkMgHsGATRVBd1htCqCPIfbFDNGTxWCyw4shoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/717] arm64: dts: ls1028a: fix ENETC PTP clock input
Date:   Mon, 28 Dec 2020 13:43:52 +0100
Message-Id: <20201228125032.199162790@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit d0570a575aa83116bd0f6a99c4de548af773d950 ]

On the LS1028A the ENETC reference clock is connected to 4th HWA output,
see Figure 7 "Clock subsystem block diagram".

The PHC may run with a wrong frequency. ptp_qoriq_auto_config() will read
the clock speed of the clock given in the device tree. It is likely that,
on the reference board this wasn't noticed because both clocks have the
same frequency. But this must not be always the case. Fix it.

Fixes: 49401003e260 ("arm64: dts: fsl: ls1028a: add ENETC 1588 timer node")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 7a6fb7e1fb82f..060b0d5c2669e 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -934,7 +934,7 @@
 			ethernet@0,4 {
 				compatible = "fsl,enetc-ptp";
 				reg = <0x000400 0 0 0 0>;
-				clocks = <&clockgen 4 0>;
+				clocks = <&clockgen 2 3>;
 				little-endian;
 				fsl,extts-fifo;
 			};
-- 
2.27.0



