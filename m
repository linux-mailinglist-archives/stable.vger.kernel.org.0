Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89EB29BE3D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794293AbgJ0PLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794288AbgJ0PK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:10:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFE6C21D24;
        Tue, 27 Oct 2020 15:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811459;
        bh=b6xTm3LVmIjh+LuDnzjD1HzlJ7Infz157Bmi9C7X6wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwlWRg11oD8oUnYiOCcNMs9Z5nXyGxl1aB5BEW89X+OgQgqTO+XmswP6AuIVMX388
         qInBfooEp9bInLesNAVEcxMBOF8ZAxplJJiGZ5kSZNX6ciRlPCeZthoWsQpepmIesk
         tUA6Ld/vIWW+Jy5p1FJ0dpcmUDYUzYqSG056v36I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 500/633] arm64: dts: renesas: r8a77990: Fix MSIOF1 DMA channels
Date:   Tue, 27 Oct 2020 14:54:03 +0100
Message-Id: <20201027135546.183947753@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 453802c463abd003a7c38ffbc90b67ba162335b6 ]

According to Technical Update TN-RCT-S0352A/E, MSIOF1 DMA can only be
used with SYS-DMAC0 on R-Car E3.

Fixes: 8517042060b55a37 ("arm64: dts: renesas: r8a77990: Add DMA properties to MSIOF nodes")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20200917132117.8515-2-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index 1991bdc36792f..27f74df8efbde 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -1192,9 +1192,8 @@ msiof1: spi@e6ea0000 {
 			reg = <0 0xe6ea0000 0 0x0064>;
 			interrupts = <GIC_SPI 157 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&cpg CPG_MOD 210>;
-			dmas = <&dmac1 0x43>, <&dmac1 0x42>,
-			       <&dmac2 0x43>, <&dmac2 0x42>;
-			dma-names = "tx", "rx", "tx", "rx";
+			dmas = <&dmac0 0x43>, <&dmac0 0x42>;
+			dma-names = "tx", "rx";
 			power-domains = <&sysc R8A77990_PD_ALWAYS_ON>;
 			resets = <&cpg 210>;
 			#address-cells = <1>;
-- 
2.25.1



