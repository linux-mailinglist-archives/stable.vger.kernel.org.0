Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F46C23FEBB
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 16:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgHIOTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Aug 2020 10:19:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbgHIOTP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Aug 2020 10:19:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596982752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOpm/LW+Nh4/Mu7TFYJaCp9eVKMGAcoccGk5/CvTIYE=;
        b=bGkRK9Nr9D1fapKTt0HGKuK11DklzuF9x/ntmfdwXae9N11RPJiJJCLtnFhqQsOr25qfOJ
        wOUDCK5O/g5xvm+ANxVe3KqnPBoDnpd+0pY+Ha8pSNkb+UW6VezPGamyenkDsMXQsQYKeI
        EkP7/wQZGxIM3DWhyd72NdF0s6hwMJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-o7ud7HIcOdy_f34dSmWQzQ-1; Sun, 09 Aug 2020 10:19:11 -0400
X-MC-Unique: o7ud7HIcOdy_f34dSmWQzQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 292768015CE;
        Sun,  9 Aug 2020 14:19:10 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3FB589528;
        Sun,  9 Aug 2020 14:19:08 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/4] usb: typec: ucsi: Fix 2 unlocked ucsi_run_command calls
Date:   Sun,  9 Aug 2020 16:19:02 +0200
Message-Id: <20200809141904.4317-3-hdegoede@redhat.com>
In-Reply-To: <20200809141904.4317-1-hdegoede@redhat.com>
References: <20200809141904.4317-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix 2 unlocked ucsi_run_command calls:

1. ucsi_handle_connector_change() contains one ucsi_send_command() call,
which takes the ppm_lock for it; and one ucsi_run_command() call which
relies on the caller have taking the ppm_lock.
ucsi_handle_connector_change() does not take the lock, so the
second (ucsi_run_command) calls should also be ucsi_send_command().

2. ucsi_get_pdos() gets called from ucsi_handle_connector_change() which
does not hold the ppm_lock, so it also must use ucsi_send_command().

This commit also adds a WARN_ON(!mutex_is_locked(&ucsi->ppm_lock)); to
ucsi_run_command() to avoid similar problems getting re-introduced in
the future.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index d9d93f83b2a6..2f586d6c54f4 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -152,6 +152,8 @@ static int ucsi_run_command(struct ucsi *ucsi, u64 command,
 	u8 length;
 	int ret;
 
+	WARN_ON(!mutex_is_locked(&ucsi->ppm_lock));
+
 	ret = ucsi_exec_command(ucsi, command);
 	if (ret < 0)
 		return ret;
@@ -502,7 +504,7 @@ static void ucsi_get_pdos(struct ucsi_connector *con, int is_partner)
 	command |= UCSI_GET_PDOS_PARTNER_PDO(is_partner);
 	command |= UCSI_GET_PDOS_NUM_PDOS(UCSI_MAX_PDOS - 1);
 	command |= UCSI_GET_PDOS_SRC_PDOS;
-	ret = ucsi_run_command(ucsi, command, con->src_pdos,
+	ret = ucsi_send_command(ucsi, command, con->src_pdos,
 			       sizeof(con->src_pdos));
 	if (ret < 0) {
 		dev_err(ucsi->dev, "UCSI_GET_PDOS failed (%d)\n", ret);
@@ -681,7 +683,7 @@ static void ucsi_handle_connector_change(struct work_struct *work)
 		 */
 		command = UCSI_GET_CAM_SUPPORTED;
 		command |= UCSI_CONNECTOR_NUMBER(con->num);
-		ucsi_run_command(con->ucsi, command, NULL, 0);
+		ucsi_send_command(con->ucsi, command, NULL, 0);
 	}
 
 	if (con->status.change & UCSI_CONSTAT_PARTNER_CHANGE)
-- 
2.26.2

