Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD59556A63
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 15:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfFZN0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 09:26:53 -0400
Received: from smtp99.ord1c.emailsrvr.com ([108.166.43.99]:59594 "EHLO
        smtp99.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726984AbfFZN0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jun 2019 09:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1561555092;
        bh=uILIgeTCaMZi0ztFfJUtA14tW+iy/tHbUv33HBIXIA4=;
        h=From:To:Subject:Date:From;
        b=NTBdKLnv1rZCnWxqHj9gWXofaRGarvsUVgtFEEkTpI4UWGgWkUVlaP6Q2qWBzph7c
         07Lxma7mLxE0n6kadE1OBnMukXWS9IraTsjdJD+fc4CT33OY+FsVPgpVcy1+XOJxNg
         +xOBE1Qm50OMqWMRgCuC1qhcWXQsDFnKDsi/sk8E=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp21.relay.ord1c.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 5D1B6C0257;
        Wed, 26 Jun 2019 09:18:11 -0400 (EDT)
X-Sender-Id: abbotti@mev.co.uk
Received: from ian-deb.inside.mev.co.uk (remote.quintadena.com [81.133.34.160])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256)
        by 0.0.0.0:465 (trex/5.7.12);
        Wed, 26 Jun 2019 09:18:12 -0400
From:   Ian Abbott <abbotti@mev.co.uk>
To:     devel@driverdev.osuosl.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        stable@vger.kernel.org
Subject: [PATCH] staging: comedi: dt282x: fix a null pointer deref on interrupt
Date:   Wed, 26 Jun 2019 14:18:04 +0100
Message-Id: <20190626131804.26215-1-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
Note: A similar patch will be required for stable v3.16.x, but that
calls cfc_handle_events() instead of comedi_handle_events().
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
2.20.1

