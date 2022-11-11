Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9137662573F
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 10:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbiKKJsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 04:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233493AbiKKJsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 04:48:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D86F015;
        Fri, 11 Nov 2022 01:48:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A76B2B824B3;
        Fri, 11 Nov 2022 09:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50200C43149;
        Fri, 11 Nov 2022 09:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668160087;
        bh=k7HWwmkJ5Tj0P6Rb2U81O5MNZ1lTYtGf+8AT/P4q3L8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBoJ71x9S5lfZTP0sVVv2XlkBss9uRA/cqs+7WyDIOmnq3x1D6V8rY9wK3ZszpdiB
         p5dwNwkX2pBBqDEs2EnwuuxFxi610EYPMedBKenpJmb4ihq3kY8r+i3V09G1pGBApm
         2Yi16SzsFrjT6lLi0n8BzVecd+hn/HyWrWuu2Ohie6OWsy+GaFhE2UEyl/yrnUa2zN
         jAMxVd7PlAeMjJuZ2nDDJiQy2UA3f+n4mfiPFmYhDCLSrbOCmOTuqCPt+PTSDwjCk/
         V1+ZYI8iJihI+UUHx6D+EsIM97ciodtE81+tTjxxXtbASLALIgBPoxbuS3mmcJH2mw
         64jzMq7ctaPDw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1otQdP-00035J-6Y; Fri, 11 Nov 2022 10:47:39 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Bjorn Andersson <andersson@kernel.org>
Cc:     Vinod Koul <vkoul@kernel.org>, Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 2/2] arm64: dts: qcom: sm8250: fix USB-DP PHY registers
Date:   Fri, 11 Nov 2022 10:47:29 +0100
Message-Id: <20221111094729.11842-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221111094729.11842-1-johan+linaro@kernel.org>
References: <20221111094729.11842-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When adding support for the DisplayPort part of the QMP PHY the binding
(and devicetree parser) for the (USB) child node was simply reused and
this has lead to some confusion.

The third DP register region is really the DP_PHY region, not "PCS" as
the binding claims, and lie at offset 0x2a00 (not 0x2c00).

Similarly, there likely are no "RX", "RX2" or "PCS_MISC" regions as
there are for the USB part of the PHY (and in any case the Linux driver
does not use them).

Note that the sixth "PCS_MISC" region is not even in the binding.

Fixes: 5aa0d1becd5b ("arm64: dts: qcom: sm8250: switch usb1 qmp phy to USB3+DP mode")
Cc: stable@vger.kernel.org      # 5.13
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 52686f963dfc..0e86ed688fc2 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2891,10 +2891,9 @@ usb_1_ssphy: usb3-phy@88e9200 {
 			dp_phy: dp-phy@88ea200 {
 				reg = <0 0x088ea200 0 0x200>,
 				      <0 0x088ea400 0 0x200>,
-				      <0 0x088eac00 0 0x400>,
+				      <0 0x088eaa00 0 0x200>,
 				      <0 0x088ea600 0 0x200>,
-				      <0 0x088ea800 0 0x200>,
-				      <0 0x088eaa00 0 0x100>;
+				      <0 0x088ea800 0 0x200>;
 				#phy-cells = <0>;
 				#clock-cells = <1>;
 			};
-- 
2.37.4

