Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE4573CE40A
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348104AbhGSPlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348824AbhGSPfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93F5D6120C;
        Mon, 19 Jul 2021 16:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711300;
        bh=Dh5HL0PnJrzEXrqJWxQaBUTwW+D2eHY9QIN5n4fbosQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xlpFMOofP3xeHh6wmnWRRZB5wLa3l2wewPs3vfTfn4Sz/7y8x9T4b/GLbE/iQaB27
         iVOsD1xw0b7kolmWqQBaJ9wc/6RPhcdN2jSl1K/cGtOpZj6c9psF3eFFkFZ6xJHuzT
         6Z6GP/LOW5fqaynmGnsfdEPr6CpLJM+8XbIrg6OE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Jeykumar Sankaran <jsanka@codeaurora.org>,
        Chandan Uddaraju <chandanu@codeaurora.org>,
        Vara Reddy <varar@codeaurora.org>,
        Tanmay Shah <tanmay@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 302/351] arm64: dts: qcom: sc7180: Fix sc7180-qmp-usb3-dp-phy reg sizes
Date:   Mon, 19 Jul 2021 16:54:08 +0200
Message-Id: <20210719144955.044337114@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit c1124180eb9883891ad2acef89c9d17d6190eab4 ]

As per Dmitry Baryshkov [1]:
a) The 2nd "reg" should be 0x3c because "Offset 0x38 is
   USB3_DP_COM_REVISION_ID3 (not used by the current driver though)."
b) The 3rd "reg" "is a serdes region and qmp_v3_dp_serdes_tbl contains
   registers 0x148 and 0x154."

I think because the 3rd "reg" is a serdes region we should just use
the same size as the 1st "reg"?

[1] https://lore.kernel.org/r/ee5695bb-a603-0dd5-7a7f-695e919b1af1@linaro.org

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Jeykumar Sankaran <jsanka@codeaurora.org>
Cc: Chandan Uddaraju <chandanu@codeaurora.org>
Cc: Vara Reddy <varar@codeaurora.org>
Cc: Tanmay Shah <tanmay@codeaurora.org>
Cc: Rob Clark <robdclark@chromium.org>
Fixes: 58fd7ae621e7 ("arm64: dts: qcom: sc7180: Update dts for DP phy inside QMP phy")
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20210315103836.1.I9a97120319d43b42353aeac4d348624d60687df7@changeid
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index 6228ba2d8513..b82014eac56b 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -2754,8 +2754,8 @@
 		usb_1_qmpphy: phy-wrapper@88e9000 {
 			compatible = "qcom,sc7180-qmp-usb3-dp-phy";
 			reg = <0 0x088e9000 0 0x18c>,
-			      <0 0x088e8000 0 0x38>,
-			      <0 0x088ea000 0 0x40>;
+			      <0 0x088e8000 0 0x3c>,
+			      <0 0x088ea000 0 0x18c>;
 			status = "disabled";
 			#address-cells = <2>;
 			#size-cells = <2>;
-- 
2.30.2



