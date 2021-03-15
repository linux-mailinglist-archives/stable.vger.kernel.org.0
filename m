Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D3D33B5B7
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhCONzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:55:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhCONyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8850864EF3;
        Mon, 15 Mar 2021 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816460;
        bh=SjQzFgZNl0ceigZk74ClIsEtdipV2riX7BXRcPhYQa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8MMfg74Bz3oK/VCuqZGr5gDwnV4HN6P4movutyKM8Fakl6bJ+5BUhNyvO0znwVdT
         q3jBsmvUf8RTBj4IZcnhdoA/49WkuzU8C18Z5ETazfl6OGGQa+wsuM1xKMoslmtN4F
         k/eXJN2dN6DJu1kE58PgMmO9wJ58EGIb9Z9Ohmvs=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.9 52/78] staging: comedi: addi_apci_1500: Fix endian problem for command sample
Date:   Mon, 15 Mar 2021 14:52:15 +0100
Message-Id: <20210315135213.787357076@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135212.060847074@linuxfoundation.org>
References: <20210315135212.060847074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ian Abbott <abbotti@mev.co.uk>

commit ac0bbf55ed3be75fde1f8907e91ecd2fd589bde3 upstream.

The digital input subdevice supports Comedi asynchronous commands that
read interrupt status information.  This uses 16-bit Comedi samples (of
which only the bottom 8 bits contain status information).  However, the
interrupt handler is calling `comedi_buf_write_samples()` with the
address of a 32-bit variable `unsigned int status`.  On a bigendian
machine, this will copy 2 bytes from the wrong end of the variable.  Fix
it by changing the type of the variable to `unsigned short`.

Fixes: a8c66b684efa ("staging: comedi: addi_apci_1500: rewrite the subdevice support functions")
Cc: <stable@vger.kernel.org> #4.0+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-3-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/addi_apci_1500.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -217,7 +217,7 @@ static irqreturn_t apci1500_interrupt(in
 	struct comedi_device *dev = d;
 	struct apci1500_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
-	unsigned int status = 0;
+	unsigned short status = 0;
 	unsigned int val;
 
 	val = inl(devpriv->amcc + AMCC_OP_REG_INTCSR);
@@ -247,14 +247,14 @@ static irqreturn_t apci1500_interrupt(in
 	 *
 	 *    Mask     Meaning
 	 * ----------  ------------------------------------------
-	 * 0x00000001  Event 1 has occurred
-	 * 0x00000010  Event 2 has occurred
-	 * 0x00000100  Counter/timer 1 has run down (not implemented)
-	 * 0x00001000  Counter/timer 2 has run down (not implemented)
-	 * 0x00010000  Counter 3 has run down (not implemented)
-	 * 0x00100000  Watchdog has run down (not implemented)
-	 * 0x01000000  Voltage error
-	 * 0x10000000  Short-circuit error
+	 * 0b00000001  Event 1 has occurred
+	 * 0b00000010  Event 2 has occurred
+	 * 0b00000100  Counter/timer 1 has run down (not implemented)
+	 * 0b00001000  Counter/timer 2 has run down (not implemented)
+	 * 0b00010000  Counter 3 has run down (not implemented)
+	 * 0b00100000  Watchdog has run down (not implemented)
+	 * 0b01000000  Voltage error
+	 * 0b10000000  Short-circuit error
 	 */
 	comedi_buf_write_samples(s, &status, 1);
 	comedi_handle_events(dev, s);


