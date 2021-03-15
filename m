Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3533B906
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCOOFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:36788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233130AbhCOOAo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4364B64E83;
        Mon, 15 Mar 2021 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816832;
        bh=V7viz8xu8N8sJYEkw/htq8X3o9dPilKEp2U4S6NTMI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1KrPyw0yFAJZ0rXgIoQWFQscT5irPU3KK/zGDvP/PGPjRTkG2+bEuKekWdDtDYvmd
         Q97P9aOGb1WFPFtNBPJxeqzQN8a2kMbHJ97gPhvmfAqLV2diKIQc4krawkH547uEy2
         9NyPi8xdHSDXWmh2qLN5IP58THpX5j2RvzGb10ZU=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.19 098/120] staging: comedi: adv_pci1710: Fix endian problem for AI command data
Date:   Mon, 15 Mar 2021 14:57:29 +0100
Message-Id: <20210315135723.182718088@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135720.002213995@linuxfoundation.org>
References: <20210315135720.002213995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ian Abbott <abbotti@mev.co.uk>

commit b2e78630f733a76508b53ba680528ca39c890e82 upstream.

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
 drivers/staging/comedi/drivers/adv_pci1710.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -300,11 +300,11 @@ static int pci1710_ai_eoc(struct comedi_
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
@@ -345,7 +345,7 @@ static int pci1710_ai_insn_read(struct c
 	pci1710_ai_setup_chanlist(dev, s, &insn->chanspec, 1, 1);
 
 	for (i = 0; i < insn->n; i++) {
-		unsigned int val;
+		unsigned short val;
 
 		/* start conversion */
 		outw(0, dev->iobase + PCI171X_SOFTTRG_REG);
@@ -395,7 +395,7 @@ static void pci1710_handle_every_sample(
 {
 	struct comedi_cmd *cmd = &s->async->cmd;
 	unsigned int status;
-	unsigned int val;
+	unsigned short val;
 	int ret;
 
 	status = inw(dev->iobase + PCI171X_STATUS_REG);
@@ -455,7 +455,7 @@ static void pci1710_handle_fifo(struct c
 	}
 
 	for (i = 0; i < devpriv->max_samples; i++) {
-		unsigned int val;
+		unsigned short val;
 		int ret;
 
 		ret = pci1710_ai_read_sample(dev, s, s->async->cur_chan, &val);


