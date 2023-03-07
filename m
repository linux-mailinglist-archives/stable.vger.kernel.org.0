Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661BA6AF2FA
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbjCGS6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbjCGS5x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:57:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A898B78AC
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:45:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B271B819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F573C433EF;
        Tue,  7 Mar 2023 18:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214702;
        bh=VlpYTmL+iQlTYLQIkH/0LcjVLUtZZesgf07shiWVEbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YUNWujydvA0T+W/Oiv+h0f1v7LTH0wlw7ngR08Cppkj7G4P3FonPaF9omxUlAQQn3
         xNoCv78F2n48MywPZQ3z2DwP3QveqNzvG8aO+PhfUTb/tV4L9zUaWjWqDVN/PfuDDL
         6QLT6VA1YJMb4W1OqFtXxk6suqK3QADOYW0WOwFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 006/567] arm64: dts: qcom: msm8996-tone: Fix USB taking 6 minutes to wake up
Date:   Tue,  7 Mar 2023 17:55:42 +0100
Message-Id: <20230307165906.105577615@linuxfoundation.org>
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

[ Upstream commit 43069b9cd358aebc692e654de91ee06ff66e26af ]

The hardware turns out to be pretty sluggish at assuming it can only
do USB2 with just a USB2 phy assigned to it - before it needed about
6 minutes to acknowledge that.

Limit it to USB-HS explicitly to make USB come up about 720x faster.

Fixes: 9da65e441d4d ("arm64: dts: qcom: Add support for SONY Xperia X Performance / XZ / XZs (msm8996, Tone platform)")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221124220147.102611-1-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi b/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
index 507396c4d23b6..7802abac39fa5 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
@@ -938,10 +938,6 @@ touch_int_sleep: touch-int-sleep {
 	};
 };
 
-/*
- * For reasons that are currently unknown (but probably related to fusb301), USB takes about
- * 6 minutes to wake up (nothing interesting in kernel logs), but then it works as it should.
- */
 &usb3 {
 	status = "okay";
 	qcom,select-utmi-as-pipe-clk;
@@ -950,6 +946,7 @@ &usb3 {
 &usb3_dwc3 {
 	extcon = <&usb3_id>;
 	dr_mode = "peripheral";
+	maximum-speed = "high-speed";
 	phys = <&hsusb_phy1>;
 	phy-names = "usb2-phy";
 	snps,hird-threshold = /bits/ 8 <0>;
-- 
2.39.2



