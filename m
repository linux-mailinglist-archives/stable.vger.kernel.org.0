Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B13142259E
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 13:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbhJELtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 07:49:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233564AbhJELtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 07:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 520D761131;
        Tue,  5 Oct 2021 11:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633434429;
        bh=jeP7yNjgnH/JfpInUXqHJS7dyHjAlg+VIjkja33lKXk=;
        h=Subject:To:From:Date:From;
        b=Eb1Aj1X2XtBQN7yQKGEb4qbTUTT0nLF5gwUOgmHtjZ5jx3aNvo4zZe4TB0SO/zSqc
         FQPO3Bxhcj3kKIHFMM3AQp1hIq39bm9nqqpYzQez79NKriiksSGs3KkRdTvivBKkhH
         UfM+Buf2tWe+qmb5tI7eUaAYsNla6eq864qOsOAc=
Subject: patch "usb: typec: tcpci: don't handle vSafe0V event if it's not enabled" added to usb-linus
To:     xu.yang_2@nxp.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 13:47:07 +0200
Message-ID: <1633434427234147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpci: don't handle vSafe0V event if it's not enabled

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 05300871c0e21c288bd5c30ac6f9b1da6ddeed22 Mon Sep 17 00:00:00 2001
From: Xu Yang <xu.yang_2@nxp.com>
Date: Sun, 26 Sep 2021 18:14:15 +0800
Subject: usb: typec: tcpci: don't handle vSafe0V event if it's not enabled

USB TCPCI Spec, 4.4.3 Mask Registers:
"A masked register will still indicate in the ALERT register, but shall
not set the Alert# pin low."

Thus, the Extended Status will still indicate in ALERT register if vSafe0V
is detected by TCPC even though being masked. In current code, howerer,
this event will not be handled in detection time. Rather it will be
handled when next ALERT event coming(CC evnet, PD event, etc).

Tcpm might transition to a wrong state in this situation. Thus, the vSafe0V
event should not be handled when it's masked.

Fixes: 766c485b86ef ("usb: typec: tcpci: Add support to report vSafe0V")
cc: <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20210926101415.3775058-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index 9858716698df..c15eec9cc460 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -696,7 +696,7 @@ irqreturn_t tcpci_irq(struct tcpci *tcpci)
 		tcpm_pd_receive(tcpci->port, &msg);
 	}
 
-	if (status & TCPC_ALERT_EXTENDED_STATUS) {
+	if (tcpci->data->vbus_vsafe0v && (status & TCPC_ALERT_EXTENDED_STATUS)) {
 		ret = regmap_read(tcpci->regmap, TCPC_EXTENDED_STATUS, &raw);
 		if (!ret && (raw & TCPC_EXTENDED_STATUS_VSAFE0V))
 			tcpm_vbus_change(tcpci->port);
-- 
2.33.0


