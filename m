Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7395329C5BF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900868AbgJ0OM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754474AbgJ0OFj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:05:39 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 918632222C;
        Tue, 27 Oct 2020 14:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807539;
        bh=vdRF+n8FPKystMTO0J2qTG77A+2/Gqa6IqVIF3sU2Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NtEfSQjY31dtisnGTZC/kxiSO28Zg+QwnxGnknYV435RflxqYuIFh98dJhHgU1WiZ
         aS2bnrlGZpuXc7eM40bjXJkvSko0asnNR04Q9dnPYVca5AdgVElJBQ4QZeaOeI1m8t
         BG0VI7mVVYlxZySgK2cN9zLnYrXzTqhQHJ2GQ94g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 089/139] arm64: dts: qcom: msm8916: Fix MDP/DSI interrupts
Date:   Tue, 27 Oct 2020 14:49:43 +0100
Message-Id: <20201027134906.357795645@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134902.130312227@linuxfoundation.org>
References: <20201027134902.130312227@linuxfoundation.org>
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
index 08b88f6791beb..fb5001a6879c7 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -715,7 +715,7 @@ mdp: mdp@1a01000 {
 				reg-names = "mdp_phys";
 
 				interrupt-parent = <&mdss>;
-				interrupts = <0 0>;
+				interrupts = <0>;
 
 				clocks = <&gcc GCC_MDSS_AHB_CLK>,
 					 <&gcc GCC_MDSS_AXI_CLK>,
@@ -745,7 +745,7 @@ dsi0: dsi@1a98000 {
 				reg-names = "dsi_ctrl";
 
 				interrupt-parent = <&mdss>;
-				interrupts = <4 0>;
+				interrupts = <4>;
 
 				assigned-clocks = <&gcc BYTE0_CLK_SRC>,
 						  <&gcc PCLK0_CLK_SRC>;
-- 
2.25.1



