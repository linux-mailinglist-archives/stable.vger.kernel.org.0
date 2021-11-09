Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8825344B1F2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 18:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239751AbhKIR1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 12:27:02 -0500
Received: from foss.arm.com ([217.140.110.172]:36470 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236700AbhKIR1C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 12:27:02 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7E7A4ED1;
        Tue,  9 Nov 2021 09:24:15 -0800 (PST)
Received: from e120189.arm.com (unknown [10.57.46.150])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4E9383F800;
        Tue,  9 Nov 2021 09:24:13 -0800 (PST)
From:   Pierre Gondois <Pierre.Gondois@arm.com>
To:     linux-kernel@vger.kernel.org
Cc:     Thanu Rangarajan <Thanu.Rangarajan@arm.com>,
        Sami Mujawar <Sami.Mujawar@arm.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Rob Herring <rob.herring@arm.com>, stable@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH v1] serial: pl011: Add ACPI SBSA UART match id
Date:   Tue,  9 Nov 2021 17:22:48 +0000
Message-Id: <20211109172248.19061-1-Pierre.Gondois@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The document 'ACPI for Arm Components 1.0' defines the following
_HID mappings:
-'Prime cell UART (PL011)': ARMH0011
-'SBSA UART': ARMHB000

Use the sbsa-uart driver when a device is described with
the 'ARMHB000' _HID.

Note:
PL011 devices currently use the sbsa-uart driver instead of the
uart-pl011 driver. Indeed, PL011 devices are not bound to a clock
in ACPI. It is not possible to change their baudrate.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pierre Gondois <Pierre.Gondois@arm.com>
---
 drivers/tty/serial/amba-pl011.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index d361cd84ff8c..52518a606c06 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -2947,6 +2947,7 @@ MODULE_DEVICE_TABLE(of, sbsa_uart_of_match);
 
 static const struct acpi_device_id __maybe_unused sbsa_uart_acpi_match[] = {
 	{ "ARMH0011", 0 },
+	{ "ARMHB000", 0 },
 	{},
 };
 MODULE_DEVICE_TABLE(acpi, sbsa_uart_acpi_match);
-- 
2.17.1

