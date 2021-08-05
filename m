Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426B93E12A2
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 12:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbhHEK2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 06:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234785AbhHEK2I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Aug 2021 06:28:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9133C610A2;
        Thu,  5 Aug 2021 10:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628159274;
        bh=i4TQuKQiBnBVsGu1T06mgmFNBZiIwfdE4DscqB97neA=;
        h=Subject:To:From:Date:From;
        b=FLnqgpYDNRmBrar6aC505mBRhCffdmbg+hz1pGXydmE7Z/omQOrpwImmwKuvJ1JVS
         6L0cyrk3kqBeHqG4TGQSoPxil/NEK8vnw6wAv1/IOLeTlCACACGjemyj33OQuww6ld
         RFxox6TxlHxMQaJE/N0UY8+KmsM77UjhytOcBU2k=
Subject: patch "usb: typec: tcpm: Keep other events when receiving FRS and" added to usb-linus
To:     kyletso@google.com, badhri@google.com, gregkh@linuxfoundation.org,
        linux@roeck-us.net, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 05 Aug 2021 12:27:51 +0200
Message-ID: <162815927119212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Keep other events when receiving FRS and

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 43ad944cd73f2360ec8ff31d29ea44830b3119af Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Tue, 3 Aug 2021 17:13:14 +0800
Subject: usb: typec: tcpm: Keep other events when receiving FRS and
 Sourcing_vbus events

When receiving FRS and Sourcing_Vbus events from low-level drivers, keep
other events which come a bit earlier so that they will not be ignored
in the event handler.

Fixes: 8dc4bd073663 ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
Cc: stable <stable@vger.kernel.org>
Cc: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210803091314.3051302-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 5b22a1c931a9..b9bb63d749ec 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5369,7 +5369,7 @@ EXPORT_SYMBOL_GPL(tcpm_pd_hard_reset);
 void tcpm_sink_frs(struct tcpm_port *port)
 {
 	spin_lock(&port->pd_event_lock);
-	port->pd_events = TCPM_FRS_EVENT;
+	port->pd_events |= TCPM_FRS_EVENT;
 	spin_unlock(&port->pd_event_lock);
 	kthread_queue_work(port->wq, &port->event_work);
 }
@@ -5378,7 +5378,7 @@ EXPORT_SYMBOL_GPL(tcpm_sink_frs);
 void tcpm_sourcing_vbus(struct tcpm_port *port)
 {
 	spin_lock(&port->pd_event_lock);
-	port->pd_events = TCPM_SOURCING_VBUS;
+	port->pd_events |= TCPM_SOURCING_VBUS;
 	spin_unlock(&port->pd_event_lock);
 	kthread_queue_work(port->wq, &port->event_work);
 }
-- 
2.32.0


