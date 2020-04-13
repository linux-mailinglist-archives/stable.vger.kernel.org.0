Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73C31A6837
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 16:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730826AbgDMOdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 10:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728807AbgDMOdj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Apr 2020 10:33:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D0E12075E;
        Mon, 13 Apr 2020 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586788419;
        bh=98rVyj+nCH2i/2vV5bKm012blijTL82xoV+8Es7hhgE=;
        h=Subject:To:From:Date:From;
        b=Oe8kveIQMyHFRpy1eEoPx4nRht72HQpXKY/kBrJoqhgTN8FXPLTR/MWIqcsKyX4Fl
         duNm5E9gjwUYdGdGImxbS4gyVFWCWICVe3xhF428eBxmlDL5CwLx6xrel4rnNn1Xsy
         msAKOBRkZemYNULq+oeouK6LWR+/AST4bLgC97RE=
Subject: patch "staging: comedi: dt2815: fix writing hi byte of analog output" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Apr 2020 16:33:28 +0200
Message-ID: <15867884082078@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: dt2815: fix writing hi byte of analog output

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ed87d33ddbcd9a1c3b5ae87995da34e6f51a862c Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Mon, 6 Apr 2020 15:20:15 +0100
Subject: staging: comedi: dt2815: fix writing hi byte of analog output

The DT2815 analog output command is 16 bits wide, consisting of the
12-bit sample value in bits 15 to 4, the channel number in bits 3 to 1,
and a voltage or current selector in bit 0.  Both bytes of the 16-bit
command need to be written in turn to a single 8-bit data register.
However, the driver currently only writes the low 8-bits.  It is broken
and appears to have always been broken.

Electronic copies of the DT2815 User's Manual seem impossible to find
online, but looking at the source code, a best guess for the sequence
the driver intended to use to write the analog output command is as
follows:

1. Wait for the status register to read 0x00.
2. Write the low byte of the command to the data register.
3. Wait for the status register to read 0x80.
4. Write the high byte of the command to the data register.

Step 4 is missing from the driver.  Add step 4 to (hopefully) fix the
driver.

Also add a "FIXME" comment about setting bit 0 of the low byte of the
command.  Supposedly, it is used to choose between voltage output and
current output, but the current driver always sets it to 1.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200406142015.126982-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dt2815.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/comedi/drivers/dt2815.c b/drivers/staging/comedi/drivers/dt2815.c
index 83026ba63d1c..78a7c1b3448a 100644
--- a/drivers/staging/comedi/drivers/dt2815.c
+++ b/drivers/staging/comedi/drivers/dt2815.c
@@ -92,6 +92,7 @@ static int dt2815_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 	int ret;
 
 	for (i = 0; i < insn->n; i++) {
+		/* FIXME: lo bit 0 chooses voltage output or current output */
 		lo = ((data[i] & 0x0f) << 4) | (chan << 1) | 0x01;
 		hi = (data[i] & 0xff0) >> 4;
 
@@ -105,6 +106,8 @@ static int dt2815_ao_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 		if (ret)
 			return ret;
 
+		outb(hi, dev->iobase + DT2815_DATA);
+
 		devpriv->ao_readback[chan] = data[i];
 	}
 	return i;
-- 
2.26.0


