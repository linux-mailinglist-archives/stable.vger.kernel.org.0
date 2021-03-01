Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D55328A80
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbhCASSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:18:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239321AbhCASLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:11:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C6B9600CC;
        Mon,  1 Mar 2021 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620420;
        bh=ebgnygRSKBRXEcSxpmbi3622tX9DgkoVsdG2xmbVrqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odxSwz0XBC+82yjVKXf2hivVmxD+A/lFxvt9IWRjiZVzbqwHWCscGq5L9jAOwI3Bx
         7Twlbs7Qh4u6htGmrUEjU8jVjIhwHu0t+IHW2owPrZCirscQu9I09uLgYBYZsbNFxA
         N/gd0gqtCgqaxR/6zxQhzxPFqgi/yZREilKrWWwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Veerabhadrarao Badiganti <vbadigan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 147/775] arm64: dts: qcom: qrb5165-rb5: fix uSD pins drive strength
Date:   Mon,  1 Mar 2021 17:05:15 +0100
Message-Id: <20210301161208.914506451@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit abf2c58aaa776cf43daf0fc4fd20082c71583c6b ]

Lower drive strength for microSD data and CMD pins from 16 to 10. This
fixes spurious card removal issues observed on some boards. Also this
change allows us to re-enable 1.8V support, which seems to work with
lowered drive strength.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
Fixes: 53a8ccf1c7e5 ("arm64: dts: qcom: rb5: Add support for uSD card")
Link: https://lore.kernel.org/r/20201217183341.3186402-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index ce22d4fa383e6..f86cc5140d3b9 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -491,8 +491,6 @@
 	vqmmc-supply = <&vreg_l6c_2p96>;
 	cd-gpios = <&tlmm 77 GPIO_ACTIVE_LOW>;
 	bus-width = <4>;
-	/* there seem to be issues with HS400-1.8V mode, so disable it */
-	no-1-8-v;
 	no-sdio;
 	no-emmc;
 };
@@ -706,13 +704,13 @@
 		cmd {
 			pins = "sdc2_cmd";
 			bias-pull-up;
-			drive-strength = <16>;
+			drive-strength = <10>;
 		};
 
 		data {
 			pins = "sdc2_data";
 			bias-pull-up;
-			drive-strength = <16>;
+			drive-strength = <10>;
 		};
 	};
 
-- 
2.27.0



