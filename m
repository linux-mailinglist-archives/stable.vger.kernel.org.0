Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED3B2D7903
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 16:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406549AbgLKPSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 10:18:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406299AbgLKPRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 10:17:38 -0500
Subject: patch "USB: serial: mos7720: fix parallel-port state restore" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607699818;
        bh=vYxRrA5rDU4f/OOblgmDTPHXBhzn2nY7uZ4q6LZfljA=;
        h=To:From:Date:From;
        b=kaVc68PbvSiaxl74fCoOB5n18mZYCSOlYK26bi7wtIc/XcVHaSfgYPxtewBMrax8W
         Hh/C8V2GzFWKSlPuzBlPR3APq2uyzRxYbGlXHBloicu4Ko2OVp9YTW1aFHXTuUm8m4
         VVa+IoheZ8A7lkMcMKbhVDz05HDxu4R31w2fRRRI=
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Dec 2020 16:17:25 +0100
Message-ID: <1607699845168170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: serial: mos7720: fix parallel-port state restore

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 975323ab8f116667676c30ca3502a6757bd89e8d Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 4 Nov 2020 17:47:27 +0100
Subject: USB: serial: mos7720: fix parallel-port state restore

The parallel-port restore operations is called when a driver claims the
port and is supposed to restore the provided state (e.g. saved when
releasing the port).

Fixes: b69578df7e98 ("USB: usbserial: mos7720: add support for parallel port on moschip 7715")
Cc: stable <stable@vger.kernel.org>     # 2.6.35
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/mos7720.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 5eed1078fac8..5a5d2a95070e 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -639,6 +639,8 @@ static void parport_mos7715_restore_state(struct parport *pp,
 		spin_unlock(&release_lock);
 		return;
 	}
+	mos_parport->shadowDCR = s->u.pc.ctr;
+	mos_parport->shadowECR = s->u.pc.ecr;
 	write_parport_reg_nonblock(mos_parport, MOS7720_DCR,
 				   mos_parport->shadowDCR);
 	write_parport_reg_nonblock(mos_parport, MOS7720_ECR,
-- 
2.29.2


