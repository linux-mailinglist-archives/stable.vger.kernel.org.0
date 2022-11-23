Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2B86357A7
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238106AbiKWJqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238266AbiKWJqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:46:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE071144A8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:43:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C323661B74
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADA5C433C1;
        Wed, 23 Nov 2022 09:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196604;
        bh=WiGa33nqOWMdzvVA9pvtn8rx+TxaSrvrJsYk2aP9IEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISGJUR6EXrGwHgWVKiT1jT/Vcwh0tmtqBw+h/SId+lp5FEg9cMrTq9IAdM0HSr5a7
         2MyG69UEJwvRsdTp4QtC751ZLOVIZL6MWM4HO9af+zDnbeLlwgGTX1Kr168SOjGdY7
         DaWsXIfIrMYsoel4Otg7MLBBOSC2jk3THwE70zUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Brian Masney <bmasney@redhat.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 078/314] arm64: dts: qcom: sc8280xp: fix ufs_card_phy ref clock
Date:   Wed, 23 Nov 2022 09:48:43 +0100
Message-Id: <20221123084629.015503060@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 8d6b458ce6e93286a607e54f787f7a86067f58bd ]

The GCC_UFS_REF_CLKREF_CLK must be enabled or the second UFS controller
fails to enumerate on sa8295p-adp.

Note that the vendor kernel enables both GCC_UFS_REF_CLKREF_CLK and
GCC_UFS_1_CARD_CLKREF_CLK and it is possible that the former should be
modelled as a parent of the latter. The clock driver also has a
GCC_UFS_CARD_CLKREF_CLK clock which the firmware appears to enable on
the ADP.

The usual lack of documentation for Qualcomm SoCs makes this a highly
annoying guessing game, but as the second controller works on the ADP
without either card reference clock enabled, only enable
GCC_UFS_REF_CLKREF_CLK for now.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221005143305.388-1-johan+linaro@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 49ea8b5612fc..92cbe84de0e5 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -959,7 +959,7 @@ ufs_card_phy: phy@1da7000 {
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_1_CARD_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_PHY_AUX_CLK>;
 
 			resets = <&ufs_card_hc 0>;
-- 
2.35.1



