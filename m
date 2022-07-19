Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58A2579C2E
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240894AbiGSMhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240768AbiGSMgX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:36:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F9626104;
        Tue, 19 Jul 2022 05:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACFC4B81B21;
        Tue, 19 Jul 2022 12:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE48C341C6;
        Tue, 19 Jul 2022 12:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232811;
        bh=uinYfMvxMPlZBnKki7jUgXVpXy55MFvui2maCfMC+nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6Bu21ZpnK/ubCGV46g2V9LsXBeoURjzyg+cUD0a8CMMKcxS1xfXivjFqTUovaCVy
         6bjTuMT6Z9aavGN3HQ4BE+ZJNYSBmPzQ8xX+g0rl40GgsG7bQdw2kODUhEVHDAo5kz
         S4lEO2jiW/168EFPjO0ojAhmhF4DWKyk11GP73pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Zhang <william.zhang@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/167] arm64: dts: broadcom: bcm4908: Fix cpu node for smp boot
Date:   Tue, 19 Jul 2022 13:53:18 +0200
Message-Id: <20220719114702.911394756@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Zhang <william.zhang@broadcom.com>

[ Upstream commit 8bd582ae9a71d7f14c4e0c735b2eacaf7516d626 ]

Add spin-table enable-method and cpu-release-addr properties for
cpu0 node. This is required by all ARMv8 SoC. Otherwise some
bootloader like u-boot can not update cpu-release-addr and linux
fails to start up secondary cpus.

Fixes: 2961f69f151c ("arm64: dts: broadcom: add BCM4908 and Asus GT-AC5300 early DTS files")
Signed-off-by: William Zhang <william.zhang@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
index e8907d3fe2d1..e510a6961cf9 100644
--- a/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi
@@ -29,6 +29,8 @@ cpu0: cpu@0 {
 			device_type = "cpu";
 			compatible = "brcm,brahma-b53";
 			reg = <0x0>;
+			enable-method = "spin-table";
+			cpu-release-addr = <0x0 0xfff8>;
 			next-level-cache = <&l2>;
 		};
 
-- 
2.35.1



