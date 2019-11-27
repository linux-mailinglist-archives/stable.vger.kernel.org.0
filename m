Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFD510BC6F
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732670AbfK0VHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:07:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:34186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732664AbfK0VHy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:07:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41AF4217AB;
        Wed, 27 Nov 2019 21:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888873;
        bh=LbTcu3fT1fR+3pBF+m5MvIQGLlUtoffzpz127ClyU+s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DrhGNOy9mLZieI3GPUbJ5yDF06fHkIlPwQIkrX2PPkQmxl/E4G727PzehaU4ew46n
         flEo3nGRXJNw2YO0sUWVaaVB8XGG2K7suCcLI+SAzTaX7EpY+neRO7exghATdFVesV
         SvPdjDVNBnbz5habLflcr8H1yBsxP8GMZBLrD0N8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Porr <mail@berndporr.me.uk>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4.19 303/306] staging: comedi: usbduxfast: usbduxfast_ai_cmdtest rounding error
Date:   Wed, 27 Nov 2019 21:32:33 +0100
Message-Id: <20191127203136.861195377@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
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
@@ -350,6 +351,7 @@ static int usbduxfast_ai_cmdtest(struct
 				 struct comedi_cmd *cmd)
 {
 	int err = 0;
+	int err2 = 0;
 	unsigned int steps;
 	unsigned int arg;
 
@@ -399,11 +401,16 @@ static int usbduxfast_ai_cmdtest(struct
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


