Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794E9657A53
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbiL1PKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiL1PJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:09:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A13113E16
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:09:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEE7761553
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8A6C433D2;
        Wed, 28 Dec 2022 15:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240192;
        bh=kqdXH0cZ/DfQlEfgt3InESfQaUYuOh2IexaMIcw2J38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kh1oWmKfHOrvTQqwanVSkK3AvSHuQN1/odlwVtflVyG2/Cs6ncUMpWr4Oflfkgs2h
         jVOs8fEuxSzfQ4TATK/2KvPre67Sz+2B3ktbMg16fxc14ubGcjXAfCv0N4pxMLuo76
         I4CAUaRHzFEohStPK9UDw7SwOgybng53ljTGPwys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0091/1146] arm64: dts: armada-3720-turris-mox: Add missing interrupt for RTC
Date:   Wed, 28 Dec 2022 15:27:10 +0100
Message-Id: <20221228144332.615257767@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 21aad8ba615e9c39cee6c5d0b76726f63791926c ]

MCP7940MT-I/MNY RTC has connected interrupt line to GPIO2_5.

Fixes: 7109d817db2e ("arm64: dts: marvell: add DTS for Turris Mox")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
index ada164d423f3..200f97e1c4c9 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -125,9 +125,12 @@ &i2c0 {
 	/delete-property/ mrvl,i2c-fast-mode;
 	status = "okay";
 
+	/* MCP7940MT-I/MNY RTC */
 	rtc@6f {
 		compatible = "microchip,mcp7940x";
 		reg = <0x6f>;
+		interrupt-parent = <&gpiosb>;
+		interrupts = <5 0>; /* GPIO2_5 */
 	};
 };
 
-- 
2.35.1



