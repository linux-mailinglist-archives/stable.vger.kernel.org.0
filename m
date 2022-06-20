Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644175519EC
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243446AbiFTNAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244046AbiFTM7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 08:59:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2BA1C126;
        Mon, 20 Jun 2022 05:56:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36BD8B811BD;
        Mon, 20 Jun 2022 12:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972E0C3411B;
        Mon, 20 Jun 2022 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729760;
        bh=sOZBAWivpOdaJB97LH1wnMTFxhDL3WcJmZwd5LtZD4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcuUflVzI3njIFWc7EJm2sYFDb2s2MWZudcHD94VT8IogvPG+i4KmMx187Lhz3MAB
         lHi7XKyHOqxP94BR2hmmBePdYSD3rQNZylUFYspDYfOdAyV+yOWAOIgFeqvZgEBehb
         fNpcRYN3jlJJgxf7frjUYpcUQMyb+LKUafukLWA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 065/141] riscv: dts: microchip: re-add pdma to mpfs device tree
Date:   Mon, 20 Jun 2022 14:50:03 +0200
Message-Id: <20220620124731.461595614@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 5e757deddd918edb8cb2fdb56eb79656ffc6dade ]

PolarFire SoC /does/ have a SiFive pdma, despite what I suggested as a
conflict resolution to Zong. Somehow the entry fell through the cracks
between versions of my dt patches, so re-add it with Zong's updated
compatible & dma-channels property.

Fixes: c5094f371008 ("riscv: dts: microchip: refactor icicle kit device tree")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
index cf2f55e1dcb6..f44fce1fe080 100644
--- a/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi
@@ -188,6 +188,15 @@
 			riscv,ndev = <186>;
 		};
 
+		pdma: dma-controller@3000000 {
+			compatible = "sifive,fu540-c000-pdma", "sifive,pdma0";
+			reg = <0x0 0x3000000 0x0 0x8000>;
+			interrupt-parent = <&plic>;
+			interrupts = <5 6>, <7 8>, <9 10>, <11 12>;
+			dma-channels = <4>;
+			#dma-cells = <1>;
+		};
+
 		clkcfg: clkcfg@20002000 {
 			compatible = "microchip,mpfs-clkcfg";
 			reg = <0x0 0x20002000 0x0 0x1000>, <0x0 0x3E001000 0x0 0x1000>;
-- 
2.35.1



