Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F6B4F361D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243742AbiDEK6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346817AbiDEJpf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:45:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B3BE5E;
        Tue,  5 Apr 2022 02:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCD15B81CBA;
        Tue,  5 Apr 2022 09:31:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363F5C385A2;
        Tue,  5 Apr 2022 09:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151117;
        bh=7JlGFAX3nIh8Bdi+QO1H92Uxa8oFttFHscOXkUhewfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g28pqjIOAKs4L2JFYC+yvUg+Tqr3dnOsLKk2+ODBJfYa7Fb0Evswd6cwVovvp5wvN
         d1kLXnp1kpXq4wzBfig04tsO85BfAVuFBlMcNoVrpvn2OOqv9xRw6wCJw7mKyxzInJ
         MH7GTXpUsAf4ffvSbG5wUG62fHA3+8sG/tWhVYmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 301/913] arm64: dts: broadcom: bcm4908: use proper TWD binding
Date:   Tue,  5 Apr 2022 09:22:43 +0200
Message-Id: <20220405070348.878635373@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 33826e9c6ba76b265d4e26cb95493fa27ed78974 ]

Block at <ff800400 0x4c> is a TWD that contains timers, watchdog and
reset. Actual timers happen to be at block beginning but they only span
across the first 0x28 registers. It means the old block description was
incorrect (size 0x3c).

Drop timers binding for now and use documented TWD binding. Timers
should be properly documented and defined as TWD subnode.

Fixes: 2961f69f151c ("arm64: dts: broadcom: add BCM4908 and Asus GT-AC5300 early DTS files")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index 5118816b1ed7..e8907d3fe2d1 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -273,9 +273,9 @@
 		#size-cells = <1>;
 		ranges = <0x00 0x00 0xff800000 0x3000>;
 
-		timer: timer@400 {
-			compatible = "brcm,bcm6328-timer", "syscon";
-			reg = <0x400 0x3c>;
+		twd: timer-mfd@400 {
+			compatible = "brcm,bcm4908-twd", "simple-mfd", "syscon";
+			reg = <0x400 0x4c>;
 		};
 
 		gpio0: gpio-controller@500 {
@@ -330,7 +330,7 @@
 
 	reboot {
 		compatible = "syscon-reboot";
-		regmap = <&timer>;
+		regmap = <&twd>;
 		offset = <0x34>;
 		mask = <1>;
 	};
-- 
2.34.1



