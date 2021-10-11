Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AEB428F28
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237695AbhJKNze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:55:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:41206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236622AbhJKNxo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:53:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1E6060EFE;
        Mon, 11 Oct 2021 13:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960297;
        bh=uwUIXGxiDLIDhQxOlH79AvyoGLWVLFei4bA9ZLBR03Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2f9BtEne5ac/Zm7mxIyH9l58G7isD6EcNRiwZJ603PE2h5W+Z+A9x+T5uXLJYLLkv
         5NZPgGB7YrNBOKi30Me8fxLN2CRjWbJkqyg4ODKsHK/nUF95jb1CQTgkH/fdQEBDbu
         yP84okE8A7SJ1K1XSZ+gvuAxkPYgVGNpR7Orpf3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/83] ARM: dts: qcom: apq8064: Use 27MHz PXO clock as DSI PLL reference
Date:   Mon, 11 Oct 2021 15:45:43 +0200
Message-Id: <20211011134509.160153585@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
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
index 01ea4590ffce..72c4a9fc41a2 100644
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
@@ -1305,7 +1305,7 @@
 			reg-names = "dsi_pll", "dsi_phy", "dsi_phy_regulator";
 			clock-names = "iface_clk", "ref";
 			clocks = <&mmcc DSI_M_AHB_CLK>,
-				 <&cxo_board>;
+				 <&pxo_board>;
 		};
 
 
-- 
2.33.0



