Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887113D298F
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhGVQF3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233799AbhGVQEE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:04:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DE546144E;
        Thu, 22 Jul 2021 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972275;
        bh=R9ScnCrG87AF3A2JLubrsMZUQzn4JC7aLUJTqmsfxWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYgX7jrDOZuSK6BB2XfHPV8zYwrME4maKMVjIqBxFwE5jS5c8lKUWZ5XW8AGvEneh
         GhUUAUiYpgZ0lrCeljkqFX1Mhyv8i7WxnsAL8CIkfFMu4q6laCyu8J/tkLbR9BYlhz
         fxZyWTbJwlCcgyAa/gL8gsgamI0b7Zmo4A6oxExE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adam Ford <aford173@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 035/156] arm64: dts: renesas: beacon: Fix USB extal reference
Date:   Thu, 22 Jul 2021 18:30:10 +0200
Message-Id: <20210722155629.554149090@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -319,8 +319,10 @@
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



