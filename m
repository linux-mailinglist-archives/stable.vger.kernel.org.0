Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81177411AB0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244781AbhITQvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244437AbhITQuP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDA2761244;
        Mon, 20 Sep 2021 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156528;
        bh=xTqlFBBj4RCqG2KmcSSKcapX/VO7ngz5/SxH7nClmvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J58YLwUNdt5YLCWt9WiNAKpj+SRHDCqIRiztEeGtV4pLYWg0KPR/mYiR6wD+XnfPl
         UBiVzFqi0nrOUuZLxjZkDfrCf4fToGiCrs1SQYEQzXKdJxBA8WGtc7/ifY0FcySuN5
         FUv8gujS6OoUQsKGFGz1GlQFL5G9k68QSXJYkIt0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 101/133] serial: 8250: Define RX trigger levels for OxSemi 950 devices
Date:   Mon, 20 Sep 2021 18:42:59 +0200
Message-Id: <20210920163915.933901525@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit d7aff291d069c4418285f3c8ee27b0ff67ce5998 ]

Oxford Semiconductor 950 serial port devices have a 128-byte FIFO and in
the enhanced (650) mode, which we select in `autoconfig_has_efr' with
the ECB bit set in the EFR register, they support the receive interrupt
trigger level selectable with FCR bits 7:6 from the set of 16, 32, 112,
120.  This applies to the original OX16C950 discrete UART[1] as well as
950 cores embedded into more complex devices.

For these devices we set the default to 112, which sets an excessively
high level of 112 or 7/8 of the FIFO capacity, unlike with other port
types where we choose at most 1/2 of their respective FIFO capacities.
Additionally we don't make the trigger level configurable.  Consequently
frequent input overruns happen with high bit rates where hardware flow
control cannot be used (e.g. terminal applications) even with otherwise
highly-performant systems.

Lower the default receive interrupt trigger level to 32 then, and make
it configurable.  Document the trigger levels along with other port
types, including the set of 16, 32, 64, 112 for the transmit interrupt
as well[2].


[1] "OX16C950 rev B High Performance UART with 128 byte FIFOs", Oxford
    Semiconductor, Inc., DS-0031, Sep 05, Table 10: "Receiver Trigger
    Levels", p. 22

[2] same, Table 9: "Transmit Interrupt Trigger Levels", p. 22

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2106260608480.37803@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 3 ++-
 include/uapi/linux/serial_reg.h     | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 041bfe1d4191..d0d90752f9f3 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -124,7 +124,8 @@ static const struct serial8250_config uart_config[] = {
 		.name		= "16C950/954",
 		.fifo_size	= 128,
 		.tx_loadsz	= 128,
-		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01,
+		.rxtrig_bytes	= {16, 32, 112, 120},
 		/* UART_CAP_EFR breaks billionon CF bluetooth card. */
 		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP,
 	},
diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
index 1e5ac4e776da..5bcc637cee46 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -61,6 +61,7 @@
  * ST16C654:	 8  16  56  60		 8  16  32  56	PORT_16654
  * TI16C750:	 1  16  32  56		xx  xx  xx  xx	PORT_16750
  * TI16C752:	 8  16  56  60		 8  16  32  56
+ * OX16C950:	16  32 112 120		16  32  64 112	PORT_16C950
  * Tegra:	 1   4   8  14		16   8   4   1	PORT_TEGRA
  */
 #define UART_FCR_R_TRIG_00	0x00
-- 
2.30.2



