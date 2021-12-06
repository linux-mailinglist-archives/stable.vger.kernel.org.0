Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A65469F7A
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351033AbhLFPpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359484AbhLFPdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:33:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46FDC09B11E;
        Mon,  6 Dec 2021 07:20:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FF08612C1;
        Mon,  6 Dec 2021 15:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFD5C341C5;
        Mon,  6 Dec 2021 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804001;
        bh=df0+h3IsqOcp+TzXmp5hnNEEZMfdAHU2+0xAwvYyxbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HPt/0urcL/BgTbTQ5E/PBNYHiKxVpH9/EMj360Ez34fl/GNkjD7LX6armjRNG96mu
         qP+dZ27VXj131FlmQzEmLVYlihdHTXsuvzyKBloyi4beA/EvFMdWMZHd2s/Qm6ksGY
         AyNk/U5OLtbhtMKmiplH4HE0KyNsAilOk147+C4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrik John <patrik.john@u-blox.com>
Subject: [PATCH 5.10 122/130] serial: tegra: Change lower tolerance baud rate limit for tegra20 and tegra30
Date:   Mon,  6 Dec 2021 15:57:19 +0100
Message-Id: <20211206145603.870716368@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
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
@@ -1501,7 +1501,7 @@ static struct tegra_uart_chip_data tegra
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
-	.error_tolerance_low_range	= 0,
+	.error_tolerance_low_range	= -4,
 	.error_tolerance_high_range	= 4,
 };
 
@@ -1512,7 +1512,7 @@ static struct tegra_uart_chip_data tegra
 	.fifo_mode_enable_status	= false,
 	.uart_max_port			= 5,
 	.max_dma_burst_bytes		= 4,
-	.error_tolerance_low_range	= 0,
+	.error_tolerance_low_range	= -4,
 	.error_tolerance_high_range	= 4,
 };
 


