Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0BA11AC200
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894744AbgDPNCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:02:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894629AbgDPNCS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:02:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E64C8206B9;
        Thu, 16 Apr 2020 13:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587042138;
        bh=CZSrTELTAkZf3umSKl0wTgGl7NOH2/aHcZzKZGHJ0D8=;
        h=Subject:To:From:Date:From;
        b=p+cSLs2H0FbrDfwUNsfutWY5Wbc9i6IVoi7+m2Phdd+5GErzECejKfyovSZoAvuyy
         ZLvLzBtyQlKSCpwwDC/Q1iU6v6NpVuTLKV/Bd2SDQbSYQ+Izl/h4m+2evjt9XUhqPr
         OTi2L50k1e4yjmBT9gJcrjbubtt+2sA32nLtN6a4=
Subject: patch "usb: typec: tcpm: Ignore CC and vbus changes in PORT_RESET change" added to usb-linus
To:     badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 16 Apr 2020 15:02:16 +0200
Message-ID: <1587042136205249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Ignore CC and vbus changes in PORT_RESET change

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 901789745a053286e0ced37960d44fa60267b940 Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Thu, 2 Apr 2020 14:59:47 -0700
Subject: usb: typec: tcpm: Ignore CC and vbus changes in PORT_RESET change

After PORT_RESET, the port is set to the appropriate
default_state. Ignore processing CC changes here as this
could cause the port to be switched into sink states
by default.

echo source > /sys/class/typec/port0/port_type

Before:
[  154.528547] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms
[  154.528560] CC1: 0 -> 0, CC2: 3 -> 0 [state PORT_RESET, polarity 0, disconnected]
[  154.528564] state change PORT_RESET -> SNK_UNATTACHED

After:
[  151.068814] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100 ms [rev3 NONE_AMS]
[  151.072440] CC1: 3 -> 0, CC2: 0 -> 0 [state PORT_RESET, polarity 0, disconnected]
[  151.172117] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 ms]
[  151.172136] pending state change PORT_RESET_WAIT_OFF -> SRC_UNATTACHED @ 870 ms [rev3 NONE_AMS]
[  152.060106] state change PORT_RESET_WAIT_OFF -> SRC_UNATTACHED [delayed 870 ms]
[  152.060118] Start toggling

Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200402215947.176577-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index de3576e6530a..82b19ebd7838 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3794,6 +3794,14 @@ static void _tcpm_cc_change(struct tcpm_port *port, enum typec_cc_status cc1,
 		 */
 		break;
 
+	case PORT_RESET:
+	case PORT_RESET_WAIT_OFF:
+		/*
+		 * State set back to default mode once the timer completes.
+		 * Ignore CC changes here.
+		 */
+		break;
+
 	default:
 		if (tcpm_port_is_disconnected(port))
 			tcpm_set_state(port, unattached_state(port), 0);
@@ -3855,6 +3863,15 @@ static void _tcpm_pd_vbus_on(struct tcpm_port *port)
 	case SRC_TRY_DEBOUNCE:
 		/* Do nothing, waiting for sink detection */
 		break;
+
+	case PORT_RESET:
+	case PORT_RESET_WAIT_OFF:
+		/*
+		 * State set back to default mode once the timer completes.
+		 * Ignore vbus changes here.
+		 */
+		break;
+
 	default:
 		break;
 	}
@@ -3908,10 +3925,19 @@ static void _tcpm_pd_vbus_off(struct tcpm_port *port)
 	case PORT_RESET_WAIT_OFF:
 		tcpm_set_state(port, tcpm_default_state(port), 0);
 		break;
+
 	case SRC_TRY_WAIT:
 	case SRC_TRY_DEBOUNCE:
 		/* Do nothing, waiting for sink detection */
 		break;
+
+	case PORT_RESET:
+		/*
+		 * State set back to default mode once the timer completes.
+		 * Ignore vbus changes here.
+		 */
+		break;
+
 	default:
 		if (port->pwr_role == TYPEC_SINK &&
 		    port->attached)
-- 
2.26.1


