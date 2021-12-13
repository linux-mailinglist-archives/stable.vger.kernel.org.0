Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CC6472584
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhLMJoE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:44:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53786 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbhLMJmQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:42:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71B51B80E0D;
        Mon, 13 Dec 2021 09:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FA7C00446;
        Mon, 13 Dec 2021 09:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388534;
        bh=SV/x6J1gN0w/k/mdnKdXukZoNiXNE1bW2fac+g+YaTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KP/QrdAtE8oxcItNy1pXcUxI/ndRbdR1KktjEb2VEvDLUVGT3rwMhBRizAkwei+sp
         nXLYPzMxso7vFskjnkQ/qGrBhuPSGrpO059GML8n3cKDF1YNdCgVifOoRpBclSKtby
         z/xl/hWcgqgDJNc7P3Ok4glMTer+Hf2nYqHADTws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrik John <patrik.john@u-blox.com>
Subject: [PATCH 5.4 01/88] serial: tegra: Change lower tolerance baud rate limit for tegra20 and tegra30
Date:   Mon, 13 Dec 2021 10:29:31 +0100
Message-Id: <20211213092933.297057009@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrik John <patrik.john@u-blox.com>

commit b40de7469ef135161c80af0e8c462298cc5dac00 upstream.

The current implementation uses 0 as lower limit for the baud rate
tolerance for tegra20 and tegra30 chips which causes isses on UART
initialization as soon as baud rate clock is lower than required even
when within the standard UART tolerance of +/- 4%.

This fix aligns the implementation with the initial commit description
of +/- 4% tolerance for tegra chips other than tegra186 and
tegra194.

Fixes: d781ec21bae6 ("serial: tegra: report clk rate errors")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Patrik John <patrik.john@u-blox.com>
Link: https://lore.kernel.org/r/sig.19614244f8.20211123132737.88341-1-patrik.john@u-blox.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial-tegra.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1494,7 +1494,7 @@ static struct tegra_uart_chip_data tegra
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
-	.error_tolerance_low_range	= 0,
+	.error_tolerance_low_range	= -4,
 	.error_tolerance_high_range	= 4,
 };
 
@@ -1505,7 +1505,7 @@ static struct tegra_uart_chip_data tegra
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
-	.error_tolerance_low_range	= 0,
+	.error_tolerance_low_range	= -4,
 	.error_tolerance_high_range	= 4,
 };
 


