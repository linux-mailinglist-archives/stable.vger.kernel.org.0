Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAB134F26A0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiDEIF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiDEH7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:59:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039E732EC3;
        Tue,  5 Apr 2022 00:54:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B12EB81B9C;
        Tue,  5 Apr 2022 07:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9F7C340EE;
        Tue,  5 Apr 2022 07:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145239;
        bh=ppIPX3URR0acf6wOyfL262wQNE8KPCBIqOOvB243B1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOoe0VWNghxZVP30Uc83EZ2IdLETBqkBJAOiF0YJ4OOzZ4w7Wz8sARzUK16tooKPb
         2tHBRZKSAc77tOCBAyej0g0nKKCBygpl4Wm6cBw5qXXiw6vFfifAh+oBRSxxs5CCNl
         cMebm0zTsPt9bC3NPOPET+F75sX4/QxrcxlY7CGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0334/1126] arm64: dts: broadcom: bcm4908: use proper TWD binding
Date:   Tue,  5 Apr 2022 09:18:01 +0200
Message-Id: <20220405070417.420468619@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index 984c737fa627..6e738f2a3701 100644
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



