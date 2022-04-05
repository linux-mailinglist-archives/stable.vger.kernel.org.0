Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEFF4F2B5B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbiDEJEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242156AbiDEIsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:48:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A3D3585B;
        Tue,  5 Apr 2022 01:37:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31300B81C6D;
        Tue,  5 Apr 2022 08:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E598C385A0;
        Tue,  5 Apr 2022 08:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147819;
        bh=XPHPGC5YYOy1vJKP5EqL9jMeFRnu6hZM2dMkdRnj090=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap+pOpJBNd4CGykoI5eT2ooCIC3nY1XjXObgWr9TDno9yQnJ+WIauYZ45HurJ6yA5
         1w1ysWjiJZxfhyCuM5yxTthofK1ThT9nKdpS6buKXJDgoHPn3RYmxMUCXqookouV7S
         DGw6W6WDrwOnzAzo3aGV8dF6nxWLjM3BzEzqvVx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5.16 0133/1017] arm64: dts: ti: k3-am64: Fix gic-v3 compatible regs
Date:   Tue,  5 Apr 2022 09:17:26 +0200
Message-Id: <20220405070358.150349312@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

commit de60edf1be3d42d4a1b303b41c7c53b2f865726e upstream.

Though GIC ARE option is disabled for no GIC-v2 compatibility,
Cortex-A53 is free to implement the CPU interface as long as it
communicates with the GIC using the stream protocol. This requires
that the SoC integration mark out the PERIPHBASE[1] as reserved area
within the SoC. See longer discussion in [2] for further information.

Update the GIC register map to indicate offsets from PERIPHBASE based
on [3]. Without doing this, systems like kvm will not function with
gic-v2 emulation.

[1] https://developer.arm.com/documentation/ddi0500/e/system-control/aarch64-register-descriptions/configuration-base-address-register--el1
[2] https://lore.kernel.org/all/87k0e0tirw.wl-maz@kernel.org/
[3] https://developer.arm.com/documentation/ddi0500/e/generic-interrupt-controller-cpu-interface/gic-programmers-model/memory-map

Cc: stable@vger.kernel.org
Fixes: 8abae9389bdb ("arm64: dts: ti: Add support for AM642 SoC")
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220215201008.15235-5-nm@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am64-main.dtsi |    5 ++++-
 arch/arm64/boot/dts/ti/k3-am64.dtsi      |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64-main.dtsi
@@ -59,7 +59,10 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
-		      <0x00 0x01840000 0x00 0xC0000>;	/* GICR */
+		      <0x00 0x01840000 0x00 0xC0000>,	/* GICR */
+		      <0x01 0x00000000 0x00 0x2000>,	/* GICC */
+		      <0x01 0x00010000 0x00 0x1000>,	/* GICH */
+		      <0x01 0x00020000 0x00 0x2000>;	/* GICV */
 		/*
 		 * vcpumntirq:
 		 * virtual CPU interface maintenance interrupt
--- a/arch/arm64/boot/dts/ti/k3-am64.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am64.dtsi
@@ -87,6 +87,7 @@
 			 <0x00 0x68000000 0x00 0x68000000 0x00 0x08000000>, /* PCIe DAT0 */
 			 <0x00 0x70000000 0x00 0x70000000 0x00 0x00200000>, /* OC SRAM */
 			 <0x00 0x78000000 0x00 0x78000000 0x00 0x00800000>, /* Main R5FSS */
+			 <0x01 0x00000000 0x01 0x00000000 0x00 0x00310000>, /* A53 PERIPHBASE */
 			 <0x06 0x00000000 0x06 0x00000000 0x01 0x00000000>, /* PCIe DAT1 */
 			 <0x05 0x00000000 0x05 0x00000000 0x01 0x00000000>, /* FSS0 DAT3 */
 


