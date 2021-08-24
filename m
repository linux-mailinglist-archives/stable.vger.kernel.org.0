Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294E13F64E0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbhHXRIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239148AbhHXRGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:06:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F2E061872;
        Tue, 24 Aug 2021 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824385;
        bh=R20MJkCvNDWoB6Txrd+4Vm+099DN+zjiff9v6Im/sRM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KSM5zNZJfFgmwN5+UjB3HXDMWzeOazSLUYmicsH3ehvpFkq4yMDsUh/uWcPHtrLX4
         s4+OkXhV/lbilf+9ITda42+J/1Ug+ZUrIo5GVKbllA+gpiGbFaMXQL/52MzKbqSAV4
         DdLlQQeD26bgqCbSDCdVN2+SykMNk3VbldehWULQDcbfzPrFf9yJ7Thkq1APCCviiy
         N+hyKzqghn2gX21hro9NfHsftsWZ07U4AVsqiJ+iOas4P4SOoqu+hYZxCIUHaOd0ri
         TDYiMtIzOOA/6caJ8QZZFTbAb7BUBKYCkjBnDtoyQnhGx2QNlP1qEDBZesTt2tgboA
         18RxdpRFeo1fQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 35/98] arm64: dts: qcom: c630: fix correct powerdown pin for WSA881x
Date:   Tue, 24 Aug 2021 12:58:05 -0400
Message-Id: <20210824165908.709932-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit 9a253bb42f190efd1a1c156939ad7298b3529dca ]

WSA881x powerdown pin is connected to GPIO1, GPIO2 not GPIO2 and GPIO3,
so correct this. This was working so far due to a shift bug in gpio driver,
however once that is fixed this will stop working, so fix this!

For some reason we forgot to add this dts change in last merge cycle so
currently audio is broken in 5.13 as the gpio driver fix already landed
in 5.13.

Reported-by: Shawn Guo <shawnguo@kernel.org>
Fixes: 45021d35fcb2 ("arm64: dts: qcom: c630: Enable audio support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Shawn Guo <shawnguo@kernel.org>
Link: https://lore.kernel.org/r/20210706083523.10601-1-srinivas.kandagatla@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 888dc23a530e..ad6561843ba2 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -564,7 +564,7 @@
 		left_spkr: wsa8810-left{
 			compatible = "sdw10217211000";
 			reg = <0 3>;
-			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
+			powerdown-gpios = <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
 			#thermal-sensor-cells = <0>;
 			sound-name-prefix = "SpkrLeft";
 			#sound-dai-cells = <0>;
@@ -572,7 +572,7 @@
 
 		right_spkr: wsa8810-right{
 			compatible = "sdw10217211000";
-			powerdown-gpios = <&wcdgpio 3 GPIO_ACTIVE_HIGH>;
+			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
 			reg = <0 4>;
 			#thermal-sensor-cells = <0>;
 			sound-name-prefix = "SpkrRight";
-- 
2.30.2

