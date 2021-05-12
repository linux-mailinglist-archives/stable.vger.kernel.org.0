Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5578737C6B6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231551AbhELPxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:53:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237208AbhELPsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:48:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10FD7619B6;
        Wed, 12 May 2021 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833095;
        bh=iZm5o5dwrXWHgXaL7yFG8yES/bADeZ234noXAniQ7Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qdz3NjddTksxnqcDPLGmIG6hG341APi373M8zrurAq+/W/sryCz8eQm5f06CV/Xnc
         E25TJ5shi9FROks8XetO6SoZsVvHdeP0QsfWXcvzx/PVCMOYJ7fnlJL9ngbYU6tdzS
         4iBMoPzxQnkU/0amiDSwPi8vs6gqeddOhlU5/Zio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Badhri Jagan Sridharan <badhri@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.11 016/601] usb: typec: tcpm: Address incorrect values of tcpm psy for fixed supply
Date:   Wed, 12 May 2021 16:41:33 +0200
Message-Id: <20210512144828.356805581@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

commit f3dedafb8263ca4791a92a23f5230068f5bde008 upstream.

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
 drivers/usb/typec/tcpm/tcpm.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -338,7 +338,10 @@ struct tcpm_port {
 	unsigned int operating_snk_mw;
 	bool update_sink_caps;
 
-	/* Requested current / voltage */
+	/* Requested current / voltage to the port partner */
+	u32 req_current_limit;
+	u32 req_supply_voltage;
+	/* Actual current / voltage limit of the local port */
 	u32 current_limit;
 	u32 supply_voltage;
 
@@ -1904,8 +1907,8 @@ static void tcpm_pd_ctrl_request(struct
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
@@ -1991,8 +1994,8 @@ static void tcpm_pd_ctrl_request(struct
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
@@ -2609,8 +2612,8 @@ static int tcpm_pd_build_request(struct
 			 flags & RDO_CAP_MISMATCH ? " [mismatch]" : "");
 	}
 
-	port->current_limit = ma;
-	port->supply_voltage = mv;
+	port->req_current_limit = ma;
+	port->req_supply_voltage = mv;
 
 	return 0;
 }


