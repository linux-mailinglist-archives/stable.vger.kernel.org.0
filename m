Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB2E259511
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731659AbgIAPqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731694AbgIAPqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB4D6206FA;
        Tue,  1 Sep 2020 15:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975175;
        bh=xfO1u2PPaS2QW8600aN9UjDU60PC4B7Dyb/0Idw7mcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iz1uZuC3OGqsff6teGrZhQrY6ya63R7+sJk5TKx18qRfXjdrA8rh98LDugQOV0fgL
         7rotVEB5TeaC2lJCh/DSNV7+HDZhFqwK6wk4OWKviGJbeEfY0qcnjtyGeuLi+t05G4
         pSGjc8mZW7Ocd8zQ49IzEr3lXjLO/OqRMcQH4TdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.8 238/255] usb: typec: ucsi: Fix AB BA lock inversion
Date:   Tue,  1 Sep 2020 17:11:34 +0200
Message-Id: <20200901151012.158111855@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 0ff0705a2ef2929e9326c95df48bdbebb0dafaad upstream.

Lockdep reports an AB BA lock inversion between ucsi_init() and
ucsi_handle_connector_change():

AB order:

1. ucsi_init takes ucsi->ppm_lock (it runs with that locked for the
   duration of the function)
2. usci_init eventually end up calling ucsi_register_displayport,
   which takes ucsi_connector->lock

BA order:

1. ucsi_handle_connector_change work is started, takes ucsi_connector->lock
2. ucsi_handle_connector_change calls ucsi_send_command which takes
   ucsi->ppm_lock

The ppm_lock really only needs to be hold during 2 functions:
ucsi_reset_ppm() and ucsi_run_command().

This commit fixes the AB BA lock inversion by making ucsi_init drop the
ucsi->ppm_lock before it starts registering ports; and replacing any
ucsi_run_command() calls after this point with ucsi_send_command()
(which is a wrapper around run_command taking the lock while handling
the command).

Some of the replacing of ucsi_run_command with ucsi_send_command
in the helpers used during port registration also fixes a number of
code paths after registration which call ucsi_run_command() without
holding the ppm_lock:
1. ucsi_altmode_update_active() call in ucsi/displayport.c
2. ucsi_register_altmodes() call from ucsi_handle_connector_change()
   (through ucsi_partner_change())

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200809141904.4317-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/ucsi.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -205,7 +205,7 @@ void ucsi_altmode_update_active(struct u
 	int i;
 
 	command = UCSI_GET_CURRENT_CAM | UCSI_CONNECTOR_NUMBER(con->num);
-	ret = ucsi_run_command(con->ucsi, command, &cur, sizeof(cur));
+	ret = ucsi_send_command(con->ucsi, command, &cur, sizeof(cur));
 	if (ret < 0) {
 		if (con->ucsi->version > 0x0100) {
 			dev_err(con->ucsi->dev,
@@ -354,7 +354,7 @@ ucsi_register_altmodes_nvidia(struct ucs
 		command |= UCSI_GET_ALTMODE_RECIPIENT(recipient);
 		command |= UCSI_GET_ALTMODE_CONNECTOR_NUMBER(con->num);
 		command |= UCSI_GET_ALTMODE_OFFSET(i);
-		len = ucsi_run_command(con->ucsi, command, &alt, sizeof(alt));
+		len = ucsi_send_command(con->ucsi, command, &alt, sizeof(alt));
 		/*
 		 * We are collecting all altmodes first and then registering.
 		 * Some type-C device will return zero length data beyond last
@@ -431,7 +431,7 @@ static int ucsi_register_altmodes(struct
 		command |= UCSI_GET_ALTMODE_RECIPIENT(recipient);
 		command |= UCSI_GET_ALTMODE_CONNECTOR_NUMBER(con->num);
 		command |= UCSI_GET_ALTMODE_OFFSET(i);
-		len = ucsi_run_command(con->ucsi, command, alt, sizeof(alt));
+		len = ucsi_send_command(con->ucsi, command, alt, sizeof(alt));
 		if (len <= 0)
 			return len;
 
@@ -904,7 +904,7 @@ static int ucsi_register_port(struct ucs
 	/* Get connector capability */
 	command = UCSI_GET_CONNECTOR_CAPABILITY;
 	command |= UCSI_CONNECTOR_NUMBER(con->num);
-	ret = ucsi_run_command(ucsi, command, &con->cap, sizeof(con->cap));
+	ret = ucsi_send_command(ucsi, command, &con->cap, sizeof(con->cap));
 	if (ret < 0)
 		return ret;
 
@@ -953,8 +953,7 @@ static int ucsi_register_port(struct ucs
 
 	/* Get the status */
 	command = UCSI_GET_CONNECTOR_STATUS | UCSI_CONNECTOR_NUMBER(con->num);
-	ret = ucsi_run_command(ucsi, command, &con->status,
-			       sizeof(con->status));
+	ret = ucsi_send_command(ucsi, command, &con->status, sizeof(con->status));
 	if (ret < 0) {
 		dev_err(ucsi->dev, "con%d: failed to get status\n", con->num);
 		return 0;
@@ -1044,6 +1043,8 @@ int ucsi_init(struct ucsi *ucsi)
 		goto err_reset;
 	}
 
+	mutex_unlock(&ucsi->ppm_lock);
+
 	/* Register all connectors */
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		ret = ucsi_register_port(ucsi, i);
@@ -1054,12 +1055,10 @@ int ucsi_init(struct ucsi *ucsi)
 	/* Enable all notifications */
 	ucsi->ntfy = UCSI_ENABLE_NTFY_ALL;
 	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
-	ret = ucsi_run_command(ucsi, command, NULL, 0);
+	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_unregister;
 
-	mutex_unlock(&ucsi->ppm_lock);
-
 	return 0;
 
 err_unregister:
@@ -1071,6 +1070,7 @@ err_unregister:
 		con->port = NULL;
 	}
 
+	mutex_lock(&ucsi->ppm_lock);
 err_reset:
 	ucsi_reset_ppm(ucsi);
 err:


