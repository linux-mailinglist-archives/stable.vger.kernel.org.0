Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B189F6AED97
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjCGSFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjCGSF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:05:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC7499261
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:58:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D5961509
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F95C433EF;
        Tue,  7 Mar 2023 17:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211911;
        bh=7Z+Fn9ZUuoduw5vlFdXNr8hPtaOplts1EwEa5yZqNcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWNu5JS009VN/WKw6TcHKCSyL5/JyKUkQBPVmVdj8f2ng3+SBcNWe3YYyHjVJyDGo
         6v5f9EMlKwMstrM/ahSkUzrZNXkXiTArlse6JQ02bXC+EQ6CANtQ7nIHs77kXaoftf
         mpV+eNxuaTJQjPXpSZiu+FKAC1pFJj8idKS9Ykyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/885] arm64: dts: qcom: msm8996-tone: Fix USB taking 6 minutes to wake up
Date:   Tue,  7 Mar 2023 17:49:01 +0100
Message-Id: <20230307170001.948927770@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index ca7c8d2e1d3d9..a60decd894291 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
@@ -944,10 +944,6 @@ touch_int_sleep: touch-int-sleep {
 	};
 };
 
-/*
- * For reasons that are currently unknown (but probably related to fusb301), USB takes about
- * 6 minutes to wake up (nothing interesting in kernel logs), but then it works as it should.
- */
 &usb3 {
 	status = "okay";
 	qcom,select-utmi-as-pipe-clk;
@@ -956,6 +952,7 @@ &usb3 {
 &usb3_dwc3 {
 	extcon = <&usb3_id>;
 	dr_mode = "peripheral";
+	maximum-speed = "high-speed";
 	phys = <&hsusb_phy1>;
 	phy-names = "usb2-phy";
 	snps,hird-threshold = /bits/ 8 <0>;
-- 
2.39.2



