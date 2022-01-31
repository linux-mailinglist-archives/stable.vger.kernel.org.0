Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7BB4A4219
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358544AbiAaLKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:10:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54076 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358926AbiAaLGO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:06:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCF59B82A6E;
        Mon, 31 Jan 2022 11:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C603FC340E8;
        Mon, 31 Jan 2022 11:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627172;
        bh=DoZ1E/+8ix+OgIbNqPUNVDPpuSpcbXv83pH9UB60g/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JuC7Bok7U+kB85x2SPeAhJ1ud11gf02HV+VK47KWfePS/3CpwT/eKdxQKLfhgUqXc
         efN0l5GHhcdIhg2XcaKfjFCUSboOl2U17k/k5KcjQiVicrs1WwwwdlcksJbMCiO8mh
         7oO71m1tcAUQZ8G1annCzkQD86lIND7XjxLSjn5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 097/100] dt-bindings: can: tcan4x5x: fix mram-cfg RX FIFO config
Date:   Mon, 31 Jan 2022 11:56:58 +0100
Message-Id: <20220131105223.714641649@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
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


