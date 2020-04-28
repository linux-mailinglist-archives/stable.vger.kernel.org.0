Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981621BC904
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgD1Sht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:37:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:56032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729641AbgD1Shs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:37:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46344208E0;
        Tue, 28 Apr 2020 18:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099067;
        bh=ooaSjJknCQQ798oLV8ZEWEF7fsDuWT8x7spDUMvvVDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YsM7LIbHHWsjgARUYKNFAGeBRjYr6TucHeIRfckY5fYHB2pZ8r8N2POVk/lQ02rHw
         OsR7M4BUb6xobdi7vNjfxAxE5EaISvTXp/lMKLr9eJsuEaGGw0f+H35f4cJOOX/urC
         zvx2vYpNIwUaZBzqLWjQFSndrgLD4IGKxayQ0OU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.6 151/167] usb: typec: tcpm: Ignore CC and vbus changes in PORT_RESET change
Date:   Tue, 28 Apr 2020 20:25:27 +0200
Message-Id: <20200428182244.657279548@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

commit 901789745a053286e0ced37960d44fa60267b940 upstream.

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
 drivers/usb/typec/tcpm/tcpm.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3759,6 +3759,14 @@ static void _tcpm_cc_change(struct tcpm_
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
@@ -3820,6 +3828,15 @@ static void _tcpm_pd_vbus_on(struct tcpm
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
@@ -3873,10 +3890,19 @@ static void _tcpm_pd_vbus_off(struct tcp
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


