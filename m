Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2FC359FBB
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 15:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhDINX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 09:23:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDINX6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 09:23:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 510F9610FB;
        Fri,  9 Apr 2021 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617974625;
        bh=28RoI+POolWYZEt+2rPIYxyrNO2OJto4IXLjmj4J/w0=;
        h=Subject:To:From:Date:From;
        b=YcNmyv2Z5D3+1f06MPUD9mSez/Be6eR3w0UDj6XdbTTAXRqAY2dEttrwoGS0+8nrR
         8fZdVq4Svz0EyaknQMYg6pdPCL2BA79ebxmOA5sF0UqgMCBfojreLEtSzHsMBDocQZ
         zt2LsDhsE/LbWU2Kn+0TbSr53zVlOy1l9Ixy2Ovs=
Subject: patch "usb: typec: tcpm: update power supply once partner accepts" added to usb-testing
To:     badhri@google.com, Adam.Thomson.Opensource@diasemi.com,
        gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Apr 2021 15:23:35 +0200
Message-ID: <16179746156736@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: update power supply once partner accepts

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 4050f2683f2c3151dc3dd1501ac88c57caf810ff Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Wed, 7 Apr 2021 13:07:20 -0700
Subject: usb: typec: tcpm: update power supply once partner accepts

power_supply_changed needs to be called to notify clients
after the partner accepts the requested values for the pps
case.

Also, remove the redundant power_supply_changed at the end
of the tcpm_reset_port as power_supply_changed is already
called right after usb_type is changed.

Fixes: f2a8aa053c176 ("typec: tcpm: Represent source supply through power_supply")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210407200723.1914388-3-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index b4a40099d7e9..d1d03ee90d8f 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2568,6 +2568,7 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			port->pps_data.max_curr = port->pps_data.req_max_curr;
 			port->req_supply_voltage = port->pps_data.req_out_volt;
 			port->req_current_limit = port->pps_data.req_op_curr;
+			power_supply_changed(port->psy);
 			tcpm_set_state(port, SNK_TRANSITION_SINK, 0);
 			break;
 		case SOFT_RESET_SEND:
@@ -3136,7 +3137,6 @@ static unsigned int tcpm_pd_select_pps_apdo(struct tcpm_port *port)
 						      port->pps_data.req_out_volt));
 		port->pps_data.req_op_curr = min(port->pps_data.max_curr,
 						 port->pps_data.req_op_curr);
-		power_supply_changed(port->psy);
 	}
 
 	return src_pdo;
@@ -3561,8 +3561,6 @@ static void tcpm_reset_port(struct tcpm_port *port)
 	port->sink_cap_done = false;
 	if (port->tcpc->enable_frs)
 		port->tcpc->enable_frs(port->tcpc, false);
-
-	power_supply_changed(port->psy);
 }
 
 static void tcpm_detach(struct tcpm_port *port)
-- 
2.31.1


