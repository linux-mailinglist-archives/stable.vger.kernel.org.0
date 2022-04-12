Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F02E4FD01A
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiDLGlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350220AbiDLGka (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:40:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A23DFD0;
        Mon, 11 Apr 2022 23:35:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE4266189D;
        Tue, 12 Apr 2022 06:35:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB77DC385A6;
        Tue, 12 Apr 2022 06:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745349;
        bh=X/XV6dqIM01stGb6muJgsi2Mox5PAsrFHhzqwvCyAKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gA3yXvhJIRpu/RKE6FPChOH24TyI1xE7ufIRX+7eV4KKkdlCBidmTCTlvy3qM2BjM
         0DvlHTmQ69BJydlWBVdDX1PoKN61y5za0oPyJ3MZaVA7j7C8ixnaoKUCR0dz6u5N2W
         YCClAdbGWec8KrPuVkb7tuEArJsPVPBkX7G2bRms=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/171] xtensa: fix DTC warning unit_address_format
Date:   Tue, 12 Apr 2022 08:29:16 +0200
Message-Id: <20220412062929.763780643@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 9bf8bad1dd18..c33932568aa7 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
@@ -8,19 +8,19 @@
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
index 40c2f81f7cb6..7bde2ab2d6fb 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
@@ -8,19 +8,19 @@
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
index fb8d3a9f33c2..0655b868749a 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
@@ -8,11 +8,11 @@
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
2.35.1



