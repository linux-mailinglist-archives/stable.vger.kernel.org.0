Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2888329BBED
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802678AbgJ0Puw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802288AbgJ0PqI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:08 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9F8E22265;
        Tue, 27 Oct 2020 15:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813567;
        bh=P+rvPUgbEwcdDyz9Pbrlt1PkHnz47D0R2R74gg+qizA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+WurZP2xWAfIEJpFuXR1hS0g/QcHerlTQIp1C3j7z6MXRLOiZWAsb3SicMiZ3pAZ
         wFT7SKSPWNAG5jSOibSNQh/eZp6egzzxCd9RP65AZ0xncxPRsuFaC2xG/ZxkyErL+K
         gh5MSldg/JQSBywRwucShnYn1gRydW+TrhNrdsMY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 595/757] arm64: dts: qcom: sc7180: Fix the LLCC base register size
Date:   Tue, 27 Oct 2020 14:54:05 +0100
Message-Id: <20201027135518.448387763@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

[ Upstream commit efe788361f72914017515223414d3f20abe4b403 ]

There is one LLCC logical bank(LLCC0) on SC7180 SoC and the
size of the LLCC0 base is 0x50000(320KB) not 2MB, so correct
the size and fix copy paste mistake carried over from SDM845.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Fixes: 7cee5c742899 ("arm64: dts: qcom: sc7180: Fix node order")
Fixes: c831fa299996 ("arm64: dts: qcom: sc7180: Add Last level cache controller node")
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Link: https://lore.kernel.org/r/20200818145514.16262-1-saiprakash.ranjan@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index d46b3833e52fd..e875f6c3b6639 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2618,7 +2618,7 @@ dc_noc: interconnect@9160000 {
 
 		system-cache-controller@9200000 {
 			compatible = "qcom,sc7180-llcc";
-			reg = <0 0x09200000 0 0x200000>, <0 0x09600000 0 0x50000>;
+			reg = <0 0x09200000 0 0x50000>, <0 0x09600000 0 0x50000>;
 			reg-names = "llcc_base", "llcc_broadcast_base";
 			interrupts = <GIC_SPI 582 IRQ_TYPE_LEVEL_HIGH>;
 		};
-- 
2.25.1



