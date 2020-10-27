Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF49629C3D6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822583AbgJ0Rug (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:50:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368364AbgJ0OZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:25:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 226BB2072D;
        Tue, 27 Oct 2020 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808718;
        bh=ff8Y5P4MnFRyF+qoEYbcQF6vhYtqa5sX0jGeZnROf0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Olg4smPl/zS6bB06sMjXbiBuc+NT+IMYYRRgdLTkGWbF65tB/10As0d0uhUSkKMml
         RrE79uG+qugHp5XxZcFqPZNxoK6DBPZtYBwp58dRfoK82tr+vdNhtK8ZgZBcvLmhKa
         E+hWtToi6Bv9ba8yWVVhXMRUaLUg8ZA4B23azRMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 197/264] arm64: dts: qcom: msm8916: Fix MDP/DSI interrupts
Date:   Tue, 27 Oct 2020 14:54:15 +0100
Message-Id: <20201027135439.925040794@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 027cca9eb5b450c3f6bb916ba999144c2ec23cb7 ]

The mdss node sets #interrupt-cells = <1>, so its interrupts
should be referenced using a single cell (in this case: only the
interrupt number).

However, right now the mdp/dsi node both have two interrupt cells
set, e.g. interrupts = <4 0>. The 0 is probably meant to say
IRQ_TYPE_NONE (= 0), but with #interrupt-cells = <1> this is
actually interpreted as a second interrupt line.

Remove the IRQ flags from both interrupts to fix this.

Fixes: 305410ffd1b2 ("arm64: dts: msm8916: Add display support")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200915071221.72895-5-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index 8011e564a234b..2c5193ae20277 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -877,7 +877,7 @@ mdp: mdp@1a01000 {
 				reg-names = "mdp_phys";
 
 				interrupt-parent = <&mdss>;
-				interrupts = <0 0>;
+				interrupts = <0>;
 
 				clocks = <&gcc GCC_MDSS_AHB_CLK>,
 					 <&gcc GCC_MDSS_AXI_CLK>,
@@ -909,7 +909,7 @@ dsi0: dsi@1a98000 {
 				reg-names = "dsi_ctrl";
 
 				interrupt-parent = <&mdss>;
-				interrupts = <4 0>;
+				interrupts = <4>;
 
 				assigned-clocks = <&gcc BYTE0_CLK_SRC>,
 						  <&gcc PCLK0_CLK_SRC>;
-- 
2.25.1



