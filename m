Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8A333B8C5
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbhCOOE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232263AbhCOOAh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F8C164EF3;
        Mon, 15 Mar 2021 14:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816823;
        bh=uEJo1uYAUKC2yFLQgXzIXbHI3oV4iq54+jSSHrfHZM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guQInOrkxRzpT6znpllHv1o+m3Rrj4y5wwA5qqy/8qnu4yAdBW/zGbMxWda0qunI5
         fYSeFE0mW2wmBAblPVgDasYQbYVm8rnNzaJSH3CJKzDb6gQEDNweHeK0XaQNlPQ+2G
         lLNBiJTFXkRaib1goue1bv0Qw27pxdtJIx2/9JLY=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 5.4 134/168] staging: comedi: addi_apci_1032: Fix endian problem for COS sample
Date:   Mon, 15 Mar 2021 14:56:06 +0100
Message-Id: <20210315135554.747947375@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
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


