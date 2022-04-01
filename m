Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFDB54EF56E
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355138AbiDAPN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350694AbiDAPAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 11:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5D73B035;
        Fri,  1 Apr 2022 07:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B99460F45;
        Fri,  1 Apr 2022 14:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DF9C3410F;
        Fri,  1 Apr 2022 14:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824540;
        bh=QuWD/c/0TMWsSnV4HCfyy/4dEl2PPOCVjcdyDssqDsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oPsGC77s8AdFxSQKWIIxWbcWCHnuRYo5i1M5udIM2XiO1Tp9ADaNGwuyCfdHubdI8
         Zf3tEro6bdqZ60l7ogOdcEmewcmBOVCLwZA9HBdXVP/b3DIjBMi5R62z6ECm5KttAe
         nrsuruK2pna4EelsO62r4yf9Zq85h0Zc6M11Ixk+52FvAVrbMEt0Ktg7JsM4jyFG82
         lRTLL/np7s/SqYDI3wAoFJuSEA9EdTYPlSTGhCSw3LiU7ak5DUfZpU4sabw+/KgZpp
         LyUvkVHhkYf2YMwhNu65j6xR92qUN6PB5zAuACwrPi0wwl71GEaUGjPJo2J0GVtbsn
         bolCMD0pn55jQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        robh+dt@kernel.org, krzk+dt@kernel.org, chris@zankel.net,
        devicetree@vger.kernel.org, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.9 14/16] xtensa: fix DTC warning unit_address_format
Date:   Fri,  1 Apr 2022 10:48:25 -0400
Message-Id: <20220401144827.1955845-14-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144827.1955845-1-sashal@kernel.org>
References: <20220401144827.1955845-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit e85d29ba4b24f68e7a78cb85c55e754362eeb2de ]

DTC issues the following warnings when building xtfpga device trees:

 /soc/flash@00000000/partition@0x0: unit name should not have leading "0x"
 /soc/flash@00000000/partition@0x6000000: unit name should not have leading "0x"
 /soc/flash@00000000/partition@0x6800000: unit name should not have leading "0x"
 /soc/flash@00000000/partition@0x7fe0000: unit name should not have leading "0x"

Drop leading 0x from flash partition unit names.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi | 8 ++++----
 arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi  | 8 ++++----
 arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi   | 4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
index d3a88e029873..d9b399b57bcd 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
@@ -7,19 +7,19 @@ flash: flash@00000000 {
 			reg = <0x00000000 0x08000000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "data";
 				reg = <0x00000000 0x06000000>;
 			};
-			partition@0x6000000 {
+			partition@6000000 {
 				label = "boot loader area";
 				reg = <0x06000000 0x00800000>;
 			};
-			partition@0x6800000 {
+			partition@6800000 {
 				label = "kernel image";
 				reg = <0x06800000 0x017e0000>;
 			};
-			partition@0x7fe0000 {
+			partition@7fe0000 {
 				label = "boot environment";
 				reg = <0x07fe0000 0x00020000>;
 			};
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
index 1d97203c18e7..c9d0fc0b6265 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
@@ -7,19 +7,19 @@ flash: flash@08000000 {
 			reg = <0x08000000 0x01000000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "boot loader area";
 				reg = <0x00000000 0x00400000>;
 			};
-			partition@0x400000 {
+			partition@400000 {
 				label = "kernel image";
 				reg = <0x00400000 0x00600000>;
 			};
-			partition@0xa00000 {
+			partition@a00000 {
 				label = "data";
 				reg = <0x00a00000 0x005e0000>;
 			};
-			partition@0xfe0000 {
+			partition@fe0000 {
 				label = "boot environment";
 				reg = <0x00fe0000 0x00020000>;
 			};
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
index d1c621ca8be1..332892315f92 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
@@ -7,11 +7,11 @@ flash: flash@08000000 {
 			reg = <0x08000000 0x00400000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "boot loader area";
 				reg = <0x00000000 0x003f0000>;
 			};
-			partition@0x3f0000 {
+			partition@3f0000 {
 				label = "boot environment";
 				reg = <0x003f0000 0x00010000>;
 			};
-- 
2.34.1

