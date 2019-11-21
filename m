Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 955961052EA
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 14:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfKUN12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 08:27:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUN12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 08:27:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 457B62075E;
        Thu, 21 Nov 2019 13:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574342847;
        bh=p8voWrCmt33oQBTtqZwdgQvebcCutW2WuDE8PPkPNi0=;
        h=Subject:To:From:Date:From;
        b=LgcqxaGvOlZwLIkVs2HDK/vfVmXd4sdmHqhkibMKia+NETfa4ljV6aRP8BZ9ty4zw
         ybpqzDIFE2FucJ0otzgzU+zL3tKOARdxPNKtcZAwdiOfqpo0lEr7FcxDHnkBCT97Gf
         zlefAdz4P85Ydk9nVXgCc2WcMpJ2nGTaI+uoiMTo=
Subject: patch "staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error" added to staging-testing
To:     mail@berndporr.me.uk, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 Nov 2019 14:27:25 +0100
Message-ID: <157434284519572@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the staging-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 222f7381cf6f1eab2ea3a534cbea0815a2b53326 Mon Sep 17 00:00:00 2001
From: Bernd Porr <mail@berndporr.me.uk>
Date: Mon, 18 Nov 2019 23:07:59 +0000
Subject: staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error

The userspace comedilib function 'get_cmd_generic_timed' fills
the cmd structure with an informed guess and then calls the
function 'usbduxfast_ai_cmdtest' in this driver repeatedly while
'usbduxfast_ai_cmdtest' is modifying the cmd struct until it
no longer changes. However, because of rounding errors this never
converged because 'steps = (cmd->convert_arg * 30) / 1000' and then
back to 'cmd->convert_arg = (steps * 1000) / 30' won't be the same
because of rounding errors. 'Steps' should only be converted back to
the 'convert_arg' if 'steps' has actually been modified. In addition
the case of steps being 0 wasn't checked which is also now done.

Signed-off-by: Bernd Porr <mail@berndporr.me.uk>
Cc: <stable@vger.kernel.org> # 4.4+
Reviewed-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://lore.kernel.org/r/20191118230759.1727-1-mail@berndporr.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/usbduxfast.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 04bc488385e6..4af012968cb6 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- *  Copyright (C) 2004-2014 Bernd Porr, mail@berndporr.me.uk
+ *  Copyright (C) 2004-2019 Bernd Porr, mail@berndporr.me.uk
  */
 
 /*
@@ -8,7 +8,7 @@
  * Description: University of Stirling USB DAQ & INCITE Technology Limited
  * Devices: [ITL] USB-DUX-FAST (usbduxfast)
  * Author: Bernd Porr <mail@berndporr.me.uk>
- * Updated: 10 Oct 2014
+ * Updated: 16 Nov 2019
  * Status: stable
  */
 
@@ -22,6 +22,7 @@
  *
  *
  * Revision history:
+ * 1.0: Fixed a rounding error in usbduxfast_ai_cmdtest
  * 0.9: Dropping the first data packet which seems to be from the last transfer.
  *      Buffer overflows in the FX2 are handed over to comedi.
  * 0.92: Dropping now 4 packets. The quad buffer has to be emptied.
@@ -350,6 +351,7 @@ static int usbduxfast_ai_cmdtest(struct comedi_device *dev,
 				 struct comedi_cmd *cmd)
 {
 	int err = 0;
+	int err2 = 0;
 	unsigned int steps;
 	unsigned int arg;
 
@@ -399,11 +401,16 @@ static int usbduxfast_ai_cmdtest(struct comedi_device *dev,
 	 */
 	steps = (cmd->convert_arg * 30) / 1000;
 	if (cmd->chanlist_len !=  1)
-		err |= comedi_check_trigger_arg_min(&steps,
-						    MIN_SAMPLING_PERIOD);
-	err |= comedi_check_trigger_arg_max(&steps, MAX_SAMPLING_PERIOD);
-	arg = (steps * 1000) / 30;
-	err |= comedi_check_trigger_arg_is(&cmd->convert_arg, arg);
+		err2 |= comedi_check_trigger_arg_min(&steps,
+						     MIN_SAMPLING_PERIOD);
+	else
+		err2 |= comedi_check_trigger_arg_min(&steps, 1);
+	err2 |= comedi_check_trigger_arg_max(&steps, MAX_SAMPLING_PERIOD);
+	if (err2) {
+		err |= err2;
+		arg = (steps * 1000) / 30;
+		err |= comedi_check_trigger_arg_is(&cmd->convert_arg, arg);
+	}
 
 	if (cmd->stop_src == TRIG_COUNT)
 		err |= comedi_check_trigger_arg_min(&cmd->stop_arg, 1);
-- 
2.24.0


