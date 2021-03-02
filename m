Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9372932B216
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241159AbhCCAwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347018AbhCBRgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 12:36:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D65C064F04;
        Tue,  2 Mar 2021 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614695362;
        bh=+iAu1ljZmM4lUgItwaxYoxwRt7Fh7rTfDpv0wZgbFh8=;
        h=Subject:To:From:Date:From;
        b=xd5BsZidK2zgZbkk3rAQ61NDqrQPO2kBRfwEI27lzVCuzaKMa8JJZ/SXkIPdQ54/v
         1jVrGveZF/4SORwN321nNHRsccRDpg5PunAZAuU08rgNPPi6qhGGIMqRbL1D8A90Qh
         pSVxDiUNlKYj6e2mnMje/jB9jm3Oy2wdRkuPWt04=
Subject: patch "staging: comedi: addi_apci_1500: Fix endian problem for command" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:29:14 +0100
Message-ID: <1614695354226204@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: addi_apci_1500: Fix endian problem for command

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a7638de0988fc5025c6738f5d45180c393d21e33 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 23 Feb 2021 14:30:43 +0000
Subject: staging: comedi: addi_apci_1500: Fix endian problem for command
 sample

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
2.30.1


