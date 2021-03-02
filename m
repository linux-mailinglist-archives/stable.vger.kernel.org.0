Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CACE232B0DE
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbhCCAkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:40:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1448847AbhCBPnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 10:43:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85AEC60232;
        Tue,  2 Mar 2021 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614695356;
        bh=3ClLCmgZvhbX3YMWaAtcF/fnY/98lVJpWXVdRofhRTQ=;
        h=Subject:To:From:Date:From;
        b=Um6jp4iJ8PT63IHbGf5a5UsRszDDHmVtgvQPoNecJcoCD2Lu2cXXHzeiAc+pOq8cX
         S3ZFX2k0ckhHiGUnuR1pM4h7fa9FOwksx1MDrdptOgNZTkQJILoW7toPYWgyBmYj9M
         rK5v7DI5UB8CG/JzKiscQmTuslSHscJX9aROKzgY=
Subject: patch "staging: comedi: addi_apci_1032: Fix endian problem for COS sample" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:29:13 +0100
Message-ID: <1614695353232205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: addi_apci_1032: Fix endian problem for COS sample

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8920b116495ab641a0e0350817157defa0d1ee53 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 23 Feb 2021 14:30:42 +0000
Subject: staging: comedi: addi_apci_1032: Fix endian problem for COS sample

The Change-Of-State (COS) subdevice supports Comedi asynchronous
commands to read 16-bit change-of-state values.  However, the interrupt
handler is calling `comedi_buf_write_samples()` with the address of a
32-bit integer `&s->state`.  On bigendian architectures, it will copy 2
bytes from the wrong end of the 32-bit integer.  Fix it by transferring
the value via a 16-bit integer.

Fixes: 6bb45f2b0c86 ("staging: comedi: addi_apci_1032: use comedi_buf_write_samples()")
Cc: <stable@vger.kernel.org> # 3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-2-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/addi_apci_1032.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1032.c b/drivers/staging/comedi/drivers/addi_apci_1032.c
index 35b75f0c9200..81a246fbcc01 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1032.c
@@ -260,6 +260,7 @@ static irqreturn_t apci1032_interrupt(int irq, void *d)
 	struct apci1032_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned int ctrl;
+	unsigned short val;
 
 	/* check interrupt is from this device */
 	if ((inl(devpriv->amcc_iobase + AMCC_OP_REG_INTCSR) &
@@ -275,7 +276,8 @@ static irqreturn_t apci1032_interrupt(int irq, void *d)
 	outl(ctrl & ~APCI1032_CTRL_INT_ENA, dev->iobase + APCI1032_CTRL_REG);
 
 	s->state = inl(dev->iobase + APCI1032_STATUS_REG) & 0xffff;
-	comedi_buf_write_samples(s, &s->state, 1);
+	val = s->state;
+	comedi_buf_write_samples(s, &val, 1);
 	comedi_handle_events(dev, s);
 
 	/* enable the interrupt */
-- 
2.30.1


