Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45EE359FBA
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 15:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhDINXu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 09:23:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDINXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 09:23:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88838610A4;
        Fri,  9 Apr 2021 13:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617974617;
        bh=S2TpakAOsMCo4N8Gp1snBSIzV8scK9E3v0Bsh49QE7g=;
        h=Subject:To:From:Date:From;
        b=sWNSvSBFpuIJpVvtHbSlGHTowWiKYUMjyCAkIGKJzp/cQPlHd/33GUb+KgkLYfmLZ
         p2NY5KtPk0ynFDspVfq6pyIC9AWXDuIfalDOFa8qZKypZqAHRfgQAAHIzt0UApi+Zf
         PHjOyhe4LjgggE0f36cmxl7EgHI/uRcoS4dTsjsc=
Subject: patch "usb: typec: tcpm: Address incorrect values of tcpm psy for fixed" added to usb-testing
To:     badhri@google.com, Adam.Thomson.Opensource@diasemi.com,
        gregkh@linuxfoundation.org, heikki.krogerus@linux.intel.com,
        linux@roeck-us.net, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Apr 2021 15:23:34 +0200
Message-ID: <1617974614180197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: tcpm: Address incorrect values of tcpm psy for fixed

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From f3dedafb8263ca4791a92a23f5230068f5bde008 Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Wed, 7 Apr 2021 13:07:18 -0700
Subject: usb: typec: tcpm: Address incorrect values of tcpm psy for fixed
 supply

tcpm_pd_build_request overwrites current_limit and supply_voltage
even before port partner accepts the requests. This leaves stale
values in current_limit and supply_voltage that get exported by
"tcpm-source-psy-". Solving this problem by caching the request
values of current limit/supply voltage in req_current_limit
and req_supply_voltage. current_limit/supply_voltage gets updated
once the port partner accepts the request.

Fixes: f2a8aa053c176 ("typec: tcpm: Represent source supply through power_supply")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20210407200723.1914388-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index ca1fc77697fc..4ea4b30ae885 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -389,7 +389,10 @@ struct tcpm_port {
 	unsigned int operating_snk_mw;
 	bool update_sink_caps;
 
-	/* Requested current / voltage */
+	/* Requested current / voltage to the port partner */
+	u32 req_current_limit;
+	u32 req_supply_voltage;
+	/* Actual current / voltage limit of the local port */
 	u32 current_limit;
 	u32 supply_voltage;
 
@@ -2435,8 +2438,8 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 		case SNK_TRANSITION_SINK:
 			if (port->vbus_present) {
 				tcpm_set_current_limit(port,
-						       port->current_limit,
-						       port->supply_voltage);
+						       port->req_current_limit,
+						       port->req_supply_voltage);
 				port->explicit_contract = true;
 				tcpm_set_auto_vbus_discharge_threshold(port,
 								       TYPEC_PWR_MODE_PD,
@@ -2545,8 +2548,8 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			break;
 		case SNK_NEGOTIATE_PPS_CAPABILITIES:
 			port->pps_data.active = true;
-			port->supply_voltage = port->pps_data.out_volt;
-			port->current_limit = port->pps_data.op_curr;
+			port->req_supply_voltage = port->pps_data.out_volt;
+			port->req_current_limit = port->pps_data.op_curr;
 			tcpm_set_state(port, SNK_TRANSITION_SINK, 0);
 			break;
 		case SOFT_RESET_SEND:
@@ -3195,8 +3198,8 @@ static int tcpm_pd_build_request(struct tcpm_port *port, u32 *rdo)
 			 flags & RDO_CAP_MISMATCH ? " [mismatch]" : "");
 	}
 
-	port->current_limit = ma;
-	port->supply_voltage = mv;
+	port->req_current_limit = ma;
+	port->req_supply_voltage = mv;
 
 	return 0;
 }
-- 
2.31.1


