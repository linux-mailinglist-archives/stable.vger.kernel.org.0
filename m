Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2163D3F63A7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhHXQ5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234541AbhHXQ5T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:57:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D578861357;
        Tue, 24 Aug 2021 16:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824195;
        bh=NAahadXB7XFnLvJQTmTJsYf7xYIcyKAYCwJbYnA81rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMB8zVdPEnuSF8BBt520dCunzDnJ/htbMD4OiZ7lEa7QJGzmtjTyy+Ncd4hT0x3yH
         kixMAFb+Zdrg4KibifJ/uq47Y2xNCjGNUJH8rUmlBrDMzHXoyPpZ4S1uP7bNIX9Umr
         GpOfjZihshIBiJF/DJvF2gG/LnbcjFqVEYUnk3tvwkhi1jO2JeQRhKhe17uej6X4aC
         ZyXcm/4HHUkvuBRi+wipvBFUcY8247DxQqt7H5VVpXAz6WW58B1mTJQi2LlLd2LetU
         Fhf4Ant4dMt1GKQnCpNw2FibvNQC7zZgJE4OL/0EiHKBjZcj3JoI+PlO0gH3z0F4z2
         LpbUYcgYR5AFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 027/127] arm64: dts: qcom: c630: fix correct powerdown pin for WSA881x
Date:   Tue, 24 Aug 2021 12:54:27 -0400
Message-Id: <20210824165607.709387-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index c2a709a384e9..d7591a4621a2 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -700,7 +700,7 @@
 		left_spkr: wsa8810-left{
 			compatible = "sdw10217211000";
 			reg = <0 3>;
-			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
+			powerdown-gpios = <&wcdgpio 1 GPIO_ACTIVE_HIGH>;
 			#thermal-sensor-cells = <0>;
 			sound-name-prefix = "SpkrLeft";
 			#sound-dai-cells = <0>;
@@ -708,7 +708,7 @@
 
 		right_spkr: wsa8810-right{
 			compatible = "sdw10217211000";
-			powerdown-gpios = <&wcdgpio 3 GPIO_ACTIVE_HIGH>;
+			powerdown-gpios = <&wcdgpio 2 GPIO_ACTIVE_HIGH>;
 			reg = <0 4>;
 			#thermal-sensor-cells = <0>;
 			sound-name-prefix = "SpkrRight";
-- 
2.30.2

