Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAD727C748
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbgI2LrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbgI2Lqh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80AEC21924;
        Tue, 29 Sep 2020 11:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379996;
        bh=MUZRsexWMj6Nd/NnD6DI0oJmeatgMcYrj1QVcG2F8sA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2NAZfBPsMwFy4RN+CGMwB6ZwMPDu8sJXGZOVV30CD+jJ4bH/B9IRqDhf8aZo1ozul
         g+JhCsLcpQ0gqLTcGB5dDPvVPjTmGkQ16y5s/lx5djCnZ+GdrjyWhYLY4hZRZMtPS1
         4npPVfddvr4IjMiANX7gxPF5MOxkAXVUxViUuN3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 20/99] riscv: Fix Kendryte K210 device tree
Date:   Tue, 29 Sep 2020 13:01:03 +0200
Message-Id: <20200929105930.719771733@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -95,10 +95,12 @@
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



