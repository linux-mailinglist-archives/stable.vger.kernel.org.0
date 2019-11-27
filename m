Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A821810BF65
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfK0UjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:39:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:42956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728848AbfK0UjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:39:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D5CF20863;
        Wed, 27 Nov 2019 20:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887139;
        bh=gla/T9epZxieOxWiss8ElTZqXZOTcBewGKHUizRHzyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrMuV/NBgn8Tc9CQ5d1pHxqD64Zm9aGXHAm3q7q+b22j22nlouagBI3PXBFJv2fK2
         S+Kg6GGauBNcH3nWi6Dw2KZ9JwwF6iHqWmlhSInJ9TgB5Xju+o6DsUi2c8K/uMXNdJ
         iYwf5IgnjzuJz1E6nn0z9JJ/Qu0pkiNxhF7H1lUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Porr <mail@berndporr.me.uk>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.4 129/132] staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error
Date:   Wed, 27 Nov 2019 21:32:00 +0100
Message-Id: <20191127203034.120669234@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127202857.270233486@linuxfoundation.org>
References: <20191127202857.270233486@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernd Porr <mail@berndporr.me.uk>

commit 5618332e5b955b4bff06d0b88146b971c8dd7b32 upstream.

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
 drivers/staging/comedi/drivers/usbduxfast.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -1,5 +1,5 @@
 /*
- *  Copyright (C) 2004-2014 Bernd Porr, mail@berndporr.me.uk
+ *  Copyright (C) 2004-2019 Bernd Porr, mail@berndporr.me.uk
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -17,7 +17,7 @@
  * Description: University of Stirling USB DAQ & INCITE Technology Limited
  * Devices: [ITL] USB-DUX-FAST (usbduxfast)
  * Author: Bernd Porr <mail@berndporr.me.uk>
- * Updated: 10 Oct 2014
+ * Updated: 16 Nov 2019
  * Status: stable
  */
 
@@ -31,6 +31,7 @@
  *
  *
  * Revision history:
+ * 1.0: Fixed a rounding error in usbduxfast_ai_cmdtest
  * 0.9: Dropping the first data packet which seems to be from the last transfer.
  *      Buffer overflows in the FX2 are handed over to comedi.
  * 0.92: Dropping now 4 packets. The quad buffer has to be emptied.
@@ -359,6 +360,7 @@ static int usbduxfast_ai_cmdtest(struct
 				 struct comedi_cmd *cmd)
 {
 	int err = 0;
+	int err2 = 0;
 	unsigned int steps;
 	unsigned int arg;
 
@@ -408,11 +410,16 @@ static int usbduxfast_ai_cmdtest(struct
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


