Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5CA3C8C68
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhGNTl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhGNTlq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA981613E5;
        Wed, 14 Jul 2021 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291534;
        bh=UsKyJiGxM5oZPFswj1xWUd9yE/lYzjzQ8OFYzK+hWQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdlwtvA1B6fDKPMdjyz6piwWGWUr1ImClOTSeTArfOQY/TScvmdjXcVeLwApWrKqZ
         teubXNqnwcpEEUUlgF/8XX2z2NW5ICA6O0pq4mSf4BpnwQbvrC1zo06a2iXQJCS0j4
         iD+e8mci1GXAwsT7Pjr059WnxwY5q3RVbyT8ZwChyOA4OM7caKim3Ce4zm6//G7zbl
         /RZ2Po7xPX6z9d5/w2plj1xgY6ArFWhMVXyfO70qCHs/a2Tu7kLUAz6Wi3KLZjPNLE
         ostiOsKRrhh2cXPKTtdXlhmEOOvdH80pUOsUVKfb4k0Vv3t1N92uvKWK/mJz6L0xkB
         xhsm5i/K238ww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 037/108] arm64: dts: renesas: beacon: Fix USB extal reference
Date:   Wed, 14 Jul 2021 15:36:49 -0400
Message-Id: <20210714193800.52097-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 56bc54496f5d6bc638127bfc9df3742cbf0039e7 ]

The USB extal clock reference isn't associated to a crystal, it's
associated to a programmable clock, so remove the extal reference,
add the usb2_clksel.  Since usb_extal is referenced by the versaclock,
reference it here so the usb2_clksel can get the proper clock speed
of 50MHz.

Signed-off-by: Adam Ford <aford173@gmail.com>
Link: https://lore.kernel.org/r/20210513114617.30191-1-aford173@gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
index 8d3a4d6ee885..bd3d26b2a2bb 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
@@ -319,8 +319,10 @@ &sdhi3 {
 	status = "okay";
 };
 
-&usb_extal_clk {
-	clock-frequency = <50000000>;
+&usb2_clksel {
+	clocks = <&cpg CPG_MOD 703>, <&cpg CPG_MOD 704>,
+		  <&versaclock5 3>, <&usb3s0_clk>;
+	status = "okay";
 };
 
 &usb3s0_clk {
-- 
2.30.2

