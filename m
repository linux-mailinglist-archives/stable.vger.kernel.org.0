Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA23C2AD3D8
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 11:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgKJKdx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 05:33:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:32045 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgKJKdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Nov 2020 05:33:53 -0500
IronPort-SDR: 3ph2+cBpTzO6ppz2TR+5cVule5aPwIsx0D8/MteT+d509zq68MhabSDKtV7IN1EoP2QaEGTH++
 jZN7uC4/CUAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9800"; a="149229439"
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="149229439"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2020 02:33:53 -0800
IronPort-SDR: VDv8Ahdhu/fR6uC0V+E/+OjZCN258CptI5GCcpgCQb7dtbSsWq26oNuUHj4TK8kw6dAFNSdGyx
 Zk2HYXrXthMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,466,1596524400"; 
   d="scan'208";a="428323338"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2020 02:33:51 -0800
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Benjamin Berg <bberg@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, Vladimir Yerilov <openmindead@gmail.com>
Subject: [PATCH] usb: typec: ucsi: Report power supply changes
Date:   Tue, 10 Nov 2020 13:33:50 +0300
Message-Id: <20201110103350.16397-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When the ucsi power supply goes online/offline, and when the
power levels change, the power supply class needs to be
notified so it can inform the user space.

Fixes: 992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
Cc: stable@vger.kernel.org
Reported-by: Vladimir Yerilov <openmindead@gmail.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/psy.c  | 9 +++++++++
 drivers/usb/typec/ucsi/ucsi.c | 7 ++++++-
 drivers/usb/typec/ucsi/ucsi.h | 2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/psy.c b/drivers/usb/typec/ucsi/psy.c
index 26ed0b520749a..571a51e162346 100644
--- a/drivers/usb/typec/ucsi/psy.c
+++ b/drivers/usb/typec/ucsi/psy.c
@@ -238,4 +238,13 @@ void ucsi_unregister_port_psy(struct ucsi_connector *con)
 		return;
 
 	power_supply_unregister(con->psy);
+	con->psy = NULL;
+}
+
+void ucsi_port_psy_changed(struct ucsi_connector *con)
+{
+	if (IS_ERR_OR_NULL(con->psy))
+		return;
+
+	power_supply_changed(con->psy);
 }
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 758b988ac518a..51a570d40a42e 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -643,8 +643,10 @@ static void ucsi_handle_connector_change(struct work_struct *work)
 	role = !!(con->status.flags & UCSI_CONSTAT_PWR_DIR);
 
 	if (con->status.change & UCSI_CONSTAT_POWER_OPMODE_CHANGE ||
-	    con->status.change & UCSI_CONSTAT_POWER_LEVEL_CHANGE)
+	    con->status.change & UCSI_CONSTAT_POWER_LEVEL_CHANGE) {
 		ucsi_pwr_opmode_change(con);
+		ucsi_port_psy_changed(con);
+	}
 
 	if (con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
 		typec_set_pwr_role(con->port, role);
@@ -674,6 +676,8 @@ static void ucsi_handle_connector_change(struct work_struct *work)
 			ucsi_register_partner(con);
 		else
 			ucsi_unregister_partner(con);
+
+		ucsi_port_psy_changed(con);
 	}
 
 	if (con->status.change & UCSI_CONSTAT_CAM_CHANGE) {
@@ -994,6 +998,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 				  !!(con->status.flags & UCSI_CONSTAT_PWR_DIR));
 		ucsi_pwr_opmode_change(con);
 		ucsi_register_partner(con);
+		ucsi_port_psy_changed(con);
 	}
 
 	if (con->partner) {
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index cba6f77bea61b..b7a92f2460507 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -340,9 +340,11 @@ int ucsi_resume(struct ucsi *ucsi);
 #if IS_ENABLED(CONFIG_POWER_SUPPLY)
 int ucsi_register_port_psy(struct ucsi_connector *con);
 void ucsi_unregister_port_psy(struct ucsi_connector *con);
+void ucsi_port_psy_changed(struct ucsi_connector *con);
 #else
 static inline int ucsi_register_port_psy(struct ucsi_connector *con) { return 0; }
 static inline void ucsi_unregister_port_psy(struct ucsi_connector *con) { }
+static inline void ucsi_port_psy_changed(struct ucsi_connector *con) { }
 #endif /* CONFIG_POWER_SUPPLY */
 
 #if IS_ENABLED(CONFIG_TYPEC_DP_ALTMODE)
-- 
2.28.0

