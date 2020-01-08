Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92ED7134C10
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgAHTtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:49:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43468 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730416AbgAHTqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:02 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-0006oP-F7; Wed, 08 Jan 2020 19:45:58 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHB-007dmD-PQ; Wed, 08 Jan 2020 19:45:57 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Yoshihiro Shimoda" <yoshihiro.shimoda.uh@renesas.com>,
        "Felipe Balbi" <felipe.balbi@linux.intel.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 19:43:20 +0000
Message-ID: <lsq.1578512578.416279625@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 22/63] usb: renesas_usbhs: gadget: fix
 unused-but-set-variable warning
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit b7d44c36a6f6d956e1539e0dd42f98b26e5a4684 upstream.

The commit b8b9c974afee ("usb: renesas_usbhs: gadget: disable all eps
when the driver stops") causes the unused-but-set-variable warning.
But, if the usbhsg_ep_disable() will return non-zero value, udc/core.c
doesn't clear the ep->enabled flag. So, this driver should not return
non-zero value, if the pipe is zero because this means the pipe is
already disabled. Otherwise, the ep->enabled flag is never cleared
when the usbhsg_ep_disable() is called by the renesas_usbhs driver first.

Fixes: b8b9c974afee ("usb: renesas_usbhs: gadget: disable all eps when the driver stops")
Fixes: 11432050f070 ("usb: renesas_usbhs: gadget: fix NULL pointer dereference in ep_disable()")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/renesas_usbhs/mod_gadget.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/usb/renesas_usbhs/mod_gadget.c
+++ b/drivers/usb/renesas_usbhs/mod_gadget.c
@@ -611,14 +611,11 @@ static int usbhsg_ep_disable(struct usb_
 	struct usbhsg_uep *uep = usbhsg_ep_to_uep(ep);
 	struct usbhs_pipe *pipe;
 	unsigned long flags;
-	int ret = 0;
 
 	spin_lock_irqsave(&uep->lock, flags);
 	pipe = usbhsg_uep_to_pipe(uep);
-	if (!pipe) {
-		ret = -EINVAL;
+	if (!pipe)
 		goto out;
-	}
 
 	usbhsg_pipe_disable(uep);
 	usbhs_pipe_free(pipe);

