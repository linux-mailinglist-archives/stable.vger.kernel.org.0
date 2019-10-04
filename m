Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07F02CBA7C
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730534AbfJDMdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:33:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729034AbfJDMdL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:33:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF7FD21D71;
        Fri,  4 Oct 2019 12:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192390;
        bh=a28RiVcZlaU1l4S1kGxhs3+yVI3120C/aeUxrxL3SbE=;
        h=Subject:To:From:Date:From;
        b=i9M5qjtNg52CYVFLw8LEWzglPLW4LM4wo+/TxENBsYsIengLKgCF2sP0NKPf4TejD
         X374EChSEduPTmD0xGa4doZ1Awkc8NJxYqnMtNVzoIH8YvJL0JTJ4LugO/ushEXPu/
         0qwtLGdlyGF9EXTa1KZEftnhTqHkoZWNDNavVA6M=
Subject: patch "xhci: Check all endpoints for LPM timeout" added to usb-linus
To:     jan@centricular.com, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, p.zabel@pengutronix.de,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:33:05 +0200
Message-ID: <1570192385110220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Check all endpoints for LPM timeout

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d500c63f80f2ea08ee300e57da5f2af1c13875f5 Mon Sep 17 00:00:00 2001
From: Jan Schmidt <jan@centricular.com>
Date: Fri, 4 Oct 2019 14:59:28 +0300
Subject: xhci: Check all endpoints for LPM timeout

If an endpoint is encountered that returns USB3_LPM_DEVICE_INITIATED, keep
checking further endpoints, as there might be periodic endpoints later
that return USB3_LPM_DISABLED due to shorter service intervals.

Without this, the code can set too high a maximum-exit-latency and
prevent the use of multiple USB3 cameras that should be able to work.

Cc: <stable@vger.kernel.org>
Signed-off-by: Jan Schmidt <jan@centricular.com>
Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-4-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index aed5a65f25bd..a5ba5ace3d00 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4674,12 +4674,12 @@ static int xhci_update_timeout_for_endpoint(struct xhci_hcd *xhci,
 	alt_timeout = xhci_call_host_update_timeout_for_endpoint(xhci, udev,
 		desc, state, timeout);
 
-	/* If we found we can't enable hub-initiated LPM, or
+	/* If we found we can't enable hub-initiated LPM, and
 	 * the U1 or U2 exit latency was too high to allow
-	 * device-initiated LPM as well, just stop searching.
+	 * device-initiated LPM as well, then we will disable LPM
+	 * for this device, so stop searching any further.
 	 */
-	if (alt_timeout == USB3_LPM_DISABLED ||
-			alt_timeout == USB3_LPM_DEVICE_INITIATED) {
+	if (alt_timeout == USB3_LPM_DISABLED) {
 		*timeout = alt_timeout;
 		return -E2BIG;
 	}
-- 
2.23.0


