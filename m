Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7427A5B551
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 08:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfGAGuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 02:50:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbfGAGuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 02:50:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C35F42145D;
        Mon,  1 Jul 2019 06:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561963851;
        bh=7nzKvt+7B2XKfbu0nSHdubjTLdTTm4J0NU7lqjrzz34=;
        h=Subject:To:From:Date:From;
        b=VmdwFyKpgVmHIomA4sX7jheXmeKaAaa/YRDOCfuSVXW08/5DHabKJKp2Hwo11CDRp
         PqaAVwPFulYgWqG2xhkigpS40CvlAXLF3G9m2M3rWtJobyIADCTa2Hl3wuOk0rE/su
         6H8xfc2xY4ivrjzTeyPrqiHzKTDlxGK4A0ZvdoqA=
Subject: patch "staging: comedi: amplc_pci230: fix null pointer deref on interrupt" added to staging-testing
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Jul 2019 08:50:40 +0200
Message-ID: <156196384019626@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: amplc_pci230: fix null pointer deref on interrupt

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 7379e6baeddf580d01feca650ec1ad508b6ea8ee Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Wed, 26 Jun 2019 14:17:39 +0100
Subject: staging: comedi: amplc_pci230: fix null pointer deref on interrupt

The interrupt handler `pci230_interrupt()` causes a null pointer
dereference for a PCI260 card.  There is no analog output subdevice for
a PCI260.  The `dev->write_subdev` subdevice pointer and therefore the
`s_ao` subdevice pointer variable will be `NULL` for a PCI260.  The
following call near the end of the interrupt handler results in the null
pointer dereference for a PCI260:

	comedi_handle_events(dev, s_ao);

Fix it by only calling the above function if `s_ao` is valid.

Note that the other uses of `s_ao` in the calls
`pci230_handle_ao_nofifo(dev, s_ao);` and `pci230_handle_ao_fifo(dev,
s_ao);` will never be reached for a PCI260, so they are safe.

Fixes: 39064f23284c ("staging: comedi: amplc_pci230: use comedi_handle_events()")
Cc: <stable@vger.kernel.org> # v3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 65f60c2b702a..f7e673121864 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -2330,7 +2330,8 @@ static irqreturn_t pci230_interrupt(int irq, void *d)
 	devpriv->intr_running = false;
 	spin_unlock_irqrestore(&devpriv->isr_spinlock, irqflags);
 
-	comedi_handle_events(dev, s_ao);
+	if (s_ao)
+		comedi_handle_events(dev, s_ao);
 	comedi_handle_events(dev, s_ai);
 
 	return IRQ_HANDLED;
-- 
2.22.0


