Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD3D04F31C3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344909AbiDEKkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244104AbiDEJlH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:41:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855EFBAB99;
        Tue,  5 Apr 2022 02:25:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E0CAB81C9A;
        Tue,  5 Apr 2022 09:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84980C385A2;
        Tue,  5 Apr 2022 09:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150711;
        bh=Tw2W437NG6DkhChOsRyAuLKEaGoelaEnNQG85SEkRVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O9CEFsXNplKRpqHYjdz+jTdSqsqP3acmpp8tCnyiqMH53KiZzjdr12Jn9qgD4nd7+
         0ppK2AheYLzQHBJvMj6mhRnacB+xDnJKmZz+tfmnEKKP6dcLvHw52MIcQH+/oWj8Jk
         yvJAT/XBUKyEXggPM6evMh9oaDRR+RqmPUXTll0A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5.15 126/913] arm64: dts: ti: k3-j7200: Fix gic-v3 compatible regs
Date:   Tue,  5 Apr 2022 09:19:48 +0200
Message-Id: <20220405070343.606947173@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

commit 1a307cc299430dd7139d351a3b8941f493dfa885 upstream.

Though GIC ARE option is disabled for no GIC-v2 compatibility,
Cortex-A72 is free to implement the CPU interface as long as it
communicates with the GIC using the stream protocol. This requires
that the SoC integration mark out the PERIPHBASE[1] as reserved area
within the SoC. See longer discussion in [2] for further information.

Update the GIC register map to indicate offsets from PERIPHBASE based
on [3]. Without doing this, systems like kvm will not function with
gic-v2 emulation.

[1] https://developer.arm.com/documentation/100095/0002/system-control/aarch64-register-descriptions/configuration-base-address-register--el1
[2] https://lore.kernel.org/all/87k0e0tirw.wl-maz@kernel.org/
[3] https://developer.arm.com/documentation/100095/0002/way1382452674438

Cc: stable@vger.kernel.org
Fixes: d361ed88455f ("arm64: dts: ti: Add support for J7200 SoC")
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220215201008.15235-4-nm@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi |    5 ++++-
 arch/arm64/boot/dts/ti/k3-j7200.dtsi      |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -54,7 +54,10 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
-		      <0x00 0x01900000 0x00 0x100000>;	/* GICR */
+		      <0x00 0x01900000 0x00 0x100000>,	/* GICR */
+		      <0x00 0x6f000000 0x00 0x2000>,	/* GICC */
+		      <0x00 0x6f010000 0x00 0x1000>,	/* GICH */
+		      <0x00 0x6f020000 0x00 0x2000>;	/* GICV */
 
 		/* vcpumntirq: virtual CPU interface maintenance interrupt */
 		interrupts = <GIC_PPI 9 IRQ_TYPE_LEVEL_HIGH>;
--- a/arch/arm64/boot/dts/ti/k3-j7200.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200.dtsi
@@ -127,6 +127,7 @@
 			 <0x00 0x00a40000 0x00 0x00a40000 0x00 0x00000800>, /* timesync router */
 			 <0x00 0x01000000 0x00 0x01000000 0x00 0x0d000000>, /* Most peripherals */
 			 <0x00 0x30000000 0x00 0x30000000 0x00 0x0c400000>, /* MAIN NAVSS */
+			 <0x00 0x6f000000 0x00 0x6f000000 0x00 0x00310000>, /* A72 PERIPHBASE */
 			 <0x00 0x70000000 0x00 0x70000000 0x00 0x00800000>, /* MSMC RAM */
 			 <0x00 0x18000000 0x00 0x18000000 0x00 0x08000000>, /* PCIe1 DAT0 */
 			 <0x41 0x00000000 0x41 0x00000000 0x01 0x00000000>, /* PCIe1 DAT1 */


