Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F5C4A4179
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358794AbiAaLEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:04:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359013AbiAaLCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:02:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B5CC06176D;
        Mon, 31 Jan 2022 03:00:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15B7D60A75;
        Mon, 31 Jan 2022 11:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC65C340E8;
        Mon, 31 Jan 2022 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626858;
        bh=DoZ1E/+8ix+OgIbNqPUNVDPpuSpcbXv83pH9UB60g/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ov1UPJhItPnWCL9eFPn4NVZwlr+1XNM87qkZLhlmpZt44N686PuGlbBVL4Kzqq4pa
         T3rsi0XUVGmcJarlIgXZNM7ViyoPygsXjxPOgOIogi4Lw5sQj0cBZFKFMN/UbyAqYu
         AclrFwrSIxcayWHMtch8btkPW7tyepcY4RG80BvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 62/64] dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config
Date:   Mon, 31 Jan 2022 11:56:47 +0100
Message-Id: <20220131105217.757376575@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105215.644174521@linuxfoundation.org>
References: <20220131105215.644174521@linuxfoundation.org>
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


