Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66497579D5D
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241880AbiGSMuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242225AbiGSMtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:49:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91CE43315;
        Tue, 19 Jul 2022 05:19:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1502EB81B10;
        Tue, 19 Jul 2022 12:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753D7C341C6;
        Tue, 19 Jul 2022 12:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233190;
        bh=svGjCciLe2V3mMCFmTerpL7i6k7+OeAHHrb161NsqsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1h6r78PNyQytGLOGvwQpIOqmNmkejbnP0tABapufkYHKhAvRa2UPKflXajJCZU+SZ
         jzMH2a0Taje1ufQVZzbSt8MHtF2AzTWDxSHzKxIUnJ4VslhA7VJQdAkfLE2e6C7v+j
         5gxLh/8aCCaTe0m55X9rgOu0T/g2/S4MNcqOYz3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Daire McNamara <daire.mcnamara@microchip.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 038/231] riscv: dts: microchip: hook up the mpfs l2cache
Date:   Tue, 19 Jul 2022 13:52:03 +0200
Message-Id: <20220719114717.386407986@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit efa310ba00716d7a872bdc5fa1f5545edc9efd69 ]

The initial PolarFire SoC devicetree must have been forked off from
the fu540 one prior to the addition of l2cache controller support being
added there. When the controller node was added to mpfs.dtsi, it was
not hooked up to the CPUs & thus sysfs reports an incorrect cache
configuration. Hook it up.

Fixes: 0fa6107eca41 ("RISC-V: Initial DTS for Microchip ICICLE board")
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Reviewed-by: Daire McNamara <daire.mcnamara@microchip.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index f44fce1fe080..2f75e39d2fdd 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -51,6 +51,7 @@ cpu1: cpu@1 {
 			riscv,isa = "rv64imafdc";
 			clocks = <&clkcfg CLK_CPU>;
 			tlb-split;
+			next-level-cache = <&cctrllr>;
 			status = "okay";
 
 			cpu1_intc: interrupt-controller {
@@ -78,6 +79,7 @@ cpu2: cpu@2 {
 			riscv,isa = "rv64imafdc";
 			clocks = <&clkcfg CLK_CPU>;
 			tlb-split;
+			next-level-cache = <&cctrllr>;
 			status = "okay";
 
 			cpu2_intc: interrupt-controller {
@@ -105,6 +107,7 @@ cpu3: cpu@3 {
 			riscv,isa = "rv64imafdc";
 			clocks = <&clkcfg CLK_CPU>;
 			tlb-split;
+			next-level-cache = <&cctrllr>;
 			status = "okay";
 
 			cpu3_intc: interrupt-controller {
@@ -132,6 +135,7 @@ cpu4: cpu@4 {
 			riscv,isa = "rv64imafdc";
 			clocks = <&clkcfg CLK_CPU>;
 			tlb-split;
+			next-level-cache = <&cctrllr>;
 			status = "okay";
 			cpu4_intc: interrupt-controller {
 				#interrupt-cells = <1>;
-- 
2.35.1



