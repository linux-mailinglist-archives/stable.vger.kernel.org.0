Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C088452619
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351613AbhKPCBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240103AbhKOSFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BAF63288;
        Mon, 15 Nov 2021 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998144;
        bh=6hqe4las+xeuhA2tw/XqutEZeljfxbMC4LKMwLNzt0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bJc/vGnweUA4wcWmhaeBHmcFHZTF1kepRKBxC+0RqKA2yCWUIWUjR8b4LHosruFyI
         s6QRv7pTbXc8Xvvi8JlQhhKQNjGLHk4QACwfqHHN/qmJUCqhvPoDmRu72ribuqgs56
         zCo3UQbx0MVr/QzjyDDBqi/34nz7C/WcZnA4yj7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vincent Knecht <vincent.knecht@mailoo.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 404/575] arm64: dts: qcom: msm8916: Fix Secondary MI2S bit clock
Date:   Mon, 15 Nov 2021 18:02:09 +0100
Message-Id: <20211115165357.738595469@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 8199a0b31e76d158ac14841e7119890461f8c595 ]

At the moment, playing audio on Secondary MI2S will just end up getting
stuck, without actually playing any audio. This happens because the wrong
bit clock is configured when playing audio on Secondary MI2S.

The PRI_I2S_CLK (better name: SPKR_I2S_CLK) is used by the SPKR audio mux
block that provides both Primary and Secondary MI2S.

The SEC_I2S_CLK (better name: MIC_I2S_CLK) is used by the MIC audio mux
block that provides Tertiary MI2S. Quaternary MI2S is also part of the
MIC audio mux but has its own clock (AUX_I2S_CLK).

This means that (quite confusingly) the SEC_I2S_CLK is not actually
used for Secondary MI2S as the name would suggest. Secondary MI2S
needs to have the same clock as Primary MI2S configured.

Fix the clock list for the lpass node in the device tree and add
a comment to clarify this confusing naming. With these changes,
audio can be played correctly on Secondary MI2S.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Fixes: 3761a3618f55 ("arm64: dts: qcom: add lpass node")
Tested-by: Vincent Knecht <vincent.knecht@mailoo.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210816181810.2242-1-stephan@gerhold.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 0e34ed48b9fae..b1ffc056eea0b 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1322,11 +1322,17 @@
 		lpass: audio-controller@7708000 {
 			status = "disabled";
 			compatible = "qcom,lpass-cpu-apq8016";
+
+			/*
+			 * Note: Unlike the name would suggest, the SEC_I2S_CLK
+			 * is actually only used by Tertiary MI2S while
+			 * Primary/Secondary MI2S both use the PRI_I2S_CLK.
+			 */
 			clocks = <&gcc GCC_ULTAUDIO_AHBFABRIC_IXFABRIC_CLK>,
 				 <&gcc GCC_ULTAUDIO_PCNOC_MPORT_CLK>,
 				 <&gcc GCC_ULTAUDIO_PCNOC_SWAY_CLK>,
 				 <&gcc GCC_ULTAUDIO_LPAIF_PRI_I2S_CLK>,
-				 <&gcc GCC_ULTAUDIO_LPAIF_SEC_I2S_CLK>,
+				 <&gcc GCC_ULTAUDIO_LPAIF_PRI_I2S_CLK>,
 				 <&gcc GCC_ULTAUDIO_LPAIF_SEC_I2S_CLK>,
 				 <&gcc GCC_ULTAUDIO_LPAIF_AUX_I2S_CLK>;
 
-- 
2.33.0



