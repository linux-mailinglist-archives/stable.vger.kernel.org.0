Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825FD20752A
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 16:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403995AbgFXODI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 10:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403985AbgFXODI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 10:03:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7DCC20724;
        Wed, 24 Jun 2020 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593007388;
        bh=oYt3nipFkVBhlWKsPMk6mxwdK/ien7aW0TKtDAN/GGs=;
        h=Subject:To:From:Date:From;
        b=izyFMmkdVR3YqK2TPJYWbUvaW99riVvdr5Xp1Z4Jizt3QBL9W6E90MS7bEa77uWPE
         HsQNKgUeL+PQXFvUThlwr2vxwF7Zp1w8YW22NH25lF988kK0/elGfDNAKVD/jP221h
         VdpIzBkTLuj6GJFeSfbpVKba/dP8raP0CFXu9Bgc=
Subject: patch "usb: cdns3: ep0: fix the test mode set incorrectly" added to usb-linus
To:     peter.chen@nxp.com, gregkh@linuxfoundation.org, jun.li@nxp.com,
        pawell@cadence.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jun 2020 16:03:06 +0200
Message-ID: <1593007386164186@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: cdns3: ep0: fix the test mode set incorrectly

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c0e2a0341cd8ccd213ffc6c7f9cd52a31466cba9 Mon Sep 17 00:00:00 2001
From: Peter Chen <peter.chen@nxp.com>
Date: Tue, 23 Jun 2020 11:09:16 +0800
Subject: usb: cdns3: ep0: fix the test mode set incorrectly

The 'tmode' is ctrl->wIndex, changing it as the real test
mode value for register assignment.

Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Cc: <stable@vger.kernel.org>
Reviewed-by: Jun Li <jun.li@nxp.com>
Reviewed-by: Pawel Laszczak <pawell@cadence.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20200623030918.8409-2-peter.chen@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/ep0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index 82645a2a0f52..04e49582fb55 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -327,7 +327,8 @@ static int cdns3_ep0_feature_handle_device(struct cdns3_device *priv_dev,
 		if (!set || (tmode & 0xff) != 0)
 			return -EINVAL;
 
-		switch (tmode >> 8) {
+		tmode >>= 8;
+		switch (tmode) {
 		case TEST_J:
 		case TEST_K:
 		case TEST_SE0_NAK:
-- 
2.27.0


