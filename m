Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FFD6711E
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 16:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfGLOQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 10:16:51 -0400
Received: from smtp83.iad3a.emailsrvr.com ([173.203.187.83]:36433 "EHLO
        smtp83.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbfGLOQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 10:16:51 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Jul 2019 10:16:50 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1562940434;
        bh=gAojXNZ2cNQpLvWeWyGjMSCIl23Z99miYv5ewY99jYA=;
        h=From:To:Subject:Date:From;
        b=Axd+8Xx/lT79b0kQ8GZqyT1hDREosCO21BqTLoi2y+jbyfe73BhnKu9Cmf9v2fspF
         zyJvv1GZg8k5OD+ruZjIjvE5Il6IXPpwv+A0E80IWFuqW7oDMpvgM3ymZqv134gZ9G
         A6d8OA1zExv4vkJzBmfY+BCREyMiDQ2RR8zThdx8=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp19.relay.iad3a.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 887474E04;
        Fri, 12 Jul 2019 10:07:13 -0400 (EDT)
X-Sender-Id: abbotti@mev.co.uk
Received: from ian-deb.inside.mev.co.uk (remote.quintadena.com [81.133.34.160])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Fri, 12 Jul 2019 10:07:14 -0400
From:   Ian Abbott <abbotti@mev.co.uk>
To:     stable@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH stable 3.15 to 3.18] staging: comedi: dt282x: fix a null pointer deref on interrupt
Date:   Fri, 12 Jul 2019 15:02:37 +0100
Message-Id: <20190712140237.15847-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/staging/comedi/drivers/dt282x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index c2a66dcf99fe..6a1222c45d35 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -483,7 +483,8 @@ static irqreturn_t dt282x_interrupt(int irq, void *d)
 	}
 #endif
 	cfc_handle_events(dev, s);
-	cfc_handle_events(dev, s_ao);
+	if (s_ao)
+		cfc_handle_events(dev, s_ao);
 
 	return IRQ_RETVAL(handled);
 }
-- 
2.20.1

