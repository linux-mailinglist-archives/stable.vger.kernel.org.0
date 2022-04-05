Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D7E4F3A9A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381601AbiDELq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354939AbiDEKQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:16:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966F322B0A;
        Tue,  5 Apr 2022 03:04:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3064F616E7;
        Tue,  5 Apr 2022 10:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37597C385A1;
        Tue,  5 Apr 2022 10:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153051;
        bh=CivaMEJcjGKzvh+1Jmorpx4K3eBk7/KE099dJ8YzTMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z+i7eNfSAupJFZLZgL+vBAvTuZSbmYp+cwX7XXEE2d494grbYw5wRHwHUBJrSX8uy
         /T8tW/W4TD7MBhXdKLeTyvZchNmX+0BX3z2ZYiE8i9fh1BPuWg4EISShRxHHbnaYCF
         KBcGfdbM/mRo1S2T60BtMm3P9iOiXS3FZLt2GSLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 5.10 085/599] arm64: dts: ti: k3-am65: Fix gic-v3 compatible regs
Date:   Tue,  5 Apr 2022 09:26:19 +0200
Message-Id: <20220405070301.356958388@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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

commit 8cae268b70f387ff9e697ccd62fb2384079124e7 upstream.

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

Cc: stable@vger.kernel.org # 5.10+
Fixes: ea47eed33a3f ("arm64: dts: ti: Add Support for AM654 SoC")
Reported-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220215201008.15235-2-nm@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi |    5 ++++-
 arch/arm64/boot/dts/ti/k3-am65.dtsi      |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -35,7 +35,10 @@
 		#interrupt-cells = <3>;
 		interrupt-controller;
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
-		      <0x00 0x01880000 0x00 0x90000>;	/* GICR */
+		      <0x00 0x01880000 0x00 0x90000>,	/* GICR */
+		      <0x00 0x6f000000 0x00 0x2000>,	/* GICC */
+		      <0x00 0x6f010000 0x00 0x1000>,	/* GICH */
+		      <0x00 0x6f020000 0x00 0x2000>;	/* GICV */
 		/*
 		 * vcpumntirq:
 		 * virtual CPU interface maintenance interrupt
--- a/arch/arm64/boot/dts/ti/k3-am65.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65.dtsi
@@ -84,6 +84,7 @@
 			 <0x00 0x46000000 0x00 0x46000000 0x00 0x00200000>,
 			 <0x00 0x47000000 0x00 0x47000000 0x00 0x00068400>,
 			 <0x00 0x50000000 0x00 0x50000000 0x00 0x8000000>,
+			 <0x00 0x6f000000 0x00 0x6f000000 0x00 0x00310000>, /* A53 PERIPHBASE */
 			 <0x00 0x70000000 0x00 0x70000000 0x00 0x200000>,
 			 <0x05 0x00000000 0x05 0x00000000 0x01 0x0000000>,
 			 <0x07 0x00000000 0x07 0x00000000 0x01 0x0000000>;


