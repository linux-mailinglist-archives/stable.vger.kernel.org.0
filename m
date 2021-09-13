Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94CF40950A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344930AbhIMOhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:37:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347676AbhIMOfT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:35:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B685A61BA2;
        Mon, 13 Sep 2021 13:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541207;
        bh=jWJSZgnHg1H0qn8zl+kjEvTJyEEpJtGBEPnU7Dl477Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FKtJbizIbbyXctzpM2Ew8zixQdb4yTaWef6LCo0f9OaR/9jdtDM7KCl+h7jjUGrnY
         HiiqMA21dU9j2ukL1vOBkFjr0PDmH5jW5j95Htn7eiSZTuUeu5JQpldXUYQ4ggScvA
         pIjq58yBXB+eu/VncSWbGQNXPl1nEOV5haXebOMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 174/334] arm64: dts: qcom: sm8350: fix IPA interconnects
Date:   Mon, 13 Sep 2021 15:13:48 +0200
Message-Id: <20210913131119.231888782@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 84173ca359787abd720d150d3d0d7edabf9db46c ]

There should only be two interconnects defined for IPA on the
QUalcomm SM8350 SoC.  The names should also match those specified by
the IPA Device Tree binding.

Fixes: f11d3e7da32e ("arm64: dts: qcom: sm8350: add IPA information")
Signed-off-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20210804210214.1891755-5-elder@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 0d16392bb976..dbc174d424e2 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -666,12 +666,10 @@
 			clocks = <&rpmhcc RPMH_IPA_CLK>;
 			clock-names = "core";
 
-			interconnects = <&aggre2_noc MASTER_IPA &gem_noc SLAVE_LLCC>,
-					<&mc_virt MASTER_LLCC &mc_virt SLAVE_EBI1>,
+			interconnects = <&aggre2_noc MASTER_IPA &mc_virt SLAVE_EBI1>,
 					<&gem_noc MASTER_APPSS_PROC &config_noc SLAVE_IPA_CFG>;
-			interconnect-names = "ipa_to_llcc",
-					     "llcc_to_ebi1",
-					     "appss_to_ipa";
+			interconnect-names = "memory",
+					     "config";
 
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
-- 
2.30.2



