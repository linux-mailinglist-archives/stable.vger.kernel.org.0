Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0082A39B7E4
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 13:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhFDLaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 07:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:32776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229958AbhFDLaO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 07:30:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21CCC613FF;
        Fri,  4 Jun 2021 11:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622806108;
        bh=iOcQ5yGS2k8Skl2T5Nhu/xPOS3/PYnBoJufh1VqYnos=;
        h=Subject:To:From:Date:From;
        b=BBQXjyYYjHpzgeIS8wmVowADNpeJyd+29Nc5xnxIiqqKYLX7X04M2y4HJDQHK2rPJ
         n+rcpveNLiyeBZHECWV7Iwxn6QPEUxsIZ1dV5K3hDHYh8QvlJTuHoDO3SLkt0ceJeG
         RepfP2oYMBbXYza+GzcyTBemTLfZk0h6CPFv1JV8=
Subject: patch "usb: typec: tcpm: cancel send discover hrtimer when unregister tcpm" added to usb-linus
To:     jun.li@nxp.com, gregkh@linuxfoundation.org, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Jun 2021 13:28:16 +0200
Message-ID: <1622806096230185@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: cancel send discover hrtimer when unregister tcpm

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 024236abeba8194c23affedaaa8b1aee7b943890 Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Wed, 2 Jun 2021 17:57:09 +0800
Subject: usb: typec: tcpm: cancel send discover hrtimer when unregister tcpm
 port

Like the state_machine_timer, we should also cancel possible pending
send discover identity hrtimer when unregister tcpm port.

Fixes: c34e85fa69b9 ("usb: typec: tcpm: Send DISCOVER_IDENTITY from dedicated work")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Link: https://lore.kernel.org/r/1622627829-11070-3-git-send-email-jun.li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index a1382e878127..a7c336f56849 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -6335,6 +6335,7 @@ void tcpm_unregister_port(struct tcpm_port *port)
 {
 	int i;
 
+	hrtimer_cancel(&port->send_discover_timer);
 	hrtimer_cancel(&port->enable_frs_timer);
 	hrtimer_cancel(&port->vdm_state_machine_timer);
 	hrtimer_cancel(&port->state_machine_timer);
-- 
2.31.1


