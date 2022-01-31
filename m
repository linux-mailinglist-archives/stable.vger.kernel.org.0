Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52F734A4311
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359366AbiAaLQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:16:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48256 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359406AbiAaLOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:14:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27BDA611C1;
        Mon, 31 Jan 2022 11:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D9DC340E8;
        Mon, 31 Jan 2022 11:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627688;
        bh=DoZ1E/+8ix+OgIbNqPUNVDPpuSpcbXv83pH9UB60g/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHrt6u8hIacXkOzYDfU83Yv0g8uQBj3o+4Qv1fQ+0PD3gkV09T7L6eUGpfY103LHD
         kB3Oid/wHoEBbuYbdGkdPiQn91jmBXznzD6FAfIdRF4ZIzfpT3I3LL7aAuHi5I0oAW
         Gw+d8FoN/PdRhj7vFbqOo7obo1LncxLTQNTLoNA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 164/171] dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config
Date:   Mon, 31 Jan 2022 11:57:09 +0100
Message-Id: <20220131105235.555394997@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 17a30422621c0e04cb6060d20d7edcefd7463347 upstream.

This tcan4x5x only comes with 2K of MRAM, a RX FIFO with a dept of 32
doesn't fit into the MRAM. Use a depth of 16 instead.

Fixes: 4edd396a1911 ("dt-bindings: can: tcan4x5x: Add DT bindings for TCAN4x5X driver")
Link: https://lore.kernel.org/all/20220119062951.2939851-1-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/can/tcan4x5x.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
+++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
@@ -31,7 +31,7 @@ tcan4x5x: tcan4x5x@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
 		spi-max-frequency = <10000000>;
-		bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
+		bosch,mram-cfg = <0x0 0 0 16 0 0 1 1>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <14 IRQ_TYPE_LEVEL_LOW>;
 		device-state-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;


