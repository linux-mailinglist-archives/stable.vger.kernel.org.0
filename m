Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85482681134
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237188AbjA3OLL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:11:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237181AbjA3OLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:11:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EEE3BD96
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A410B811C7
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8A7C433D2;
        Mon, 30 Jan 2023 14:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087851;
        bh=T/A6a04mjLHymUgAte0XTMerET7ixOyDQHo+YxaLKH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAAsgicH2hBhJuDQpnvziQ9B2Nzd0aUf8Qrwc7w2aqoPvlKLvUEY7n8OfyRWnbncv
         lknZtZ1atG1muZy6mSPkKaE/7G/BNymORM4Clm+frAtsPACydA8dNGGfTO6uRfSdgG
         sSHSbrIUjY8okNYt7m0WZOJfAqbRIvcNPDjdu0wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/204] arm64: dts: qcom: msm8992-libra: Fix the memory map
Date:   Mon, 30 Jan 2023 14:49:55 +0100
Message-Id: <20230130134317.634337473@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 69876bc6fd4de3ad2dc7826fe269e91fa2c1807f ]

The memory map was wrong. Fix it to prevent the device from randomly
rebooting.

Fixes: 0f5cdb31e850 ("arm64: dts: qcom: Add Xiaomi Libra (Mi 4C) device tree")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221219131918.446587-2-konrad.dybcio@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/msm8992-xiaomi-libra.dts    | 77 +++++++++++++++----
 1 file changed, 60 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
index d55de06447f6..d08659c606b9 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-xiaomi-libra.dts
@@ -11,6 +11,12 @@
 #include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/input/gpio-keys.h>
 
+/delete-node/ &adsp_mem;
+/delete-node/ &audio_mem;
+/delete-node/ &mpss_mem;
+/delete-node/ &peripheral_region;
+/delete-node/ &rmtfs_mem;
+
 / {
 	model = "Xiaomi Mi 4C";
 	compatible = "xiaomi,libra", "qcom,msm8992";
@@ -60,25 +66,67 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		/* This is for getting crash logs using Android downstream kernels */
-		ramoops@dfc00000 {
-			compatible = "ramoops";
-			reg = <0x0 0xdfc00000 0x0 0x40000>;
-			console-size = <0x10000>;
-			record-size = <0x10000>;
-			ftrace-size = <0x10000>;
-			pmsg-size = <0x20000>;
+		memory_hole: hole@6400000 {
+			reg = <0 0x06400000 0 0x600000>;
+			no-map;
+		};
+
+		memory_hole2: hole2@6c00000 {
+			reg = <0 0x06c00000 0 0x2400000>;
+			no-map;
+		};
+
+		mpss_mem: mpss@9000000 {
+			reg = <0 0x09000000 0 0x5a00000>;
+			no-map;
+		};
+
+		tzapp: tzapp@ea00000 {
+			reg = <0 0x0ea00000 0 0x1900000>;
+			no-map;
+		};
+
+		mdm_rfsa_mem: mdm-rfsa@ca0b0000 {
+			reg = <0 0xca0b0000 0 0x10000>;
+			no-map;
+		};
+
+		rmtfs_mem: rmtfs@ca100000 {
+			compatible = "qcom,rmtfs-mem";
+			reg = <0 0xca100000 0 0x180000>;
+			no-map;
+
+			qcom,client-id = <1>;
 		};
 
-		modem_region: modem_region@9000000 {
-			reg = <0x0 0x9000000 0x0 0x5a00000>;
+		audio_mem: audio@cb400000 {
+			reg = <0 0xcb000000 0 0x400000>;
+			no-mem;
+		};
+
+		qseecom_mem: qseecom@cb400000 {
+			reg = <0 0xcb400000 0 0x1c00000>;
+			no-mem;
+		};
+
+		adsp_rfsa_mem: adsp-rfsa@cd000000 {
+			reg = <0 0xcd000000 0 0x10000>;
 			no-map;
 		};
 
-		tzapp: modem_region@ea00000 {
-			reg = <0x0 0xea00000 0x0 0x1900000>;
+		sensor_rfsa_mem: sensor-rfsa@cd010000 {
+			reg = <0 0xcd010000 0 0x10000>;
 			no-map;
 		};
+
+		ramoops@dfc00000 {
+			compatible = "ramoops";
+			reg = <0 0xdfc00000 0 0x40000>;
+			console-size = <0x10000>;
+			record-size = <0x10000>;
+			ftrace-size = <0x10000>;
+			pmsg-size = <0x20000>;
+		};
 	};
 };
 
@@ -120,11 +168,6 @@ &blsp2_uart2 {
 	status = "okay";
 };
 
-&peripheral_region {
-	reg = <0x0 0x7400000 0x0 0x1c00000>;
-	no-map;
-};
-
 &pm8994_spmi_regulators {
 	VDD_APC0: s8 {
 		regulator-min-microvolt = <680000>;
-- 
2.39.0



