Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C208E272865
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgIUOm5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:49800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbgIUOk5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDA5423787;
        Mon, 21 Sep 2020 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699253;
        bh=FmF/pbUJKzdSITSRYqcFNxLSTZy8+HviO1AYZWdz6Y4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Np9xI6HEtyAPHhyAQjaKte+AqInv4ee4nuCQ3q8acZYja8DHC9y8a8nPq2SjmB4yn
         0n3H1bYpLkbtzTZr9GGx2tvN33SI/ccW8ykXZiQyHWm28rk8IoVPql5IgG4/AjTzyW
         HP+4XcIm9ToBfSbRfkltX0AWXDnL5rNVF+ac5YRM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Damien Le Moal <damien.lemoal@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 20/20] riscv: Fix Kendryte K210 device tree
Date:   Mon, 21 Sep 2020 10:40:27 -0400
Message-Id: <20200921144027.2135390-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

[ Upstream commit f025d9d9934b84cd03b7796072d10686029c408e ]

The Kendryte K210 SoC CLINT is compatible with Sifive clint v0
(sifive,clint0). Fix the Kendryte K210 device tree clint entry to be
inline with the sifive timer definition documented in
Documentation/devicetree/bindings/timer/sifive,clint.yaml.
The device tree clint entry is renamed similarly to u-boot device tree
definition to improve compatibility with u-boot defined device tree.
To ensure correct initialization, the interrup-cells attribute is added
and the interrupt-extended attribute definition fixed.

This fixes boot failures with Kendryte K210 SoC boards.

Note that the clock referenced is kept as K210_CLK_ACLK, which does not
necessarilly match the clint MTIME increment rate. This however does not
seem to cause any problem for now.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/kendryte/k210.dtsi | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/boot/dts/kendryte/k210.dtsi b/arch/riscv/boot/dts/kendryte/k210.dtsi
index c1df56ccb8d55..d2d0ff6456325 100644
--- a/arch/riscv/boot/dts/kendryte/k210.dtsi
+++ b/arch/riscv/boot/dts/kendryte/k210.dtsi
@@ -95,10 +95,12 @@ sysctl: sysctl@50440000 {
 			#clock-cells = <1>;
 		};
 
-		clint0: interrupt-controller@2000000 {
+		clint0: clint@2000000 {
+			#interrupt-cells = <1>;
 			compatible = "riscv,clint0";
 			reg = <0x2000000 0xC000>;
-			interrupts-extended = <&cpu0_intc 3>,  <&cpu1_intc 3>;
+			interrupts-extended =  <&cpu0_intc 3 &cpu0_intc 7
+						&cpu1_intc 3 &cpu1_intc 7>;
 			clocks = <&sysctl K210_CLK_ACLK>;
 		};
 
-- 
2.25.1

