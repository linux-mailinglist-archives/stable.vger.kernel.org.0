Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C1132B0D8
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236912AbhCCAjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:39:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1448616AbhCBPHs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 10:07:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 128F36186A;
        Tue,  2 Mar 2021 14:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614695359;
        bh=5kQrmEJrklsGrRbr/nmG1FPytOFjfESx8KjxjPEQOAU=;
        h=Subject:To:From:Date:From;
        b=patuDXWIRvL5dN8/ngPlKYhc3jtBvdJHyg4JJ7ad3Vf4JLXuD+d3kBLQuVjYmx7bn
         ybE8CRUhl3yfBeqyRIHojMYNg1ImK/NSNJbUYVEl4VVSJILmrRSr/PDzmyU3oDxT3k
         dLS2kRJh78FFS+Tf71PPoZpBTuo5r0s6KJUUfKx4=
Subject: patch "staging: comedi: adv_pci1710: Fix endian problem for AI command data" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Mar 2021 15:29:14 +0100
Message-ID: <161469535498133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: adv_pci1710: Fix endian problem for AI command data

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9f17114aa8324c61eda74668d56b7dba8c56d049 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Tue, 23 Feb 2021 14:30:44 +0000
Subject: staging: comedi: adv_pci1710: Fix endian problem for AI command data

The analog input subdevice supports Comedi asynchronous commands that
use Comedi's 16-bit sample format.  However, the calls to
`comedi_buf_write_samples()` are passing the address of a 32-bit integer
variable.  On bigendian machines, this will copy 2 bytes from the wrong
end of the 32-bit value.  Fix it by changing the type of the variables
holding the sample value to `unsigned short`.  The type of the `val`
parameter of `pci1710_ai_read_sample()` is changed to `unsigned short *`
accordingly.  The type of the `val` variable in `pci1710_ai_insn_read()`
is also changed to `unsigned short` since its address is passed to
`pci1710_ai_read_sample()`.

Fixes: a9c3a015c12f ("staging: comedi: adv_pci1710: use comedi_buf_write_samples()")
Cc: <stable@vger.kernel.org> # 4.0+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20210223143055.257402-4-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 692893c7e5c3..090607760be6 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -300,11 +300,11 @@ static int pci1710_ai_eoc(struct comedi_device *dev,
 static int pci1710_ai_read_sample(struct comedi_device *dev,
 				  struct comedi_subdevice *s,
 				  unsigned int cur_chan,
-				  unsigned int *val)
+				  unsigned short *val)
 {
 	const struct boardtype *board = dev->board_ptr;
 	struct pci1710_private *devpriv = dev->private;
-	unsigned int sample;
+	unsigned short sample;
 	unsigned int chan;
 
 	sample = inw(dev->iobase + PCI171X_AD_DATA_REG);
@@ -345,7 +345,7 @@ static int pci1710_ai_insn_read(struct comedi_device *dev,
 	pci1710_ai_setup_chanlist(dev, s, &insn->chanspec, 1, 1);
 
 	for (i = 0; i < insn->n; i++) {
-		unsigned int val;
+		unsigned short val;
 
 		/* start conversion */
 		outw(0, dev->iobase + PCI171X_SOFTTRG_REG);
@@ -395,7 +395,7 @@ static void pci1710_handle_every_sample(struct comedi_device *dev,
 {
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned int status;
-	unsigned int val;
+	unsigned short val;
 	int ret;
 
 	status = inw(dev->iobase + PCI171X_STATUS_REG);
@@ -455,7 +455,7 @@ static void pci1710_handle_fifo(struct comedi_device *dev,
 	}
 
 	for (i = 0; i < devpriv->max_samples; i++) {
-		unsigned int val;
+		unsigned short val;
 		int ret;
 
 		ret = pci1710_ai_read_sample(dev, s, s->async->cur_chan, &val);
-- 
2.30.1


