Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA76346127
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 15:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbhCWOOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 10:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231978AbhCWOOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 10:14:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FE4D60295;
        Tue, 23 Mar 2021 14:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616508850;
        bh=4d+8UV0YpdDGL5NamhCvBE7wPMOsVvDYcGbTVr2C6ms=;
        h=Subject:To:From:Date:From;
        b=tfPuUjW/QfZ/Bsv4bsnP2D6fOSM4UBKqd2BKFi1JkDdB6A8fDrKrbm0Y8cFOU7MmA
         XWBFDVDVhMO93LA9d6JVENLTCQcQ7MnYP+oxDeryDtLL9C/PhBtbxR8LPLRUgShydX
         iCIHLyhkLnA95KLf5Aqdo1ICuUP2AU14s5Xh8YMw=
Subject: patch "driver core: clear deferred probe reason on probe retry" added to driver-core-linus
To:     a.fatoum@pengutronix.de, a.hajda@samsung.com,
        andy.shevchenko@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 15:14:08 +0100
Message-ID: <161650884863145@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    driver core: clear deferred probe reason on probe retry

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f0acf637d60ffcef3ccb6e279f743e587b3c7359 Mon Sep 17 00:00:00 2001
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Date: Fri, 19 Mar 2021 12:04:57 +0100
Subject: driver core: clear deferred probe reason on probe retry

When retrying a deferred probe, any old defer reason string should be
discarded. Otherwise, if the probe is deferred again at a different spot,
but without setting a message, the now incorrect probe reason will remain.

This was observed with the i.MX I2C driver, which ultimately failed
to probe due to lack of the GPIO driver. The probe defer for GPIO
doesn't record a message, but a previous probe defer to clock_get did.
This had the effect that /sys/kernel/debug/devices_deferred listed
a misleading probe deferral reason.

Cc: stable <stable@vger.kernel.org>
Fixes: d090b70ede02 ("driver core: add deferring probe reason to devices_deferred property")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Link: https://lore.kernel.org/r/20210319110459.19966-1-a.fatoum@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/dd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9179825ff646..e2cf3b29123e 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -97,6 +97,9 @@ static void deferred_probe_work_func(struct work_struct *work)
 
 		get_device(dev);
 
+		kfree(dev->p->deferred_probe_reason);
+		dev->p->deferred_probe_reason = NULL;
+
 		/*
 		 * Drop the mutex while probing each device; the probe path may
 		 * manipulate the deferred list
-- 
2.31.0


