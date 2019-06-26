Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D51F56A61
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFZN0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 09:26:46 -0400
Received: from smtp91.ord1c.emailsrvr.com ([108.166.43.91]:40158 "EHLO
        smtp91.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726984AbfFZN0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 09:26:43 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jun 2019 09:26:42 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1561555068;
        bh=p8NBrC7TcB3r94Ss7ixIGRBlzw0oSkFVKI7xMPI0ZBY=;
        h=From:To:Subject:Date:From;
        b=NCPMkYM8lPgmjLBc7sD3P4+NsovJcXautuM69pPOrEJiZQk5BLw+xA6TlRDR4M0SF
         II/ECIPigrMr1Vfb45A0khHeJf6/374zXPOlLVQg8KVqlLd602Cv99hE0nf9k3CDKS
         syfwezCuawVDLMxZ74HkUFtV/Kpoo5DX+nADs0MQ=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp28.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id C642340148;
        Wed, 26 Jun 2019 09:17:47 -0400 (EDT)
X-Sender-Id: abbotti@mev.co.uk
Received: from ian-deb.inside.mev.co.uk (remote.quintadena.com [81.133.34.160])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Wed, 26 Jun 2019 09:17:48 -0400
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH] staging: comedi: amplc_pci230: fix null pointer deref on interrupt
Date:   Wed, 26 Jun 2019 14:17:39 +0100
Message-Id: <20190626131739.26022-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.20.1

