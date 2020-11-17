Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9E2B643B
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732881AbgKQNpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:45:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732150AbgKQNjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:39:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88B4E2465E;
        Tue, 17 Nov 2020 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620388;
        bh=y24tq/uZoF7Z8AzdoEnd60M9185zguZyDp16jYYr+TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JRBiSpwRcQ8L7MtTOHEyfyoEKspx5DNJ+SiHFc6Ru57U+lU4d1e0vpw7hmdOa5/9C
         3NcCaD1s3g6+iL3+Y5KjqJXGtUP8mYT/ByYT+rU0a0SZ5J5WrKLwNYy0d+QL8+UTeZ
         /25wk7/t1Att6oVZr5/n64/BYzcBv9sV7jqrc1NE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Vladimir Yerilov <openmindead@gmail.com>
Subject: [PATCH 5.9 202/255] usb: typec: ucsi: Report power supply changes
Date:   Tue, 17 Nov 2020 14:05:42 +0100
Message-Id: <20201117122148.762781964@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 0e6371fbfba3a4f76489e6e97c1c7f8386ad5fd2 upstream.

When the ucsi power supply goes online/offline, and when the
power levels change, the power supply class needs to be
notified so it can inform the user space.

Fixes: 992a60ed0d5e ("usb: typec: ucsi: register with power_supply class")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Vladimir Yerilov <openmindead@gmail.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20201110120547.67922-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/psy.c  |    9 +++++++++
 drivers/usb/typec/ucsi/ucsi.c |    7 ++++++-
 drivers/usb/typec/ucsi/ucsi.h |    2 ++
 3 files changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/psy.c
+++ b/drivers/usb/typec/ucsi/psy.c
@@ -238,4 +238,13 @@ void ucsi_unregister_port_psy(struct ucs
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
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -643,8 +643,10 @@ static void ucsi_handle_connector_change
 	role = !!(con->status.flags & UCSI_CONSTAT_PWR_DIR);
 
 	if (con->status.change & UCSI_CONSTAT_POWER_OPMODE_CHANGE ||
-	    con->status.change & UCSI_CONSTAT_POWER_LEVEL_CHANGE)
+	    con->status.change & UCSI_CONSTAT_POWER_LEVEL_CHANGE) {
 		ucsi_pwr_opmode_change(con);
+		ucsi_port_psy_changed(con);
+	}
 
 	if (con->status.change & UCSI_CONSTAT_POWER_DIR_CHANGE) {
 		typec_set_pwr_role(con->port, role);
@@ -674,6 +676,8 @@ static void ucsi_handle_connector_change
 			ucsi_register_partner(con);
 		else
 			ucsi_unregister_partner(con);
+
+		ucsi_port_psy_changed(con);
 	}
 
 	if (con->status.change & UCSI_CONSTAT_CAM_CHANGE) {
@@ -994,6 +998,7 @@ static int ucsi_register_port(struct ucs
 				  !!(con->status.flags & UCSI_CONSTAT_PWR_DIR));
 		ucsi_pwr_opmode_change(con);
 		ucsi_register_partner(con);
+		ucsi_port_psy_changed(con);
 	}
 
 	if (con->partner) {
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


