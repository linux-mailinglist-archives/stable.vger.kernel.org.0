Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7404A5496EA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377619AbiFMNdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378447AbiFMNbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:31:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9001703DF;
        Mon, 13 Jun 2022 04:26:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 571AEB80E93;
        Mon, 13 Jun 2022 11:26:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4249C34114;
        Mon, 13 Jun 2022 11:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119565;
        bh=rp7BVa+YdVp1no5nrT8jUWCSbXCylb1klRp57aAm3fM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oW8ki3qOu21usA3h1vlOrjPHCY67HR1GQ8kmcQxCuaR4diQJE4eMT8JU5Wr3JPjeo
         641i4GXSJkd+Ss3nRSLgZHdHuad+miXyvCCa1+ID7CCh0O57gdUtkwOPUvYlWtO3GX
         5Ij2OVcLKylyhaWUdwJZw3vbytGx+Kag33L9LSQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Howard Chiu <howard_chiu@aspeedtech.com>,
        Joel Stanley <joel@jms.id.au>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 059/339] ARM: dts: aspeed: ast2600-evb: Enable RX delay for MAC0/MAC1
Date:   Mon, 13 Jun 2022 12:08:04 +0200
Message-Id: <20220613094928.311639057@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Howard Chiu <howard_chiu@aspeedtech.com>

[ Upstream commit 4d338ee40ba89e508c5d3e1b4af956af7cb5e12e ]

Since mac0/1 and mac2/3 are physically located on different die,
they have different properties by nature, which is mac0/1 has smaller delay step.

The property 'phy-mode' on ast2600 mac0 and mac1 is recommended to set to 'rgmii-rxid'
which enables the RX interface delay from the PHY chip.
Refer page 45 of SDK User Guide v08.00
https://github.com/AspeedTech-BMC/openbmc/releases/download/v08.00/SDK_User_Guide_v08.00.pdf

Fixes: 2ca5646b5c2f ("ARM: dts: aspeed: Add AST2600 and EVB")
Signed-off-by: Howard Chiu <howard_chiu@aspeedtech.com>
Link: https://lore.kernel.org/r/SG2PR06MB23152A548AAE81140B57DD69E6E09@SG2PR06MB2315.apcprd06.prod.outlook.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed-ast2600-evb.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed-ast2600-evb.dts b/arch/arm/boot/dts/aspeed-ast2600-evb.dts
index b7eb552640cb..788448cdd6b3 100644
--- a/arch/arm/boot/dts/aspeed-ast2600-evb.dts
+++ b/arch/arm/boot/dts/aspeed-ast2600-evb.dts
@@ -103,7 +103,7 @@
 &mac0 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	phy-handle = <&ethphy0>;
 
 	pinctrl-names = "default";
@@ -114,7 +114,7 @@
 &mac1 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	phy-handle = <&ethphy1>;
 
 	pinctrl-names = "default";
-- 
2.35.1



