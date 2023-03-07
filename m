Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7776AF32A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbjCGTBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbjCGTAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:00:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A13EC48A9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:47:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB4661535
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0A6C433D2;
        Tue,  7 Mar 2023 18:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214827;
        bh=jJA8kcX1J7/AUsBOuJWfRU4injPoIr+3+5p/Iku2siA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=15eZVFPn7MqEnlgK+e8CSuJ8KzM5AzhYp15DK66U/D8w4T7oTLWMntXwBB+bEsvMT
         IDEJGGX6PiZTLpc1+O0ucCgsj5SsQvJrx/inQFRWKTBHzZZpvOjAUj93iBX397fbpv
         ZsVe/lh2iOWM6FVPwuPZSIb211QKUj8+rPVbBxxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/567] arm64: dts: qcom: pmk8350: Specify PBS register for PON
Date:   Tue,  7 Mar 2023 17:56:39 +0100
Message-Id: <20230307165908.620079839@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit f46ef374e0dcb8fd2f272a376cf0dcdab7e52fc2 ]

PMK8350 is the first PMIC to require both HLOS and PBS registers for
PON to function properly (at least in theory, sm8350 sees no change).
The support for it on the driver side has been added long ago,
but it has never been wired up. Do so.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221115132626.7465-1-konrad.dybcio@linaro.org
Stable-dep-of: c0ee8e0ba5cc ("arm64: dts: qcom: pmk8350: Use the correct PON compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pmk8350.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pmk8350.dtsi b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
index 04fc2632a0b20..530adc87a4096 100644
--- a/arch/arm64/boot/dts/qcom/pmk8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
@@ -17,7 +17,8 @@ pmk8350: pmic@0 {
 
 		pmk8350_pon: pon@1300 {
 			compatible = "qcom,pm8998-pon";
-			reg = <0x1300>;
+			reg = <0x1300>, <0x800>;
+			reg-names = "hlos", "pbs";
 
 			pwrkey {
 				compatible = "qcom,pmk8350-pwrkey";
-- 
2.39.2



