Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698EB441895
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhKAJt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233144AbhKAJpA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C267760C41;
        Mon,  1 Nov 2021 09:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758996;
        bh=s/GCZQS4eKhH9G78N4AHMdG9j9LpI4/y02eoL8pkNBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pIuhWbbycc/D0zNjqQhmnJ2xdrx2TSVe+NI6ctwynR1nRXUpVGnxhP/QFg+pg1UHY
         8GMco8X4ieB6X/TxRUK9tsB3ppYFMcP62MlKGtXcBUnHOjTGjnVCAtrh4QhU1mX2u+
         FisD3SSOwqWifVlVh09lk+WdQJ53d2fHYP3pyQg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.14 038/125] arm64: dts: imx8mm-kontron: Fix CAN SPI clock frequency
Date:   Mon,  1 Nov 2021 10:16:51 +0100
Message-Id: <20211101082540.377488703@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit ca6f9d85d5944046a241b325700c1ca395651c28 upstream.

The MCP2515 can be used with an SPI clock of up to 10 MHz. Set the
limit accordingly to prevent any performance issues caused by the
really low clock speed of 100 kHz.

This removes the arbitrarily low limit on the SPI frequency, that was
caused by a typo in the original dts.

Without this change, receiving CAN messages on the board beyond a
certain bitrate will cause overrun errors (see 'ip -det -stat link show
can0').

With this fix, receiving messages on the bus works without any overrun
errors for bitrates up to 1 MBit.

Fixes: 8668d8b2e67f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -97,7 +97,7 @@
 		clocks = <&osc_can>;
 		interrupt-parent = <&gpio4>;
 		interrupts = <28 IRQ_TYPE_EDGE_FALLING>;
-		spi-max-frequency = <100000>;
+		spi-max-frequency = <10000000>;
 		vdd-supply = <&reg_vdd_3v3>;
 		xceiver-supply = <&reg_vdd_5v>;
 	};


