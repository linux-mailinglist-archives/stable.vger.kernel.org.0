Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4AF303F83
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 15:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405675AbhAZOAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 09:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:50032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405672AbhAZOAk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 Jan 2021 09:00:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC2AC2255F;
        Tue, 26 Jan 2021 13:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611669599;
        bh=UJdTGuP7kPmv4EQdEgDLzSPN4IacqDna8sDBPRJVI5A=;
        h=From:To:Cc:Subject:Date:From;
        b=dML41tYYbb/MRZUR6/gda1UEqcGvkrsPYJaqPOta30Rkj4/uaU1RoM8j2E1xV5TSl
         A/N9hujrBsphMVhGAevoiqKrWAWJb0V3Hd+KtalI3ZiFdPg4/K4zXE0rL1Trr6EeIN
         QrHVcj4YCMYlr8eIerdL7mX9woxQ0TiVTiabKTZoYXpSXSV961QKys/IPGxIygAI/c
         NHemqfjNSQ+a5XvxXuU8iikLLWJLTHLfoySPIRgwRDPOfR4RA9KKgS/4H3QNssuUul
         SKRMDohTSDF4Qjq9sWCcBWTsgzJcm2LlT/67eo478EJIjZaRsRUx+wkseKrBdND6Xf
         ILJciOyQT7hOg==
Received: from johan by xi.lan with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1l4Ot6-0004Zr-B7; Tue, 26 Jan 2021 15:00:09 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>, Vladimir <svv75@mail.ru>,
        stable@vger.kernel.org
Subject: [PATCH] USB: serial: ftdi_sio: fix FTX sub-integer prescaler
Date:   Tue, 26 Jan 2021 14:59:17 +0100
Message-Id: <20210126135917.17545-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The most-significant bit of the sub-integer-prescaler index is set in
the high byte of the baudrate request wIndex also for FTX devices.

This fixes rates like 1152000 which got mapped to 12 MBd.

Reported-by: Vladimir <svv75@mail.ru>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=210351
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/ftdi_sio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 94398f89e600..4168801b9595 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -1386,8 +1386,9 @@ static int change_speed(struct tty_struct *tty, struct usb_serial_port *port)
 	index_value = get_ftdi_divisor(tty, port);
 	value = (u16)index_value;
 	index = (u16)(index_value >> 16);
-	if ((priv->chip_type == FT2232C) || (priv->chip_type == FT2232H) ||
-		(priv->chip_type == FT4232H) || (priv->chip_type == FT232H)) {
+	if (priv->chip_type == FT2232C || priv->chip_type == FT2232H ||
+			priv->chip_type == FT4232H || priv->chip_type == FT232H ||
+			priv->chip_type == FTX) {
 		/* Probably the BM type needs the MSB of the encoded fractional
 		 * divider also moved like for the chips above. Any infos? */
 		index = (u16)((index << 8) | priv->interface);
-- 
2.26.2

