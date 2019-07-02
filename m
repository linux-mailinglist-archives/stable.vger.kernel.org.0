Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFF45CF84
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 14:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfGBMeX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 08:34:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726457AbfGBMeX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 08:34:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF1DA2054F;
        Tue,  2 Jul 2019 12:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562070862;
        bh=efxMCoAIJxWHS+En7dFpqGzyVdF4net3rRwacFSQFW4=;
        h=Subject:To:From:Date:From;
        b=ClschHMkVdpVm/J+Deqk3rQagRBP4jSTZabYAS9raOSydqWq/F48HdP88A6xP+jRl
         vDFASEs9Lpsu/ROBkAqTTctkTbfQ5qKL4FwYyswRrtaRAJFsVO0tS2jkZKyk+F44o3
         ddxPf/eM/5Ukid2ZXOm1S3Dmxq2BTMnyknbnvMSU=
Subject: patch "staging: comedi: dt282x: fix a null pointer deref on interrupt" added to staging-next
To:     abbotti@mev.co.uk, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 02 Jul 2019 14:29:38 +0200
Message-ID: <1562070578254138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: comedi: dt282x: fix a null pointer deref on interrupt

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From b8336be66dec06bef518030a0df9847122053ec5 Mon Sep 17 00:00:00 2001
From: Ian Abbott <abbotti@mev.co.uk>
Date: Wed, 26 Jun 2019 14:18:04 +0100
Subject: staging: comedi: dt282x: fix a null pointer deref on interrupt

The interrupt handler `dt282x_interrupt()` causes a null pointer
dereference for those supported boards that have no analog output
support.  For these boards, `dev->write_subdev` will be `NULL` and
therefore the `s_ao` subdevice pointer variable will be `NULL`.  In that
case, the following call near the end of the interrupt handler results
in a null pointer dereference:

	comedi_handle_events(dev, s_ao);

Fix it by only calling the above function if `s_ao` is valid.

(There are other uses of `s_ao` by the interrupt handler that may or may
not be reached depending on values of hardware registers.  Trust that
they are reliable for now.)

Note:
commit 4f6f009b204f ("staging: comedi: dt282x: use comedi_handle_events()")
propagates an earlier error from
commit f21c74fa4cfe ("staging: comedi: dt282x: use cfc_handle_events()").

Fixes: 4f6f009b204f ("staging: comedi: dt282x: use comedi_handle_events()")
Cc: <stable@vger.kernel.org> # v3.19+
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dt282x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 3be927f1d3a9..e15e33ed94ae 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -557,7 +557,8 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 	}
 #endif
 	comedi_handle_events(dev, s);
-	comedi_handle_events(dev, s_ao);
+	if (s_ao)
+		comedi_handle_events(dev, s_ao);
 
 	return IRQ_RETVAL(handled);
 }
-- 
2.22.0


