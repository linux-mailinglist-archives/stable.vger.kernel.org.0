Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F357404B5B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242332AbhIILvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:51:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243109AbhIILte (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:49:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F88D6124E;
        Thu,  9 Sep 2021 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187824;
        bh=JSuMEoCZLHXcZw9K4iVZHo9WxIsZ7wd55+BApHU8Nvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cv30qX+px2iP+cT6+XBJu7TIwFlCYlQbeA/fu60m0tbOyjxNI4yQRDV/YjIhHpzkj
         gYHs8gDzVNV3V0/W36IAZckqTbJrg3fZOsADuM7ddepsWACvJ0wrOIlwjJLa6z1e/t
         ZKXOekyjZsL40YN3hGRhKWyIgbqXveyP5s4VTtUSo5CN3tB2HTNk7Fqsuc3bnelGxt
         CYHd3LHfJdOBTWY8Tp/X6EBt4bzywggys12TycNgZq/GGCPsuyEebglwQ/01WgxCms
         pwS2qG+95RHvCr2R/N11LVRUUgMp97frie3hdYF4TlDV1SwmooVOdqwslVxsPB2/mD
         KwGvmfSz2i+pQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinod Koul <vkoul@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 122/252] arm64: dts: qcom: msm8994: don't use underscore in node name
Date:   Thu,  9 Sep 2021 07:38:56 -0400
Message-Id: <20210909114106.141462-122-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 8c678beca7ed3fa8a2c6d86f6603bc23400f9ad8 ]

We have underscore (_) in node name leading to warning:
arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon-cityman.dt.yaml: clocks: xo_board: {'type': 'object'} is not allowed for {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[19200000]], 'phandle': [[26]]}
arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon-cityman.dt.yaml: clocks: sleep_clk: {'type': 'object'} is not allowed for {'compatible': ['fixed-clock'], '#clock-cells': [[0]], 'clock-frequency': [[32768]]}

Fix this by changing node name to use dash (-)

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210308060826.3074234-9-vkoul@kernel.org
[bjorn: Added clock-output-names to satisfy parent_names]
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index f9f0b5aa6a26..87a3217e88ef 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -15,16 +15,18 @@ / {
 	chosen { };
 
 	clocks {
-		xo_board: xo_board {
+		xo_board: xo-board {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <19200000>;
+			clock-output-names = "xo_board";
 		};
 
-		sleep_clk: sleep_clk {
+		sleep_clk: sleep-clk {
 			compatible = "fixed-clock";
 			#clock-cells = <0>;
 			clock-frequency = <32768>;
+			clock-output-names = "sleep_clk";
 		};
 	};
 
-- 
2.30.2

