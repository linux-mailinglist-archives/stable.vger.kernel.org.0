Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A95A33BA2B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234477AbhCOOIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233929AbhCOOCi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:02:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C977F64E89;
        Mon, 15 Mar 2021 14:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816957;
        bh=uEJo1uYAUKC2yFLQgXzIXbHI3oV4iq54+jSSHrfHZM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAmpeX+rrmZYKZtAoDzUQ3lHuv12fmWRGO5LtQFNDr4q+blAW3yCFr0Tx2ikK11nb
         sPAJq9LxpGwXoEhbcNnoTfoF1I+Sij5WPGi7wxaF4nu7XLa/2tTSIgoxMt3AwQhJ3c
         Q2McOtF6rSQkhrwnbh7oJ2DMB74z1nJRAvCBNr/o=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.11 228/306] staging: comedi: addi_apci_1032: Fix endian problem for COS sample
Date:   Mon, 15 Mar 2021 14:54:51 +0100
Message-Id: <20210315135515.330784775@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ian Abbott <abbotti@mev.co.uk>

commit 25317f428a78fde71b2bf3f24d05850f08a73a52 upstream.

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
 drivers/staging/comedi/drivers/addi_apci_1032.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/addi_apci_1032.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1032.c
@@ -260,6 +260,7 @@ static irqreturn_t apci1032_interrupt(in
 	struct apci1032_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned int ctrl;
+	unsigned short val;
 
 	/* check interrupt is from this device */
 	if ((inl(devpriv->amcc_iobase + AMCC_OP_REG_INTCSR) &
@@ -275,7 +276,8 @@ static irqreturn_t apci1032_interrupt(in
 	outl(ctrl & ~APCI1032_CTRL_INT_ENA, dev->iobase + APCI1032_CTRL_REG);
 
 	s->state = inl(dev->iobase + APCI1032_STATUS_REG) & 0xffff;
-	comedi_buf_write_samples(s, &s->state, 1);
+	val = s->state;
+	comedi_buf_write_samples(s, &val, 1);
 	comedi_handle_events(dev, s);
 
 	/* enable the interrupt */


