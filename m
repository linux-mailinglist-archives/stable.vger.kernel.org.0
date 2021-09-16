Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8C240E710
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347710AbhIPR2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:28:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348357AbhIPRZz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:25:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F2861BF9;
        Thu, 16 Sep 2021 16:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810682;
        bh=ezkR6FE9Ez4NXnqgMlKtUypzQDU5EPkRhUYB0p2hiQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2LMxyjtZ0mO1sgM4EhnkVdV3kd1ehjtvf4DHwxxzihuTUsF0Sxj5F4qR6jBCSYkK
         qcx4REfkZTOtfp4RvB/oTEh1+0sJBc3yppz6+xjHX5cMrpTjQ2nqzbl6s3nFTVLeI8
         nDjg60orZoQNvj/IBimL9LYjAlIdBfeNOVB4/yGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 229/432] serial: 8250: Define RX trigger levels for OxSemi 950 devices
Date:   Thu, 16 Sep 2021 17:59:38 +0200
Message-Id: <20210916155818.603483573@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index 1da29a219842..66374704747e 100644
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



