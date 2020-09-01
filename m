Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BED259513
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731691AbgIAPqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731939AbgIAPqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC6B92078B;
        Tue,  1 Sep 2020 15:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975180;
        bh=kA71fcJpkNopAAf52LgGtHDj8v411drt7EX2rOGPScw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJdE6Tls+4P0spW3VJrV3xtuXAlkCSj/7Vi8lV1a1OiJCA4CgpWa9uPIv2ba3yjCI
         nRMafetBv8oX+N4gE7WRKNLNuSHyJm5QJWKUeZWXxSwXcdGhMlputwkprq61LMb0w9
         I48z6+fkeOkBFMHKDtCm7nzhXn2GZij0AkkK9lPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.8 240/255] usb: typec: ucsi: Rework ppm_lock handling
Date:   Tue,  1 Sep 2020 17:11:36 +0200
Message-Id: <20200901151012.253319597@linuxfoundation.org>
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

commit 25794e3079d2a98547b6bf5764ef0240aa89b798 upstream.

The ppm_lock really only needs to be hold during 2 functions:
ucsi_reset_ppm() and ucsi_run_command().

Push the taking of the lock down into these 2 functions, renaming
ucsi_run_command() to ucsi_send_command() which was an existing
wrapper already taking the lock for its callers.

This simplifies things for the callers and removes the difference
between ucsi_send_command() and ucsi_run_command() which has led
to various locking bugs in the past.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200809141904.4317-4-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/ucsi.c |   56 ++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 34 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -146,42 +146,33 @@ static int ucsi_exec_command(struct ucsi
 	return UCSI_CCI_LENGTH(cci);
 }
 
-static int ucsi_run_command(struct ucsi *ucsi, u64 command,
-			    void *data, size_t size)
+int ucsi_send_command(struct ucsi *ucsi, u64 command,
+		      void *data, size_t size)
 {
 	u8 length;
 	int ret;
 
-	WARN_ON(!mutex_is_locked(&ucsi->ppm_lock));
+	mutex_lock(&ucsi->ppm_lock);
 
 	ret = ucsi_exec_command(ucsi, command);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	length = ret;
 
 	if (data) {
 		ret = ucsi->ops->read(ucsi, UCSI_MESSAGE_IN, data, size);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	ret = ucsi_acknowledge_command(ucsi);
 	if (ret)
-		return ret;
-
-	return length;
-}
+		goto out;
 
-int ucsi_send_command(struct ucsi *ucsi, u64 command,
-		      void *retval, size_t size)
-{
-	int ret;
-
-	mutex_lock(&ucsi->ppm_lock);
-	ret = ucsi_run_command(ucsi, command, retval, size);
+	ret = length;
+out:
 	mutex_unlock(&ucsi->ppm_lock);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ucsi_send_command);
@@ -738,20 +729,24 @@ static int ucsi_reset_ppm(struct ucsi *u
 	u32 cci;
 	int ret;
 
+	mutex_lock(&ucsi->ppm_lock);
+
 	ret = ucsi->ops->async_write(ucsi, UCSI_CONTROL, &command,
 				     sizeof(command));
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	tmo = jiffies + msecs_to_jiffies(UCSI_TIMEOUT_MS);
 
 	do {
-		if (time_is_before_jiffies(tmo))
-			return -ETIMEDOUT;
+		if (time_is_before_jiffies(tmo)) {
+			ret = -ETIMEDOUT;
+			goto out;
+		}
 
 		ret = ucsi->ops->read(ucsi, UCSI_CCI, &cci, sizeof(cci));
 		if (ret)
-			return ret;
+			goto out;
 
 		/* If the PPM is still doing something else, reset it again. */
 		if (cci & ~UCSI_CCI_RESET_COMPLETE) {
@@ -759,13 +754,15 @@ static int ucsi_reset_ppm(struct ucsi *u
 						     &command,
 						     sizeof(command));
 			if (ret < 0)
-				return ret;
+				goto out;
 		}
 
 		msleep(20);
 	} while (!(cci & UCSI_CCI_RESET_COMPLETE));
 
-	return 0;
+out:
+	mutex_unlock(&ucsi->ppm_lock);
+	return ret;
 }
 
 static int ucsi_role_cmd(struct ucsi_connector *con, u64 command)
@@ -777,9 +774,7 @@ static int ucsi_role_cmd(struct ucsi_con
 		u64 c;
 
 		/* PPM most likely stopped responding. Resetting everything. */
-		mutex_lock(&con->ucsi->ppm_lock);
 		ucsi_reset_ppm(con->ucsi);
-		mutex_unlock(&con->ucsi->ppm_lock);
 
 		c = UCSI_SET_NOTIFICATION_ENABLE | con->ucsi->ntfy;
 		ucsi_send_command(con->ucsi, c, NULL, 0);
@@ -1010,8 +1005,6 @@ int ucsi_init(struct ucsi *ucsi)
 	int ret;
 	int i;
 
-	mutex_lock(&ucsi->ppm_lock);
-
 	/* Reset the PPM */
 	ret = ucsi_reset_ppm(ucsi);
 	if (ret) {
@@ -1022,13 +1015,13 @@ int ucsi_init(struct ucsi *ucsi)
 	/* Enable basic notifications */
 	ucsi->ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
 	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
-	ret = ucsi_run_command(ucsi, command, NULL, 0);
+	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_reset;
 
 	/* Get PPM capabilities */
 	command = UCSI_GET_CAPABILITY;
-	ret = ucsi_run_command(ucsi, command, &ucsi->cap, sizeof(ucsi->cap));
+	ret = ucsi_send_command(ucsi, command, &ucsi->cap, sizeof(ucsi->cap));
 	if (ret < 0)
 		goto err_reset;
 
@@ -1045,8 +1038,6 @@ int ucsi_init(struct ucsi *ucsi)
 		goto err_reset;
 	}
 
-	mutex_unlock(&ucsi->ppm_lock);
-
 	/* Register all connectors */
 	for (i = 0; i < ucsi->cap.num_connectors; i++) {
 		ret = ucsi_register_port(ucsi, i);
@@ -1072,12 +1063,9 @@ err_unregister:
 		con->port = NULL;
 	}
 
-	mutex_lock(&ucsi->ppm_lock);
 err_reset:
 	ucsi_reset_ppm(ucsi);
 err:
-	mutex_unlock(&ucsi->ppm_lock);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ucsi_init);


