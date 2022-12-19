Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5732F651313
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 20:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiLST10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 14:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbiLST0x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 14:26:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DD715732
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 11:26:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98A516109A
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 19:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DE9C433EF;
        Mon, 19 Dec 2022 19:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671477991;
        bh=JqVEA2Ejf2NRJJVe+CozMdgpuaLQeYnYwSoFfhfztXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0CiC3S1MFqC9KCwmxGuMNXGvjPQap1Sd7C3uAm9W/fFH2uklDkC3iknHR6GoABqfc
         qx2WJYmXLAbzcC5l64Cdo4mlLU0qXo0MXPDRD2e91BcQSIm1ZvVP7T2k2UMS3fmBUX
         k+bdeyaNdaH3Bb6bme83oVta62AxSMBq9gW1CtiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Todd Brandt <todd.e.brandt@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.0 22/28] usb: typec: ucsi: Resume in separate work
Date:   Mon, 19 Dec 2022 20:23:09 +0100
Message-Id: <20221219182945.149297846@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221219182944.179389009@linuxfoundation.org>
References: <20221219182944.179389009@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit e0dced9c7d4763fd97c86a13902d135f03cc42eb upstream.

It can take more than one second to check each connector
when the system is resumed. So if you have, say, eight
connectors, it may take eight seconds for ucsi_resume() to
finish. That's a bit too much.

This will modify ucsi_resume() so that it schedules a work
where the interface is actually resumed instead of checking
the connectors directly. The connections will also be
checked in separate tasks which are queued for each connector
separately.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216706
Fixes: 99f6d4361113 ("usb: typec: ucsi: Check the connection on resume")
Cc: <stable@vger.kernel.org>
Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20221123093021.25981-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   17 +++++++++++++----
 drivers/usb/typec/ucsi/ucsi.h |    1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1270,8 +1270,9 @@ err:
 	return ret;
 }
 
-int ucsi_resume(struct ucsi *ucsi)
+static void ucsi_resume_work(struct work_struct *work)
 {
+	struct ucsi *ucsi = container_of(work, struct ucsi, resume_work);
 	struct ucsi_connector *con;
 	u64 command;
 	int ret;
@@ -1279,15 +1280,21 @@ int ucsi_resume(struct ucsi *ucsi)
 	/* Restore UCSI notification enable mask after system resume */
 	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
-	if (ret < 0)
-		return ret;
+	if (ret < 0) {
+		dev_err(ucsi->dev, "failed to re-enable notifications (%d)\n", ret);
+		return;
+	}
 
 	for (con = ucsi->connector; con->port; con++) {
 		mutex_lock(&con->lock);
-		ucsi_check_connection(con);
+		ucsi_partner_task(con, ucsi_check_connection, 1, 0);
 		mutex_unlock(&con->lock);
 	}
+}
 
+int ucsi_resume(struct ucsi *ucsi)
+{
+	queue_work(system_long_wq, &ucsi->resume_work);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ucsi_resume);
@@ -1347,6 +1354,7 @@ struct ucsi *ucsi_create(struct device *
 	if (!ucsi)
 		return ERR_PTR(-ENOMEM);
 
+	INIT_WORK(&ucsi->resume_work, ucsi_resume_work);
 	INIT_DELAYED_WORK(&ucsi->work, ucsi_init_work);
 	mutex_init(&ucsi->ppm_lock);
 	ucsi->dev = dev;
@@ -1401,6 +1409,7 @@ void ucsi_unregister(struct ucsi *ucsi)
 
 	/* Make sure that we are not in the middle of driver initialization */
 	cancel_delayed_work_sync(&ucsi->work);
+	cancel_work_sync(&ucsi->resume_work);
 
 	/* Disable notifications */
 	ucsi->ops->async_write(ucsi, UCSI_CONTROL, &cmd, sizeof(cmd));
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -287,6 +287,7 @@ struct ucsi {
 	struct ucsi_capability cap;
 	struct ucsi_connector *connector;
 
+	struct work_struct resume_work;
 	struct delayed_work work;
 	int work_count;
 #define UCSI_ROLE_SWITCH_RETRY_PER_HZ	10


