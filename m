Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30A62259DB
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 10:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGTITK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 04:19:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgGTITJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 04:19:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6D142080D;
        Mon, 20 Jul 2020 08:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595233149;
        bh=adpnDTOT8bK2U/PU5F1x2XvRbIiyOuscCaGpt5i9fec=;
        h=Subject:To:From:Date:From;
        b=rOEyZQes2HAuCRYRhqefzj0iZyqwMlUufhxIq0ROyHy+9HZOE+94lFbEkMFV/UKAt
         YcZH9S/67bzKevbGPUv2PADrW7jAZRlz0QqJFvLANLO/iAFhg+r/Hj6HvKB9x2EBpO
         2r5EDzHDoADY9Wxh+tybvPqmCKvo0TusIGffrh7s=
Subject: patch "staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift" added to staging-linus
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 10:19:10 +0200
Message-ID: <1595233150242150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fc846e9db67c7e808d77bf9e2ef3d49e3820ce5d Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Fri, 17 Jul 2020 15:52:57 +0100
Subject: staging: comedi: addi_apci_1500: check INSN_CONFIG_DIGITAL_TRIG shift

The `INSN_CONFIG` comedi instruction with sub-instruction code
`INSN_CONFIG_DIGITAL_TRIG` includes a base channel in `data[3]`. This is
used as a right shift amount for other bitmask values without being
checked.  Shift amounts greater than or equal to 32 will result in
undefined behavior.  Add code to deal with this, adjusting the checks
for invalid channels so that enabled channel bits that would have been
lost by shifting are also checked for validity.  Only channels 0 to 15
are valid.

Fixes: a8c66b684efaf ("staging: comedi: addi_apci_1500: rewrite the subdevice support functions")
Cc: <stable@vger.kernel.org> #4.0+: ef75e14a6c93: staging: comedi: verify array index is correct before using it
Cc: <stable@vger.kernel.org> #4.0+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20200717145257.112660-5-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../staging/comedi/drivers/addi_apci_1500.c   | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi_apci_1500.c b/drivers/staging/comedi/drivers/addi_apci_1500.c
index 689acd69a1b9..816dd25b9d0e 100644
--- a/drivers/staging/comedi/drivers/addi_apci_1500.c
+++ b/drivers/staging/comedi/drivers/addi_apci_1500.c
@@ -452,13 +452,14 @@ static int apci1500_di_cfg_trig(struct comedi_device *dev,
 	struct apci1500_private *devpriv = dev->private;
 	unsigned int trig = data[1];
 	unsigned int shift = data[3];
-	unsigned int hi_mask = data[4] << shift;
-	unsigned int lo_mask = data[5] << shift;
-	unsigned int chan_mask = hi_mask | lo_mask;
-	unsigned int old_mask = (1 << shift) - 1;
+	unsigned int hi_mask;
+	unsigned int lo_mask;
+	unsigned int chan_mask;
+	unsigned int old_mask;
 	unsigned int pm;
 	unsigned int pt;
 	unsigned int pp;
+	unsigned int invalid_chan;
 
 	if (trig > 1) {
 		dev_dbg(dev->class_dev,
@@ -466,7 +467,20 @@ static int apci1500_di_cfg_trig(struct comedi_device *dev,
 		return -EINVAL;
 	}
 
-	if (chan_mask > 0xffff) {
+	if (shift <= 16) {
+		hi_mask = data[4] << shift;
+		lo_mask = data[5] << shift;
+		old_mask = (1U << shift) - 1;
+		invalid_chan = (data[4] | data[5]) >> (16 - shift);
+	} else {
+		hi_mask = 0;
+		lo_mask = 0;
+		old_mask = 0xffff;
+		invalid_chan = data[4] | data[5];
+	}
+	chan_mask = hi_mask | lo_mask;
+
+	if (invalid_chan) {
 		dev_dbg(dev->class_dev, "invalid digital trigger channel\n");
 		return -EINVAL;
 	}
-- 
2.27.0


