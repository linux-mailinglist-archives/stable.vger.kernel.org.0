Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CB8FB9286
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391496AbfITOd0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:33:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36352 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388242AbfITOZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:08 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqL-00051E-3D; Fri, 20 Sep 2019 15:25:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007zp-SZ; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ian Abbott" <abbotti@mev.co.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.304704907@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 132/132] staging: comedi: dt282x: fix a null  pointer
 deref on interrupt
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit b8336be66dec06bef518030a0df9847122053ec5 upstream.

The interrupt handler `dt282x_interrupt()` causes a null pointer
dereference for those supported boards that have no analog output
support.  For these boards, `dev->write_subdev` will be `NULL` and
therefore the `s_ao` subdevice pointer variable will be `NULL`.  In that
case, the following call near the end of the interrupt handler results
in a null pointer dereference:

	cfc_handle_events(dev, s_ao);

[ Upstream equivalent:
	comedi_handle_events(dev, s_ao);
  -- IA ]

Fix it by only calling the above function if `s_ao` is valid.

(There are other uses of `s_ao` by the interrupt handler that may or may
not be reached depending on values of hardware registers.  Trust that
they are reliable for now.)

Fixes: f21c74fa4cfe ("staging: comedi: dt282x: use cfc_handle_events()")
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/drivers/dt282x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -483,7 +483,8 @@ static irqreturn_t dt282x_interrupt(int
 	}
 #endif
 	cfc_handle_events(dev, s);
-	cfc_handle_events(dev, s_ao);
+	if (s_ao)
+		cfc_handle_events(dev, s_ao);
 
 	return IRQ_RETVAL(handled);
 }

