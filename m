Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F151674E6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387492AbgBUIS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387644AbgBUIS4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:18:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E21724689;
        Fri, 21 Feb 2020 08:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273136;
        bh=ZJorePCda0YcuQNvCo5Rl+Qv7CjHpuqxHxskctmSdTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8aAmsbvav4/LXtQyIk7iqkNC+69nVGJlqAwxXrV1TpbLhel8LIK1RD8QuEY0/8Yh
         cub9yATaKxHKmwE7K0+IKEB9Lqvev17K7z+DCM2pAdr+OdHh9eofPKjxYRg5pHjdKO
         8ZQV2gHRE0yu9ttkk9uwUTY3QJ+Wf5ukOSPFa21c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manu Gautam <mgautam@codeaurora.org>,
        Paolo Pisati <p.pisati@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/191] arm64: dts: qcom: msm8996: Disable USB2 PHY suspend by core
Date:   Fri, 21 Feb 2020 08:40:33 +0100
Message-Id: <20200221072258.650945363@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8c86c41a0d25f..3e7baabf64507 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -918,6 +918,8 @@
 				interrupts = <0 138 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&hsusb_phy2>;
 				phy-names = "usb2-phy";
+				snps,dis_u2_susphy_quirk;
+				snps,dis_enblslpm_quirk;
 			};
 		};
 
@@ -947,6 +949,8 @@
 				interrupts = <0 131 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&hsusb_phy1>, <&ssusb_phy_0>;
 				phy-names = "usb2-phy", "usb3-phy";
+				snps,dis_u2_susphy_quirk;
+				snps,dis_enblslpm_quirk;
 			};
 		};
 
-- 
2.20.1



