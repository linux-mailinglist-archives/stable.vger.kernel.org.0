Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF6814565D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgAVN0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:26:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbgAVN0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:26:21 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAFE2467B;
        Wed, 22 Jan 2020 13:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699581;
        bh=Q7t6sfTX9dJl8KPxGs9eW4J5qsuJ70qm/uUg4A9JZ0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7C+5VVmq8iVcLc3q7LFCmMeTk7w5twnavw8wmoPkPVb6ERg+CTcklSMPEfAoNX2O
         cDTnMHsDp9i5R4KQ6pQ3C4A7WArHY2S5tEquyw5xDT1oP0fORW4uFjnmDJbWBKIha6
         cVGReFpEiwythJ/TPIjmSZIByoYc419cMk3/uZYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shengjiu Wang <shengjiu.wang@nxp.com>,
        Daniel Baluta <daniel.baluta@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 185/222] arm64: dts: imx8mm-evk: Assigned clocks for audio plls
Date:   Wed, 22 Jan 2020 10:29:31 +0100
Message-Id: <20200122092846.933959096@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: S.j. Wang <shengjiu.wang@nxp.com>

commit e8b395b23643ca26e62a3081130d895e198c6154 upstream.

Assign clocks and clock-rates for audio plls, that audio
drivers can utilize them.

Add dai-tdm-slot-num and dai-tdm-slot-width for sound-wm8524,
that sai driver can generate correct bit clock.

Fixes: 13f3b9fdef6c ("arm64: dts: imx8mm-evk: Enable audio codec wm8524")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/freescale/imx8mm-evk.dts |    2 ++
 arch/arm64/boot/dts/freescale/imx8mm.dtsi    |    8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-evk.dts
@@ -62,6 +62,8 @@
 
 		cpudai: simple-audio-card,cpu {
 			sound-dai = <&sai3>;
+			dai-tdm-slot-num = <2>;
+			dai-tdm-slot-width = <32>;
 		};
 
 		simple-audio-card,codec {
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -479,14 +479,18 @@
 						<&clk IMX8MM_CLK_AUDIO_AHB>,
 						<&clk IMX8MM_CLK_IPG_AUDIO_ROOT>,
 						<&clk IMX8MM_SYS_PLL3>,
-						<&clk IMX8MM_VIDEO_PLL1>;
+						<&clk IMX8MM_VIDEO_PLL1>,
+						<&clk IMX8MM_AUDIO_PLL1>,
+						<&clk IMX8MM_AUDIO_PLL2>;
 				assigned-clock-parents = <&clk IMX8MM_SYS_PLL3_OUT>,
 							 <&clk IMX8MM_SYS_PLL1_800M>;
 				assigned-clock-rates = <0>,
 							<400000000>,
 							<400000000>,
 							<750000000>,
-							<594000000>;
+							<594000000>,
+							<393216000>,
+							<361267200>;
 			};
 
 			src: reset-controller@30390000 {


