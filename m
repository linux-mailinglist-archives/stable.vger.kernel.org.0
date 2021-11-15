Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59016451475
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349296AbhKOUGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:06:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344393AbhKOTYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E5AB63676;
        Mon, 15 Nov 2021 18:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002615;
        bh=p5LI70zC3eLsSDUT3/3qCC3J29Idy8LZRnUSlbVMpUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCpvfixcH9AYEuAY4sQ7D6xXOT91qNWFsUHFiEePvDci11m99FwQ8K2Z0wFge67J1
         OD42jEGpOBVgo2BMWtZckzdNl2myeny5BK0ejUrh/Svp4ybYTH/XwQ4Z8UttqCgx97
         Z8fthzISeKdJSrggt2CFXa3t0wE+1/Wig6qRhSn4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuogee Hsieh <khsieh@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 591/917] arm64: dts: qcom: sc7280: fix display port phy reg property
Date:   Mon, 15 Nov 2021 18:01:26 +0100
Message-Id: <20211115165448.802069365@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuogee Hsieh <khsieh@codeaurora.org>

[ Upstream commit 425f30cc843c727bc7753a0d33710d1e4a999168 ]

Existing display port phy reg property is derived from usb phy which
map display port phy pcs to wrong address which cause aux init
with wrong address and prevent both dpcd read and write from working.
Fix this problem by assigning correct pcs address to display port
phy reg property.

Fixes: bb9efa59c665 ("arm64: dts: qcom: sc7280: Add USB related nodes")
Signed-off-by: Kuogee Hsieh <khsieh@codeaurora.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1631216998-10049-1-git-send-email-khsieh@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index fd78f16181ddd..f58336536a92a 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1258,15 +1258,11 @@
 			dp_phy: dp-phy@88ea200 {
 				reg = <0 0x088ea200 0 0x200>,
 				      <0 0x088ea400 0 0x200>,
-				      <0 0x088eac00 0 0x400>,
+				      <0 0x088eaa00 0 0x200>,
 				      <0 0x088ea600 0 0x200>,
-				      <0 0x088ea800 0 0x200>,
-				      <0 0x088eaa00 0 0x100>;
+				      <0 0x088ea800 0 0x200>;
 				#phy-cells = <0>;
 				#clock-cells = <1>;
-				clocks = <&gcc GCC_USB3_PRIM_PHY_PIPE_CLK>;
-				clock-names = "pipe0";
-				clock-output-names = "usb3_phy_pipe_clk_src";
 			};
 		};
 
-- 
2.33.0



