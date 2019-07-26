Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145F076AC5
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfGZNjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:39:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbfGZNjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:39:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E56022BF5;
        Fri, 26 Jul 2019 13:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148384;
        bh=Oyi0/Wy+f4G1n/pjU1LScDgWu7qW3oGB7u9NNM9cmZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=de8JOL0gE2z2QJNegMCRdOpVgDA11spTU8wWeVhcRey19zj8p/1CkXYpt0XVhQAn8
         RhHNk+1VqShCZv7V6O6zwK6WURJu9rg5KjWpL8MK5SHf31OGtRyaQ3t56tuotjvzvV
         xTVPLgXmBAml7aOjI5PItC3ZI3vMR/36vh1KCDnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niklas Cassel <niklas.cassel@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 07/85] arm64: dts: qcom: qcs404-evb: fix l3 min voltage
Date:   Fri, 26 Jul 2019 09:38:17 -0400
Message-Id: <20190726133936.11177-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@linaro.org>

[ Upstream commit 887b528c958f40b064d53edd0bfa9fea3a69eccd ]

The current l3 min voltage level is not supported by
the regulator (the voltage is not a multiple of the regulator step size),
so a driver requesting this exact voltage would fail, see discussion in:
https://patchwork.kernel.org/comment/22461199/

It was agreed upon to set a min voltage level that is a multiple of the
regulator step size.

There was actually a patch sent that did this:
https://patchwork.kernel.org/patch/10819313/

However, the commit 331ab98f8c4a ("arm64: dts: qcom: qcs404:
Fix voltages l3") that was applied is not identical to that patch.

Signed-off-by: Niklas Cassel <niklas.cassel@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <agross@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404-evb.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
index 2c3127167e3c..d987d6741e40 100644
--- a/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404-evb.dtsi
@@ -118,7 +118,7 @@
 		};
 
 		vreg_l3_1p05: l3 {
-			regulator-min-microvolt = <1050000>;
+			regulator-min-microvolt = <1048000>;
 			regulator-max-microvolt = <1160000>;
 		};
 
-- 
2.20.1

