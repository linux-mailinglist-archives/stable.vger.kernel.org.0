Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36CBA404E66
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345148AbhIIMLf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245192AbhIIMJF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:09:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8095A6197A;
        Thu,  9 Sep 2021 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188082;
        bh=MQywcaZDJNRrhwciRFAcjRutyL+bnzQ9Buzvz4rJ118=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNNvU4rkFixLurrZwe8NODfUkp9T/dh/SmmcW2ocezp+HOZtwM17OoLUNU+uHlTDM
         zKBVHtIr2kKHI1qfLrfq6IXv6aP9dtqu2mUNYix3gcsrXIfcfLnxyiMXWaGFUVABeh
         J3iPyDLhxLFJqJeLPltT1muG4d+z1zrSLvlH38gHVvmWKThqXZzGu/XtcDneB897u8
         TfegXZEWDwR6A8k13spvnD743yfk5LVnJNJi8FonGCHWeYQpODiimAfNLRJ7fHdOFo
         RL6ZBKVLQ3yUCkJZTnfgGGVJ71356V7mUwkv7EdwIgiLTF6vUqs+qWubOHL63emOOJ
         IsHY/OnrBlzMg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 067/219] serial: 8250: Define RX trigger levels for OxSemi 950 devices
Date:   Thu,  9 Sep 2021 07:44:03 -0400
Message-Id: <20210909114635.143983-67-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Maciej W. Rozycki" <macro@orcam.me.uk>

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

References:

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
index 9422284bb3f3..81bafcf77bb2 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -122,7 +122,8 @@ static const struct serial8250_config uart_config[] = {
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
index be07b5470f4b..f51bc8f36813 100644
--- a/include/uapi/linux/serial_reg.h
+++ b/include/uapi/linux/serial_reg.h
@@ -62,6 +62,7 @@
  * ST16C654:	 8  16  56  60		 8  16  32  56	PORT_16654
  * TI16C750:	 1  16  32  56		xx  xx  xx  xx	PORT_16750
  * TI16C752:	 8  16  56  60		 8  16  32  56
+ * OX16C950:	16  32 112 120		16  32  64 112	PORT_16C950
  * Tegra:	 1   4   8  14		16   8   4   1	PORT_TEGRA
  */
 #define UART_FCR_R_TRIG_00	0x00
-- 
2.30.2

