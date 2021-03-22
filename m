Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD76344179
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhCVMdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231440AbhCVMcw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DF5B60C3D;
        Mon, 22 Mar 2021 12:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416372;
        bh=HduXnkpgaGEVxGOkeCW2FrCsDahfW4MfHaIsYuQ3T9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgKClUz2U4VngHq6TPD5RhDSYoEY9FeP6Gl/u0y4s5Hm+EuRGHZNhD8x5CNW/aOCQ
         vg+Y1PnJ8pYdkBzyQIJOIMUGBj7ZuJ4WJZw0kAfMr2UYL63tnqQ46rQnQBqNGyjGyl
         gGLS3DWHuweEI5hIPpt2c4Ncmrhyb1RAbNZ1AUlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.11 082/120] usb: typec: tcpm: Invoke power_supply_changed for tcpm-source-psy-
Date:   Mon, 22 Mar 2021 13:27:45 +0100
Message-Id: <20210322121932.413344728@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Badhri Jagan Sridharan <badhri@google.com>

commit 86629e098a077922438efa98dc80917604dfd317 upstream.

tcpm-source-psy- does not invoke power_supply_changed API when
one of the published power supply properties is changed.
power_supply_changed needs to be called to notify
userspace clients(uevents) and kernel clients.

Fixes: f2a8aa053c176 ("typec: tcpm: Represent source supply through power_supply")
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210317181249.1062995-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -797,6 +797,7 @@ static int tcpm_set_current_limit(struct
 
 	port->supply_voltage = mv;
 	port->current_limit = max_ma;
+	power_supply_changed(port->psy);
 
 	if (port->tcpc->set_current_limit)
 		ret = port->tcpc->set_current_limit(port->tcpc, max_ma, mv);
@@ -2345,6 +2346,7 @@ static int tcpm_pd_select_pdo(struct tcp
 
 	port->pps_data.supported = false;
 	port->usb_type = POWER_SUPPLY_USB_TYPE_PD;
+	power_supply_changed(port->psy);
 
 	/*
 	 * Select the source PDO providing the most power which has a
@@ -2369,6 +2371,7 @@ static int tcpm_pd_select_pdo(struct tcp
 				port->pps_data.supported = true;
 				port->usb_type =
 					POWER_SUPPLY_USB_TYPE_PD_PPS;
+				power_supply_changed(port->psy);
 			}
 			continue;
 		default:
@@ -2526,6 +2529,7 @@ static unsigned int tcpm_pd_select_pps_a
 						  port->pps_data.out_volt));
 		port->pps_data.op_curr = min(port->pps_data.max_curr,
 					     port->pps_data.op_curr);
+		power_supply_changed(port->psy);
 	}
 
 	return src_pdo;
@@ -2761,6 +2765,7 @@ static int tcpm_set_charge(struct tcpm_p
 			return ret;
 	}
 	port->vbus_charge = charge;
+	power_supply_changed(port->psy);
 	return 0;
 }
 
@@ -2935,6 +2940,7 @@ static void tcpm_reset_port(struct tcpm_
 	port->try_src_count = 0;
 	port->try_snk_count = 0;
 	port->usb_type = POWER_SUPPLY_USB_TYPE_C;
+	power_supply_changed(port->psy);
 	port->nr_sink_caps = 0;
 	port->sink_cap_done = false;
 	if (port->tcpc->enable_frs)
@@ -5129,7 +5135,7 @@ static int tcpm_psy_set_prop(struct powe
 		ret = -EINVAL;
 		break;
 	}
-
+	power_supply_changed(port->psy);
 	return ret;
 }
 
@@ -5281,6 +5287,7 @@ struct tcpm_port *tcpm_register_port(str
 	err = devm_tcpm_psy_register(port);
 	if (err)
 		goto out_role_sw_put;
+	power_supply_changed(port->psy);
 
 	port->typec_port = typec_register_port(port->dev, &port->typec_caps);
 	if (IS_ERR(port->typec_port)) {


