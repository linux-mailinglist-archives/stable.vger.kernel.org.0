Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5582523FEBF
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 16:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgHIOTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 10:19:19 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27373 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726338AbgHIOTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Aug 2020 10:19:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596982756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZDOjCziwIkF/d475Xu2YYuhS91BTpqJ+RjuMawHUmUM=;
        b=CovaLHqQ44F4PuTGfnwqrGpDFihGYDFBn49bDPdHRp88Xf6l7yii+T8prlZagrT/phFpWO
        BFClTMcnGO8shTF41PPIoZIqxM0wW+YlW9fPUs4vL8X4aD55dTQVZte9aJ7YogqI9dbMhh
        tLOxhDLALm9eG6uc0scf9h8Tk5Q30ic=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-6KsZi2IGO6S3Z1etxWzRWA-1; Sun, 09 Aug 2020 10:19:12 -0400
X-MC-Unique: 6KsZi2IGO6S3Z1etxWzRWA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8986107ACCA;
        Sun,  9 Aug 2020 14:19:11 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F23B8953D;
        Sun,  9 Aug 2020 14:19:10 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 3/4] usb: typec: ucsi: Rework ppm_lock handling
Date:   Sun,  9 Aug 2020 16:19:03 +0200
Message-Id: <20200809141904.4317-4-hdegoede@redhat.com>
In-Reply-To: <20200809141904.4317-1-hdegoede@redhat.com>
References: <20200809141904.4317-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/usb/typec/ucsi/ucsi.c | 56 ++++++++++++++---------------------
 1 file changed, 22 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 2f586d6c54f4..182e34aa65ed 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -146,42 +146,33 @@ static int ucsi_exec_command(struct ucsi *ucsi, u64 cmd)
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
@@ -738,20 +729,24 @@ static int ucsi_reset_ppm(struct ucsi *ucsi)
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
@@ -759,13 +754,15 @@ static int ucsi_reset_ppm(struct ucsi *ucsi)
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
@@ -777,9 +774,7 @@ static int ucsi_role_cmd(struct ucsi_connector *con, u64 command)
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
@@ -1072,12 +1063,9 @@ int ucsi_init(struct ucsi *ucsi)
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
-- 
2.26.2

