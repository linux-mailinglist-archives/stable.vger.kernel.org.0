Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805F623FEBA
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 16:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbgHIOTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 10:19:15 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52618 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726229AbgHIOTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Aug 2020 10:19:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596982751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3SxBwwd/jGFDYXHUnTvTxkgkCOmK+BmPZI0Qya15sKI=;
        b=L4LON/UD5yJMLt0Ybma+Es28iR+5GkwBCMaxU57iRjFYyAoR5hgBcXrl/YtjXV73iegfKv
        +QF/v7y0NIh+mb04REXo8YDumfWy/4Z6xkkB4DQnt4FjH1cr9qGwmqV3zoVZhJS/FmnGDb
        6F3ssDWb5bW3i/qHm+urfCO4TQ9/Tok=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-rbjyxjQ3NQi0B5g-dDpI3g-1; Sun, 09 Aug 2020 10:19:09 -0400
X-MC-Unique: rbjyxjQ3NQi0B5g-dDpI3g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EBB457;
        Sun,  9 Aug 2020 14:19:08 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67A8989528;
        Sun,  9 Aug 2020 14:19:07 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/4] usb: typec: ucsi: Fix AB BA lock inversion
Date:   Sun,  9 Aug 2020 16:19:01 +0200
Message-Id: <20200809141904.4317-2-hdegoede@redhat.com>
In-Reply-To: <20200809141904.4317-1-hdegoede@redhat.com>
References: <20200809141904.4317-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/typec/ucsi/ucsi.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index d0c63afaf345..d9d93f83b2a6 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -205,7 +205,7 @@ void ucsi_altmode_update_active(struct ucsi_connector *con)
 	int i;
 
 	command = UCSI_GET_CURRENT_CAM | UCSI_CONNECTOR_NUMBER(con->num);
-	ret = ucsi_run_command(con->ucsi, command, &cur, sizeof(cur));
+	ret = ucsi_send_command(con->ucsi, command, &cur, sizeof(cur));
 	if (ret < 0) {
 		if (con->ucsi->version > 0x0100) {
 			dev_err(con->ucsi->dev,
@@ -354,7 +354,7 @@ ucsi_register_altmodes_nvidia(struct ucsi_connector *con, u8 recipient)
 		command |= UCSI_GET_ALTMODE_RECIPIENT(recipient);
 		command |= UCSI_GET_ALTMODE_CONNECTOR_NUMBER(con->num);
 		command |= UCSI_GET_ALTMODE_OFFSET(i);
-		len = ucsi_run_command(con->ucsi, command, &alt, sizeof(alt));
+		len = ucsi_send_command(con->ucsi, command, &alt, sizeof(alt));
 		/*
 		 * We are collecting all altmodes first and then registering.
 		 * Some type-C device will return zero length data beyond last
@@ -431,7 +431,7 @@ static int ucsi_register_altmodes(struct ucsi_connector *con, u8 recipient)
 		command |= UCSI_GET_ALTMODE_RECIPIENT(recipient);
 		command |= UCSI_GET_ALTMODE_CONNECTOR_NUMBER(con->num);
 		command |= UCSI_GET_ALTMODE_OFFSET(i);
-		len = ucsi_run_command(con->ucsi, command, alt, sizeof(alt));
+		len = ucsi_send_command(con->ucsi, command, alt, sizeof(alt));
 		if (len <= 0)
 			return len;
 
@@ -904,7 +904,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 	/* Get connector capability */
 	command = UCSI_GET_CONNECTOR_CAPABILITY;
 	command |= UCSI_CONNECTOR_NUMBER(con->num);
-	ret = ucsi_run_command(ucsi, command, &con->cap, sizeof(con->cap));
+	ret = ucsi_send_command(ucsi, command, &con->cap, sizeof(con->cap));
 	if (ret < 0)
 		return ret;
 
@@ -953,8 +953,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 
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
@@ -1071,6 +1070,7 @@ int ucsi_init(struct ucsi *ucsi)
 		con->port = NULL;
 	}
 
+	mutex_lock(&ucsi->ppm_lock);
 err_reset:
 	ucsi_reset_ppm(ucsi);
 err:
-- 
2.26.2

