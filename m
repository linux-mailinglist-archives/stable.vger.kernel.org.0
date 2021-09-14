Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739F540A982
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 10:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbhINIoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 04:44:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhINIoT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Sep 2021 04:44:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66B2860EE0;
        Tue, 14 Sep 2021 08:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631608983;
        bh=wN+AKC/xAiPMCjuqKnyLO8Jfm9COVGI8WRxWTaBUZPQ=;
        h=Subject:To:From:Date:From;
        b=N4twGX+lb0jf0w5vG2TX6gohAyMrV4glI2AxelzS8WD9eiyEnHhQfDUTOVwk5Wm01
         DoyTjDowi6Lmdzetod+9WfCu0e+Ii0Nm1h0zb93fsmau8ZiiCLEv86Y7ocfvpPTOQa
         MTt/ym2hD17rCnL4vqOHKDWvq2JSc2JJjkzU2WQA=
Subject: patch "usb: gadget: f_uac2: Populate SS descriptors' wBytesPerInterval" added to usb-linus
To:     jackp@codeaurora.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 14 Sep 2021 10:42:52 +0200
Message-ID: <16316089729931@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_uac2: Populate SS descriptors' wBytesPerInterval

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f0e8a206a2a53a919e1709c654cb65d519f7befb Mon Sep 17 00:00:00 2001
From: Jack Pham <jackp@codeaurora.org>
Date: Thu, 9 Sep 2021 10:48:11 -0700
Subject: usb: gadget: f_uac2: Populate SS descriptors' wBytesPerInterval

For Isochronous endpoints, the SS companion descriptor's
wBytesPerInterval field is required to reserve bus time in order
to transmit the required payload during the service interval.
If left at 0, the UAC2 function is unable to transact data on its
playback or capture endpoints in SuperSpeed mode.

Since f_uac2 currently does not support any bursting this value can
be exactly equal to the calculated wMaxPacketSize.

Tested with Windows 10 as a host.

Fixes: f8cb3d556be3 ("usb: f_uac2: adds support for SS and SSP")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Link: https://lore.kernel.org/r/20210909174811.12534-3-jackp@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_uac2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index d89c1ebb07f4..be864560bfea 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -1178,6 +1178,9 @@ afunc_bind(struct usb_configuration *cfg, struct usb_function *fn)
 	agdev->out_ep_maxpsize = max_t(u16, agdev->out_ep_maxpsize,
 				le16_to_cpu(ss_epout_desc.wMaxPacketSize));
 
+	ss_epin_desc_comp.wBytesPerInterval = ss_epin_desc.wMaxPacketSize;
+	ss_epout_desc_comp.wBytesPerInterval = ss_epout_desc.wMaxPacketSize;
+
 	// HS and SS endpoint addresses are copied from autoconfigured FS descriptors
 	hs_ep_int_desc.bEndpointAddress = fs_ep_int_desc.bEndpointAddress;
 	hs_epout_desc.bEndpointAddress = fs_epout_desc.bEndpointAddress;
-- 
2.33.0


