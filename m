Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C191476622
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 23:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhLOWpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 17:45:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49212 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbhLOWpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 17:45:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5364F61B6B
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 22:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608F3C36AE3;
        Wed, 15 Dec 2021 22:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639608349;
        bh=/JbZe17/MDebT7W1yx28THFrUrKQMC85loluCzIu5AM=;
        h=Subject:To:From:Date:From;
        b=S3sKHI7PX4DPhTnrNnuygctcOfPpYNqxdP51njdrQljUBByi4+Ok20PsZVEYfXuM/
         PRK0khYlOSk6vFMmKuBfH1cxorB3OWkfuM5eVfAU/kx6KZSCnseAf7k6jY7gD5pbzp
         qWAolngdEi0sSn03yelrJyBrG4qF70PyHLUqIF2Q=
Subject: patch "usb: cdnsp: Fix lack of spin_lock_irqsave/spin_lock_restore" added to usb-linus
To:     pawell@cadence.com, gregkh@linuxfoundation.org,
        jianhe@ambarella.com, peter.chen@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Dec 2021 23:45:47 +0100
Message-ID: <1639608347224112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdnsp: Fix lack of spin_lock_irqsave/spin_lock_restore

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 4c4e162d9cf38528c4f13df09d5755cbc06f6c77 Mon Sep 17 00:00:00 2001
From: Pawel Laszczak <pawell@cadence.com>
Date: Tue, 14 Dec 2021 05:55:27 +0100
Subject: usb: cdnsp: Fix lack of spin_lock_irqsave/spin_lock_restore

Patch puts content of cdnsp_gadget_pullup function inside
spin_lock_irqsave and spin_lock_restore section.
This construction is required here to keep the data consistency,
otherwise some data can be changed e.g. from interrupt context.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Reported-by: Ken (Jian) He <jianhe@ambarella.com>
cc: <stable@vger.kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
--

Changelog:
v2:
- added disable_irq/enable_irq as sugester by Peter Chen

drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

Reviewed-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20211214045527.26823-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-gadget.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index 27df0c697897..e85bf768c66d 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1541,15 +1541,27 @@ static int cdnsp_gadget_pullup(struct usb_gadget *gadget, int is_on)
 {
 	struct cdnsp_device *pdev = gadget_to_cdnsp(gadget);
 	struct cdns *cdns = dev_get_drvdata(pdev->dev);
+	unsigned long flags;
 
 	trace_cdnsp_pullup(is_on);
 
+	/*
+	 * Disable events handling while controller is being
+	 * enabled/disabled.
+	 */
+	disable_irq(cdns->dev_irq);
+	spin_lock_irqsave(&pdev->lock, flags);
+
 	if (!is_on) {
 		cdnsp_reset_device(pdev);
 		cdns_clear_vbus(cdns);
 	} else {
 		cdns_set_vbus(cdns);
 	}
+
+	spin_unlock_irqrestore(&pdev->lock, flags);
+	enable_irq(cdns->dev_irq);
+
 	return 0;
 }
 
-- 
2.34.1


