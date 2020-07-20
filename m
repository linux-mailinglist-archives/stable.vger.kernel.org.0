Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10522259DC
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 10:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgGTITN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 04:19:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgGTITM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 04:19:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E6FA2080D;
        Mon, 20 Jul 2020 08:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595233152;
        bh=mphIe+VPBrw99zVQVaO/bLZYFmrLT5UkfIc78I4Dx50=;
        h=Subject:To:From:Date:From;
        b=rr38Hxf9/ltPNVWTSynDAp3E3JNMAy1jJsE/Dw53I+O8oZxPnEP/h+dow6qXzCwUU
         7Pa5tBZB+t41v/A6BxPQKCwnjfmotQBGlmYbhwtrpXx17bLNTYbHLQiObzamZxGaRA
         SbXGuEtM4wL0peF0JEifD5FEjTV8Hf2FBWBBZ9OE=
Subject: patch "staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 10:19:11 +0200
Message-ID: <1595233151244115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 926234f1b8434c4409aa4c53637aa3362ca07cea Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Fri, 17 Jul 2020 15:52:56 +0100
Subject: staging: comedi: addi_apci_1564: check INSN_CONFIG_DIGITAL_TRIG shift

The `INSN_CONFIG` comedi instruction with sub-instruction code
`INSN_CONFIG_DIGITAL_TRIG` includes a base channel in `data[3]`. This is
used as a right shift amount for other bitmask values without being
checked.  Shift amounts greater than or equal to 32 will result in
undefined behavior.  Add code to deal with this.

Fixes: 1e15687ea472 ("staging: comedi: addi_apci_1564: add Change-of-State interrupt subdevice and required functions")
Cc: <stable@vger.kernel.org> #3.17+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200717145257.112660-4-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../staging/comedi/drivers/addi_apci_1564.c   | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1564.c b/drivers/staging/comedi/drivers/addi_apci_1564.c
index 10501fe6bb25..1268ba34be5f 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1564.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1564.c
@@ -331,14 +331,22 @@ static int apci1564_cos_insn_config(struct comedi_device *dev,
 				    unsigned int *data)
 {
 	struct apci1564_private *devpriv = dev->private;
-	unsigned int shift, oldmask;
+	unsigned int shift, oldmask, himask, lomask;
 
 	switch (data[0]) {
 	case INSN_CONFIG_DIGITAL_TRIG:
 		if (data[1] != 0)
 			return -EINVAL;
 		shift = data[3];
-		oldmask = (1U << shift) - 1;
+		if (shift < 32) {
+			oldmask = (1U << shift) - 1;
+			himask = data[4] << shift;
+			lomask = data[5] << shift;
+		} else {
+			oldmask = 0xffffffffu;
+			himask = 0;
+			lomask = 0;
+		}
 		switch (data[2]) {
 		case COMEDI_DIGITAL_TRIG_DISABLE:
 			devpriv->ctrl = 0;
@@ -362,8 +370,8 @@ static int apci1564_cos_insn_config(struct comedi_device *dev,
 				devpriv->mode2 &= oldmask;
 			}
 			/* configure specified channels */
-			devpriv->mode1 |= data[4] << shift;
-			devpriv->mode2 |= data[5] << shift;
+			devpriv->mode1 |= himask;
+			devpriv->mode2 |= lomask;
 			break;
 		case COMEDI_DIGITAL_TRIG_ENABLE_LEVELS:
 			if (devpriv->ctrl != (APCI1564_DI_IRQ_ENA |
@@ -380,8 +388,8 @@ static int apci1564_cos_insn_config(struct comedi_device *dev,
 				devpriv->mode2 &= oldmask;
 			}
 			/* configure specified channels */
-			devpriv->mode1 |= data[4] << shift;
-			devpriv->mode2 |= data[5] << shift;
+			devpriv->mode1 |= himask;
+			devpriv->mode2 |= lomask;
 			break;
 		default:
 			return -EINVAL;
-- 
2.27.0


