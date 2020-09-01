Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC2C259512
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbgIAPqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:35872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731936AbgIAPqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:46:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69C352064B;
        Tue,  1 Sep 2020 15:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975178;
        bh=0EUNTPPCVwgzQmDdYE7kHJ1PxpDGLOF+4EBNPDYdSvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upaCsvCaXxiD6m7lHqfCR5G6BGeO0XUH5yto8vBgZosDMeUcUgxfAhakTeQ5lBwEc
         yUGlZaSEgCKjaj22yv+Xlr5QsQT1QGT3qVgn5VTx5g/ejCb845SEEtZepH4NE231lE
         m0evX9/naz8Pj8WPoW1rWYdBCe3B94pvnBYJ6sbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.8 239/255] usb: typec: ucsi: Fix 2 unlocked ucsi_run_command calls
Date:   Tue,  1 Sep 2020 17:11:35 +0200
Message-Id: <20200901151012.205826937@linuxfoundation.org>
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

commit 7e90057f125c8c852940b848e06e7a72f050fc6f upstream.

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
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20200809141904.4317-3-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/ucsi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -152,6 +152,8 @@ static int ucsi_run_command(struct ucsi
 	u8 length;
 	int ret;
 
+	WARN_ON(!mutex_is_locked(&ucsi->ppm_lock));
+
 	ret = ucsi_exec_command(ucsi, command);
 	if (ret < 0)
 		return ret;
@@ -502,7 +504,7 @@ static void ucsi_get_pdos(struct ucsi_co
 	command |= UCSI_GET_PDOS_PARTNER_PDO(is_partner);
 	command |= UCSI_GET_PDOS_NUM_PDOS(UCSI_MAX_PDOS - 1);
 	command |= UCSI_GET_PDOS_SRC_PDOS;
-	ret = ucsi_run_command(ucsi, command, con->src_pdos,
+	ret = ucsi_send_command(ucsi, command, con->src_pdos,
 			       sizeof(con->src_pdos));
 	if (ret < 0) {
 		dev_err(ucsi->dev, "UCSI_GET_PDOS failed (%d)\n", ret);
@@ -681,7 +683,7 @@ static void ucsi_handle_connector_change
 		 */
 		command = UCSI_GET_CAM_SUPPORTED;
 		command |= UCSI_CONNECTOR_NUMBER(con->num);
-		ucsi_run_command(con->ucsi, command, NULL, 0);
+		ucsi_send_command(con->ucsi, command, NULL, 0);
 	}
 
 	if (con->status.change & UCSI_CONSTAT_PARTNER_CHANGE)


