Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2B0428E9C
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236347AbhJKNuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234772AbhJKNt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40BE2610C7;
        Mon, 11 Oct 2021 13:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960079;
        bh=TXJlpSPii02N3nlp6RYjJ43Bs+l7bJUwRGi6r+9IjIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzor7cI+V7fowpBU0cUrVENqFIFEo+cTK6dJSu3+jFKGY0G6nNbZnls2YxEKLhRF0
         VmZBoLI7ZwLm9ivhALTsj76bYg0bptSxdpNCYV+xrYEgYANU+YoH71eL2Z/WvCViAz
         PPAO/j3JR+4cfBsicHJ4e765/Vx5u8fpCw0V4jpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 16/52] ARM: dts: qcom: apq8064: Use 27MHz PXO clock as DSI PLL reference
Date:   Mon, 11 Oct 2021 15:45:45 +0200
Message-Id: <20211011134504.257847478@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit f1db21c315f4b4f8c3fbea56aac500673132d317 ]

The 28NM DSI PLL driver for msm8960 calculates with a 27MHz reference
clock and should hence use PXO, not CXO which runs at 19.2MHz.

Note that none of the DSI PHY/PLL drivers currently use this "ref"
clock; they all rely on (sometimes inexistant) global clock names and
usually function normally without a parent clock.  This discrepancy will
be corrected in a future patch, for which this change needs to be in
place first.

Fixes: 6969d1d9c615 ("ARM: dts: qcom-apq8064: Set 'cxo_board' as ref clock of the DSI PHY")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Link: https://lore.kernel.org/r/20210829203027.276143-2-marijn.suijten@somainline.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 27accc164df3..764984c95c68 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -198,7 +198,7 @@
 			clock-frequency = <19200000>;
 		};
 
-		pxo_board {
+		pxo_board: pxo_board {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <27000000>;
@@ -1304,7 +1304,7 @@
 			reg-names = "dsi_pll", "dsi_phy", "dsi_phy_regulator";
 			clock-names = "iface_clk", "ref";
 			clocks = <&mmcc DSI_M_AHB_CLK>,
-				 <&cxo_board>;
+				 <&pxo_board>;
 		};
 
 
-- 
2.33.0



