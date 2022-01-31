Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182574A4392
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376753AbiAaLV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52318 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378525AbiAaLUS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:20:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1433561120;
        Mon, 31 Jan 2022 11:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE823C340E8;
        Mon, 31 Jan 2022 11:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628017;
        bh=WIkSwz0/m7xluTgNQRpv2pohUX/lU1/FJ1P7c5Vh3ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oYUVWyLFj5GZFISih5dlRLCZ/IychKGRVV4Qm9PG80g4CIvs/vYAJ5E41Inl4AC5q
         qVvFrYUdgwRg0qOZsgUYfggftPay4zJyyGr4o0MTvZDfilLKVv2UDR12Ms9lF2ulM2
         kNaA8VfLoD8PZ/CBzFhZfaNV8aNRfiyhNPMHOnXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Jochen Mades <jochen@mades.net>, Lukas Wunner <lukas@wunner.de>
Subject: [PATCH 5.16 065/200] serial: pl011: Fix incorrect rs485 RTS polarity on set_mctrl
Date:   Mon, 31 Jan 2022 11:55:28 +0100
Message-Id: <20220131105235.758323366@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
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
 


