Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3DF30A85F
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 14:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbhBANLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 08:11:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231493AbhBANLo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Feb 2021 08:11:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAD7564E2A;
        Mon,  1 Feb 2021 13:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612185063;
        bh=SeRCWceqMEpV2k1XeIN7lrInw79gIgCXNXF7J99PbwM=;
        h=Subject:To:From:Date:From;
        b=srYbqlVKFsQ+VvNQxzQZ+y7z13m+jXQzwGvvNPPUlsFlut1E0cdcwh6LMEVFas41q
         zEjWlhfDOd+75sE3ssN0/tu8WhXYKaYpGiOTwDWhsil/VNOmfl3xG58fhWhXnFod1V
         OEbk3Oh14wnkGopf+x16bPqZFn/ps+TJCvAC8f8c=
Subject: patch "usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()" added to usb-linus
To:     yoshihiro.shimoda.uh@renesas.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, tho.vu.wh@renesas.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Feb 2021 14:11:00 +0100
Message-ID: <161218506023719@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9917f0e3cdba7b9f1a23f70e3f70b1a106be54a8 Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Mon, 1 Feb 2021 21:47:20 +0900
Subject: usb: renesas_usbhs: Clear pipe running flag in usbhs_pkt_pop()

Should clear the pipe running flag in usbhs_pkt_pop(). Otherwise,
we cannot use this pipe after dequeue was called while the pipe was
running.

Fixes: 8355b2b3082d ("usb: renesas_usbhs: fix the behavior of some usbhs_pkt_handle")
Reported-by: Tho Vu <tho.vu.wh@renesas.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1612183640-8898-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/renesas_usbhs/fifo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index ac9a81ae8216..e6fa13701808 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -126,6 +126,7 @@ struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt)
 		}
 
 		usbhs_pipe_clear_without_sequence(pipe, 0, 0);
+		usbhs_pipe_running(pipe, 0);
 
 		__usbhsf_pkt_del(pkt);
 	}
-- 
2.30.0


