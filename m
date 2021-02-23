Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D6F322CA2
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 15:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbhBWOmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 09:42:20 -0500
Received: from smtp64.ord1c.emailsrvr.com ([108.166.43.64]:48435 "EHLO
        smtp64.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232520AbhBWOmM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 09:42:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1614090680;
        bh=ne9eCIiP9mnrfz4MCNNjieytJZ8uysslHZ0TYlQTC0w=;
        h=From:To:Subject:Date:From;
        b=hlzX4YSn4+JeaSn/0604xXsnksJYR+4P3VvSHy7VTkfOeT8Cj2t4HEgls64cXB/EC
         RNVu/MEck2xIHFl1ANJVc2i5vBP/fDtT8+sII04V/pY54wdyQeXe+sbLyN6k/BRWNf
         DZXgH5OODM6gkUmmQHd0zSlhSij03arnZzFuLXBw=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp1.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 3A1AE20158;
        Tue, 23 Feb 2021 09:31:19 -0500 (EST)
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH 02/14] staging: comedi: addi_apci_1500: Fix endian problem for command sample
Date:   Tue, 23 Feb 2021 14:30:43 +0000
Message-Id: <20210223143055.257402-3-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210223143055.257402-1-abbotti@mev.co.uk>
References: <20210223143055.257402-1-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Classification-ID: a7362777-437e-4132-9c26-de9af4db62d3-3-1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 .../staging/comedi/drivers/addi_apci_1500.c    | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index 11efb21555e3..b04c15dcfb57 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -208,7 +208,7 @@ static irqreturn_t apci1500_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct apci1500_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
-	unsigned int status = 0;
+	unsigned short status = 0;
 	unsigned int val;
 
 	val = inl(devpriv->amcc + AMCC_OP_REG_INTCSR);
@@ -238,14 +238,14 @@ static irqreturn_t apci1500_interrupt(int irq, void *d)
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
-- 
2.30.0

