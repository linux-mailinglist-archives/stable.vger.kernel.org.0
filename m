Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D564A424F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349270AbiAaLLX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41462 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376622AbiAaLIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:08:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 417D860B28;
        Mon, 31 Jan 2022 11:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A02C340E8;
        Mon, 31 Jan 2022 11:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627322;
        bh=WIkSwz0/m7xluTgNQRpv2pohUX/lU1/FJ1P7c5Vh3ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSGkh4QPR4OmfKF5zJflRSKPJHD4lURSHX6ghjKAzHNDD6VPPq49J3E9Vz3Wbus/2
         dRYecAj0Xci6UWaiOx3TGs2+tnb1QvMXBDrYaRxENRH03Okwj8vpevmFKCJR+YjgEx
         TW0hy1D4LdtH7PHuDc4WWU3z5TOQX6m0NZFUmTjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Jochen Mades <jochen@mades.net>, Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.15 046/171] serial: pl011: Fix incorrect rs485 RTS polarity on set_mctrl
Date:   Mon, 31 Jan 2022 11:55:11 +0100
Message-Id: <20220131105231.578810721@linuxfoundation.org>
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

From: Jochen Mades <jochen@mades.net>

commit 62f676ff7898f6c1bd26ce014564773a3dc00601 upstream.

Commit 8d479237727c ("serial: amba-pl011: add RS485 support") sought to
keep RTS deasserted on set_mctrl if rs485 is enabled.  However it did so
only if deasserted RTS polarity is high.  Fix it in case it's low.

Fixes: 8d479237727c ("serial: amba-pl011: add RS485 support")
Cc: stable@vger.kernel.org # v5.15+
Cc: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Jochen Mades <jochen@mades.net>
[lukas: copyedit commit message, add stable designation]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/r/85fa3323ba8c307943969b7343e23f34c3e652ba.1642909284.git.lukas@wunner.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/amba-pl011.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -1615,8 +1615,12 @@ static void pl011_set_mctrl(struct uart_
 	    container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
-	if (port->rs485.flags & SER_RS485_ENABLED)
-		mctrl &= ~TIOCM_RTS;
+	if (port->rs485.flags & SER_RS485_ENABLED) {
+		if (port->rs485.flags & SER_RS485_RTS_AFTER_SEND)
+			mctrl &= ~TIOCM_RTS;
+		else
+			mctrl |= TIOCM_RTS;
+	}
 
 	cr = pl011_read(uap, REG_CR);
 


