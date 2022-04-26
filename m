Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1436150F8A1
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 11:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237757AbiDZJPt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 05:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346695AbiDZJMt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 05:12:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060EA1815FF;
        Tue, 26 Apr 2022 01:49:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9941AB81D09;
        Tue, 26 Apr 2022 08:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36CDC385A4;
        Tue, 26 Apr 2022 08:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962983;
        bh=nklLb4gbCMQEaN+WxPmRslhp6NdUltk2940n2uXGnuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LvD8Lcr6UaUgBr4LAt+qv6jdYxpg7OLc7TAtO4IF00YApo77gnk+fheeB/fsd3SM0
         ZZw/ZI9S+Xb4y3WLY+2vASAUfQcVuZ7Ba5jT+ItvtLti+NdCoXATMDDO+b1Yfj88YA
         dT5BcznNbm5UpFtYCu7i34UWR8ZdERZoIzBF6kH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Elder <elder@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.17 146/146] arm64: dts: qcom: add IPA qcom,qmp property
Date:   Tue, 26 Apr 2022 10:22:21 +0200
Message-Id: <20220426081754.163324695@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Elder <elder@linaro.org>

commit 73419e4d2fd1b838fcb1df6a978d67b3ae1c5c01 upstream.

At least three platforms require the "qcom,qmp" property to be
specified, so the IPA driver can request register retention across
power collapse.  Update DTS files accordingly.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220201140723.467431-1-elder@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc7180.dtsi |    2 ++
 arch/arm64/boot/dts/qcom/sc7280.dtsi |    2 ++
 arch/arm64/boot/dts/qcom/sm8350.dtsi |    2 ++
 3 files changed, 6 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -1459,6 +1459,8 @@
 					     "imem",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1714,6 +1714,8 @@
 			interconnect-names = "memory",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1443,6 +1443,8 @@
 			interconnect-names = "memory",
 					     "config";
 
+			qcom,qmp = <&aoss_qmp>;
+
 			qcom,smem-states = <&ipa_smp2p_out 0>,
 					   <&ipa_smp2p_out 1>;
 			qcom,smem-state-names = "ipa-clock-enabled-valid",


