Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B017B4994F2
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391887AbiAXUt5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388845AbiAXUkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:40:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34D5C04590F;
        Mon, 24 Jan 2022 11:51:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 589FBB81215;
        Mon, 24 Jan 2022 19:51:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A5CC340E5;
        Mon, 24 Jan 2022 19:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053893;
        bh=2/G4H/z6ZjT0mBnaR+ViTzd1dhM7FMwdV/1uFN7ooNs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hz7SdrvlMbEm4IgGUN12tpx00NlcVkIc7wr0Uivf8akj0B0TKcmT9GRzspu+S1PVh
         +kR1OoIQxDeGnJOVs9qgWVWasCZASq5Am8o8Pg2dFgNk2qirGjZIjSeoJa0iLmYzRl
         s44r0PWXkOJ3nI32yRhG8A0bsAdOXhvIL7A0w5Tw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Marko <robert.marko@sartura.hr>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/563] arm64: dts: marvell: cn9130: enable CP0 GPIO controllers
Date:   Mon, 24 Jan 2022 19:39:03 +0100
Message-Id: <20220124184030.572918348@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Marko <robert.marko@sartura.hr>

[ Upstream commit 0734f8311ce72c9041e5142769eff2083889c172 ]

CN9130 has a built-in CP115 which has 2 GPIO controllers, but unlike in
Armada 7k and 8k both are left disabled by the SoC DTSI.

This first of all makes no sense as they are always present due to being
SoC built-in and its an issue as boards like CN9130-CRB use the CPO GPIO2
pins for regulators and SD card support without enabling them first.

So, enable both of them like Armada 7k and 8k do.

Fixes: 6b8970bd8d7a ("arm64: dts: marvell: Add support for Marvell CN9130 SoC support")

Signed-off-by: Robert Marko <robert.marko@sartura.hr>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/cn9130.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/cn9130.dtsi b/arch/arm64/boot/dts/marvell/cn9130.dtsi
index 71769ac7f0585..327b04134134f 100644
--- a/arch/arm64/boot/dts/marvell/cn9130.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130.dtsi
@@ -42,3 +42,11 @@
 #undef CP11X_PCIE0_BASE
 #undef CP11X_PCIE1_BASE
 #undef CP11X_PCIE2_BASE
+
+&cp0_gpio1 {
+	status = "okay";
+};
+
+&cp0_gpio2 {
+	status = "okay";
+};
-- 
2.34.1



