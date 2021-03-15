Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C25733B584
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhCONym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231377AbhCONyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:54:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9E41601FD;
        Mon, 15 Mar 2021 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816447;
        bh=SjQzFgZNl0ceigZk74ClIsEtdipV2riX7BXRcPhYQa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DNi4x2sTbQd78Qzxjbc2IsppT4PKVXjISEmTLcHd/yEwuGCn/yLApJCpOKk7B+ERg
         d39l5eWAl4EDXN10VX+eOpTWcDpdSWsISDjPDGl9la4ahKT4nI0wIWZ9KR0pLAlRWp
         5YmnBC9Jng2rSa5EkL+DKcNyElfB9A/l6Sk4TU78=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.4 50/75] staging: comedi: addi_apci_1500: Fix endian problem for command sample
Date:   Mon, 15 Mar 2021 14:52:04 +0100
Message-Id: <20210315135209.882783287@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
References: <20210315135208.252034256@linuxfoundation.org>
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


