Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84B1B7FE78
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 18:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731165AbfHBQSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 12:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbfHBQSe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 12:18:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10F8220644;
        Fri,  2 Aug 2019 16:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564762713;
        bh=96UVqG9S4O5gwJdDXwvXHnrdb6XJB2jT0krzCwuiuQk=;
        h=Subject:To:From:Date:From;
        b=189hxOgnkC1VL8zzjPjrg9dHtuA220imqWPeMhIyY5AmVc6CUs/WwRDady0WGfKjh
         9GmSaznbiuP+CTH+X/9jAMAfVV9+6NGaj81uDbJwM51bGSEayg3ik4v3WpnWDmuV3P
         DRZiiHmKnY207boA70ZGKVN69eyQb7ZmNrX3GolY=
Subject: patch "usb: typec: tcpm: Ignore unsupported/unknown alternate mode requests" added to usb-linus
To:     linux@roeck-us.net, dgilbert@interlog.com,
        gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 02 Aug 2019 18:18:31 +0200
Message-ID: <1564762711186126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Ignore unsupported/unknown alternate mode requests

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 88d02c9ba2e83fc22d37ccb1f11c62ea6fc9ae50 Mon Sep 17 00:00:00 2001
From: Guenter Roeck <linux@roeck-us.net>
Date: Fri, 2 Aug 2019 09:03:42 -0700
Subject: usb: typec: tcpm: Ignore unsupported/unknown alternate mode requests

TCPM may receive PD messages associated with unknown or unsupported
alternate modes. If that happens, calls to typec_match_altmode()
will return NULL. The tcpm code does not currently take this into
account. This results in crashes.

Unable to handle kernel NULL pointer dereference at virtual address 000001f0
pgd = 41dad9a1
[000001f0] *pgd=00000000
Internal error: Oops: 5 [#1] THUMB2
Modules linked in: tcpci tcpm
CPU: 0 PID: 2338 Comm: kworker/u2:0 Not tainted 5.1.18-sama5-armv7-r2 #6
Hardware name: Atmel SAMA5
Workqueue: 2-0050 tcpm_pd_rx_handler [tcpm]
PC is at typec_altmode_attention+0x0/0x14
LR is at tcpm_pd_rx_handler+0xa3b/0xda0 [tcpm]
...
[<c03fbee8>] (typec_altmode_attention) from [<bf8030fb>]
				(tcpm_pd_rx_handler+0xa3b/0xda0 [tcpm])
[<bf8030fb>] (tcpm_pd_rx_handler [tcpm]) from [<c012082b>]
				(process_one_work+0x123/0x2a8)
[<c012082b>] (process_one_work) from [<c0120a6d>]
				(worker_thread+0xbd/0x3b0)
[<c0120a6d>] (worker_thread) from [<c012431f>] (kthread+0xcf/0xf4)
[<c012431f>] (kthread) from [<c01010f9>] (ret_from_fork+0x11/0x38)

Ignore PD messages if the associated alternate mode is not supported.

Fixes: e9576fe8e605c ("usb: typec: tcpm: Support for Alternate Modes")
Cc: stable <stable@vger.kernel.org>
Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/1564761822-13984-1-git-send-email-linux@roeck-us.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 38 ++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index ab6456622120..15abe1d9958f 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1109,7 +1109,8 @@ static int tcpm_pd_svdm(struct tcpm_port *port, const __le32 *payload, int cnt,
 			break;
 		case CMD_ATTENTION:
 			/* Attention command does not have response */
-			typec_altmode_attention(adev, p[1]);
+			if (adev)
+				typec_altmode_attention(adev, p[1]);
 			return 0;
 		default:
 			break;
@@ -1161,20 +1162,26 @@ static int tcpm_pd_svdm(struct tcpm_port *port, const __le32 *payload, int cnt,
 			}
 			break;
 		case CMD_ENTER_MODE:
-			typec_altmode_update_active(pdev, true);
-
-			if (typec_altmode_vdm(adev, p[0], &p[1], cnt)) {
-				response[0] = VDO(adev->svid, 1, CMD_EXIT_MODE);
-				response[0] |= VDO_OPOS(adev->mode);
-				return 1;
+			if (adev && pdev) {
+				typec_altmode_update_active(pdev, true);
+
+				if (typec_altmode_vdm(adev, p[0], &p[1], cnt)) {
+					response[0] = VDO(adev->svid, 1,
+							  CMD_EXIT_MODE);
+					response[0] |= VDO_OPOS(adev->mode);
+					return 1;
+				}
 			}
 			return 0;
 		case CMD_EXIT_MODE:
-			typec_altmode_update_active(pdev, false);
+			if (adev && pdev) {
+				typec_altmode_update_active(pdev, false);
 
-			/* Back to USB Operation */
-			WARN_ON(typec_altmode_notify(adev, TYPEC_STATE_USB,
-						     NULL));
+				/* Back to USB Operation */
+				WARN_ON(typec_altmode_notify(adev,
+							     TYPEC_STATE_USB,
+							     NULL));
+			}
 			break;
 		default:
 			break;
@@ -1184,8 +1191,10 @@ static int tcpm_pd_svdm(struct tcpm_port *port, const __le32 *payload, int cnt,
 		switch (cmd) {
 		case CMD_ENTER_MODE:
 			/* Back to USB Operation */
-			WARN_ON(typec_altmode_notify(adev, TYPEC_STATE_USB,
-						     NULL));
+			if (adev)
+				WARN_ON(typec_altmode_notify(adev,
+							     TYPEC_STATE_USB,
+							     NULL));
 			break;
 		default:
 			break;
@@ -1196,7 +1205,8 @@ static int tcpm_pd_svdm(struct tcpm_port *port, const __le32 *payload, int cnt,
 	}
 
 	/* Informing the alternate mode drivers about everything */
-	typec_altmode_vdm(adev, p[0], &p[1], cnt);
+	if (adev)
+		typec_altmode_vdm(adev, p[0], &p[1], cnt);
 
 	return rlen;
 }
-- 
2.22.0


