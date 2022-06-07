Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECC0B5412C2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354520AbiFGTxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357108AbiFGTs2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:48:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B34A7522F;
        Tue,  7 Jun 2022 11:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF0FDB8237C;
        Tue,  7 Jun 2022 18:19:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D12C385A2;
        Tue,  7 Jun 2022 18:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625958;
        bh=A5qnA9C+kP6l+c9zYf7PMXtikJHUSGvTK8q0Jfa21Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYe/RhXbVKCmGMk5pQk8YEfl1fD5UiBA1V+tJCYKqVi3xINzUUo+u92R4ubKEnfem
         vc+62RF5jXR7WlhClGH0xE0oqsonsau2pE98AULbXbePQ/S5TrqU3kRvSYx2xRaHPp
         gOU1xb6YrxJIpACf9AU7YatJFEMgbt034hVquMz4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>,
        Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 204/772] arm64: dts: qcom: sc7280-idp: Configure CTS pin to bias-bus-hold for bluetooth
Date:   Tue,  7 Jun 2022 18:56:36 +0200
Message-Id: <20220607164955.044737521@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>

[ Upstream commit 497b272759986af1aa5a25b5e903d082c67bd8f6 ]

WLAN rail was leaking power during RBSC/sleep even after turning BT off.
Change active and sleep pinctrl configurations to handle same.

Signed-off-by: Vijaya Krishna Nivarthi <quic_vnivarth@quicinc.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1650556567-4995-2-git-send-email-quic_vnivarth@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280-idp.dtsi | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
index d623d71d8bd4..dd6dac0e1784 100644
--- a/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280-idp.dtsi
@@ -462,10 +462,13 @@
 
 &qup_uart7_cts {
 	/*
-	 * Configure a pull-down on CTS to match the pull of
-	 * the Bluetooth module.
+	 * Configure a bias-bus-hold on CTS to lower power
+	 * usage when Bluetooth is turned off. Bus hold will
+	 * maintain a low power state regardless of whether
+	 * the Bluetooth module drives the pin in either
+	 * direction or leaves the pin fully unpowered.
 	 */
-	bias-pull-down;
+	bias-bus-hold;
 };
 
 &qup_uart7_rts {
@@ -516,10 +519,13 @@
 		pins = "gpio28";
 		function = "gpio";
 		/*
-		 * Configure a pull-down on CTS to match the pull of
-		 * the Bluetooth module.
+		 * Configure a bias-bus-hold on CTS to lower power
+		 * usage when Bluetooth is turned off. Bus hold will
+		 * maintain a low power state regardless of whether
+		 * the Bluetooth module drives the pin in either
+		 * direction or leaves the pin fully unpowered.
 		 */
-		bias-pull-down;
+		bias-bus-hold;
 	};
 
 	qup_uart7_sleep_rts: qup-uart7-sleep-rts {
-- 
2.35.1



