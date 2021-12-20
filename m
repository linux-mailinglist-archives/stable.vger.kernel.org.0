Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0885F47AFD1
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbhLTPUP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:20:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbhLTPSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:18:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F18EC019D80;
        Mon, 20 Dec 2021 06:59:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4CA8611D7;
        Mon, 20 Dec 2021 14:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E375C36AE7;
        Mon, 20 Dec 2021 14:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012368;
        bh=bwvNNUl+dr3aYwHJw1i/kgznTEnkCAnyQpfCUiC3MCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q1FJiNkctxnBG97aLUysB/dRksODJORqgZUoqBWtdldAQ0v0G1JgEbCKPksWX977Z
         ZtKu21QbmMwnHUt/a7PFl+wGOAEeLTWSC7mdy+4MOeFrnyo8NBGHwBZXZE0gPPnVR/
         vgLtilDDlBo8AurbTOyWgpHbO4oKexG9eSuQbnV4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bin Meng <bin.meng@windriver.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 143/177] riscv: dts: unmatched: Add gpio card detect to mmc-spi-slot
Date:   Mon, 20 Dec 2021 15:34:53 +0100
Message-Id: <20211220143044.897705621@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bin Meng <bin.meng@windriver.com>

commit 298d03c2d7f1b5daacb6d4f4053fd3d677d67087 upstream.

Per HiFive Unmatched schematics, the card detect signal of the
micro SD card is connected to gpio pin #15, which should be
reflected in the DT via the <gpios> property, as described in
Documentation/devicetree/bindings/mmc/mmc-spi-slot.txt.

[1] https://sifive.cdn.prismic.io/sifive/6a06d6c0-6e66-49b5-8e9e-e68ce76f4192_hifive-unmatched-schematics-v3.pdf

Signed-off-by: Bin Meng <bin.meng@windriver.com>
Fixes: d573b5558abb ("riscv: dts: add initial board data for the SiFive HiFive Unmatched")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
+++ b/arch/riscv/boot/dts/sifive/hifive-unmatched-a00.dts
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020 SiFive, Inc */
 
 #include "fu740-c000.dtsi"
+#include <dt-bindings/gpio/gpio.h>
 #include <dt-bindings/interrupt-controller/irq.h>
 
 /* Clock frequency (in Hz) of the PCB crystal for rtcclk */
@@ -228,6 +229,7 @@
 		spi-max-frequency = <20000000>;
 		voltage-ranges = <3300 3300>;
 		disable-wp;
+		gpios = <&gpio 15 GPIO_ACTIVE_LOW>;
 	};
 };
 


