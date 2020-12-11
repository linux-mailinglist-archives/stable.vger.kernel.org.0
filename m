Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDC82D7006
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 07:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404224AbgLKGL6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 01:11:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404536AbgLKGLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Dec 2020 01:11:44 -0500
Subject: patch "USB: gadget: f_midi: setup SuperSpeed Plus descriptors" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607667063;
        bh=ZJ2TUmjfEfmImIfeuxPUD+TRLdrFK/mpgwjefqB9ShM=;
        h=To:From:Date:From;
        b=2hyW7II0UYbwRwpw65e3nJdo9yVr+l5aDy4C7ml2ZSkUxXuteMd/i9Q8cXQ6naZCd
         5FDuwGPsh7/oK7nPgLZ2aL72EBY1YBN5d7iyeJaV70tglIp6qXWSXexxi5IqeJF6KB
         UdfpXz6mdTTc9APD/amTYHtuF1FsTupQ+g/D5bs4=
To:     willmcvicker@google.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, peter.chen@nxp.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 11 Dec 2020 07:10:03 +0100
Message-ID: <160766700316830@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: f_midi: setup SuperSpeed Plus descriptors

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 457a902ba1a73b7720666b21ca038cd19764db18 Mon Sep 17 00:00:00 2001
From: Will McVicker <willmcvicker@google.com>
Date: Fri, 27 Nov 2020 15:05:57 +0100
Subject: USB: gadget: f_midi: setup SuperSpeed Plus descriptors

Needed for SuperSpeed Plus support for f_midi.  This allows the
gadget to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20201127140559.381351-4-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 19d97940eeb9..8fff995b8dd5 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1048,6 +1048,12 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 		f->ss_descriptors = usb_copy_descriptors(midi_function);
 		if (!f->ss_descriptors)
 			goto fail_f_midi;
+
+		if (gadget_is_superspeed_plus(c->cdev->gadget)) {
+			f->ssp_descriptors = usb_copy_descriptors(midi_function);
+			if (!f->ssp_descriptors)
+				goto fail_f_midi;
+		}
 	}
 
 	kfree(midi_function);
-- 
2.29.2


