Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AD566C661
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbjAPQTg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbjAPQTF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:19:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D5828841
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8320160FDF
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1BFC433EF;
        Mon, 16 Jan 2023 16:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885420;
        bh=TkMRbZtJZcCELkpDQ/XI5uP7yC4gomoPN69EHELDCk4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ybWBNDpKPpfU5Q1cwfldmFdRGJwWqiRmqgX1AdiooL15QFL3xmQL2bcs9Ogz79fH
         GE4A+bqi5IiqyAa6uykqlHgOobxE/Caytk3//XArD0gIEC9f38K9cV6YDrXudHNAUk
         gdBgblzuEOXhzRmcwlZORK8Dd7yFORdDUYQ+BTpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/658] arm64: dts: armada-3720-turris-mox: Add missing interrupt for RTC
Date:   Mon, 16 Jan 2023 16:42:13 +0100
Message-Id: <20230116154911.672996941@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 2e8239d489f8..351e211afcf5 100644
--- a/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
+++ b/arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
@@ -122,9 +122,12 @@ &i2c0 {
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



