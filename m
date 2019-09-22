Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15602BA5C0
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389238AbfIVSp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389230AbfIVSp0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BC82214AF;
        Sun, 22 Sep 2019 18:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177925;
        bh=JJNj1JIfEKumpLPmvbYYR+Yiy/6Lw903RFyWTOdYqXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAUNqdeGnHnuxk1NCwc+3kwPPMBMsvRZicL3pL18o9IfUIIjoMnSRHXRU4+QHuzff
         IcPLJi+LEn4ZXVGqLvLKlLQwVJUbbUuar24MS8x62h1LeHPwDGq8cmq89aqH1XDc28
         ZId6hwUyN6vEequ/hM+1V/9g74UaKgbuuEBn18J4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 037/203] arm64: dts: imx8mq: Correct OPP table according to latest datasheet
Date:   Sun, 22 Sep 2019 14:41:03 -0400
Message-Id: <20190922184350.30563-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 9eced3a2f224a62a233761e8af18c907c532e192 ]

According to latest datasheet (Rev.1, 10/2018) from below links,
in the consumer datasheet, 1.5GHz is mentioned as highest opp but
depends on speed grading fuse, and in the industrial datasheet,
1.3GHz is mentioned as highest opp but depends on speed grading
fuse. 1.5GHz and 1.3GHz opp use same voltage, so no need for
consumer part to support 1.3GHz opp, with same voltage, CPU should
run at highest frequency in order to go into idle as quick as
possible, this can save power.

That means for consumer part, 1GHz/1.5GHz are supported, for
industrial part, 800MHz/1.3GHz are supported, and then check the
speed grading fuse to limit the highest CPU frequency further.
Correct the market segment bits in opp table to make them work
according to datasheets.

https://www.nxp.com/docs/en/data-sheet/IMX8MDQLQIEC.pdf
https://www.nxp.com/docs/en/data-sheet/IMX8MDQLQCEC.pdf

Fixes: 12629c5c3749 ("arm64: dts: imx8mq: Add cpu speed grading and all OPPs")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index 52aae341d0da5..d1f4eb197af26 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -169,15 +169,14 @@
 		opp-1300000000 {
 			opp-hz = /bits/ 64 <1300000000>;
 			opp-microvolt = <1000000>;
-			opp-supported-hw = <0xc>, <0x7>;
+			opp-supported-hw = <0xc>, <0x4>;
 			clock-latency-ns = <150000>;
 		};
 
 		opp-1500000000 {
 			opp-hz = /bits/ 64 <1500000000>;
 			opp-microvolt = <1000000>;
-			/* Consumer only but rely on speed grading */
-			opp-supported-hw = <0x8>, <0x7>;
+			opp-supported-hw = <0x8>, <0x3>;
 			clock-latency-ns = <150000>;
 		};
 	};
-- 
2.20.1

