Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE3E15E78B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393774AbgBNQyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404836AbgBNQSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:18:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 345A824703;
        Fri, 14 Feb 2020 16:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697123;
        bh=POQBEBmj9YQfomHR0dXXKcpPqERbDd5yZUvqqBkcoNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6YO/MxqHQ2bjV8HFgttXlpubjVAunUkXNe5dwq6oa9ilLQ6vCZfE40V4UI31FaDg
         YvhG5/7OY0gCHIzUZd2p8zHTK5ZXWQJmJe/hkV25IZQb3/2dCT+8tbVR6j02DWc+aV
         fm1AiQtODdlqNuk3OPzrHh2GeOMi74wTahya4Llg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Manu Gautam <mgautam@codeaurora.org>,
        Paolo Pisati <p.pisati@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 068/186] arm64: dts: qcom: msm8996: Disable USB2 PHY suspend by core
Date:   Fri, 14 Feb 2020 11:15:17 -0500
Message-Id: <20200214161715.18113-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manu Gautam <mgautam@codeaurora.org>

[ Upstream commit d026c96b25b7ce5df89526aad2df988d553edb4d ]

QUSB2 PHY on msm8996 doesn't work well when autosuspend by
dwc3 core using USB2PHYCFG register is enabled. One of the
issue seen is that PHY driver reports PLL lock failure and
fails phy_init() if dwc3 core has USB2 PHY suspend enabled.
Fix this by using quirks to disable USB2 PHY LPM/suspend and
dwc3 core already takes care of explicitly suspending PHY
during suspend if quirks are specified.

Signed-off-by: Manu Gautam <mgautam@codeaurora.org>
Signed-off-by: Paolo Pisati <p.pisati@gmail.com>
Link: https://lore.kernel.org/r/20191209151501.26993-1-p.pisati@gmail.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 6f372ec055dd3..da2949586c7a3 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -788,6 +788,8 @@
 				interrupts = <0 138 0>;
 				phys = <&hsusb_phy2>;
 				phy-names = "usb2-phy";
+				snps,dis_u2_susphy_quirk;
+				snps,dis_enblslpm_quirk;
 			};
 		};
 
@@ -817,6 +819,8 @@
 				interrupts = <0 131 0>;
 				phys = <&hsusb_phy1>, <&ssusb_phy_0>;
 				phy-names = "usb2-phy", "usb3-phy";
+				snps,dis_u2_susphy_quirk;
+				snps,dis_enblslpm_quirk;
 			};
 		};
 	};
-- 
2.20.1

