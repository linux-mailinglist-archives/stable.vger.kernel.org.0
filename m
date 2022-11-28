Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B08E63B0ED
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 19:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiK1SRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 13:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbiK1SQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 13:16:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5BB2D741
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 10:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75B1BB80E81
        for <stable@vger.kernel.org>; Mon, 28 Nov 2022 18:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C926BC433C1;
        Mon, 28 Nov 2022 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669658412;
        bh=gD1947AJxRiNvYI66VFSOWn7FMyu4m7ws+flzZv6ILY=;
        h=Subject:To:From:Date:From;
        b=nzw+GfoN6MUCWZ5Rj+B25Y7v0lcqM9D2Md2tSie6epE21QGvSMXJf+K31vp8tYAEz
         puboqBMgkB9N18ij+hPY6gOFSpN0WxwLFt8sIxr3Vhz2IEAWeS6dbmlppZj+5fLoBS
         soJnrgMiPnNjQ5jL04WUXG1ltoDroIBmg9+W+Vzo=
Subject: patch "usb: typec: ucsi: Resume in separate work" added to usb-testing
To:     heikki.krogerus@linux.intel.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, todd.e.brandt@intel.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Nov 2022 18:59:57 +0100
Message-ID: <1669658397152196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: typec: ucsi: Resume in separate work

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 80db2b06e4881e2ff1052d6b9d4982f2cab287bd Mon Sep 17 00:00:00 2001
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Date: Wed, 23 Nov 2022 11:30:21 +0200
Subject: usb: typec: ucsi: Resume in separate work

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
 drivers/usb/typec/ucsi/ucsi.c | 17 +++++++++++++----
 drivers/usb/typec/ucsi/ucsi.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index a7987fc764cc..eabe519013e7 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1270,8 +1270,9 @@ static int ucsi_init(struct ucsi *ucsi)
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
@@ -1347,6 +1354,7 @@ struct ucsi *ucsi_create(struct device *dev, const struct ucsi_operations *ops)
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
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 8eb391e3e592..c968474ee547 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -287,6 +287,7 @@ struct ucsi {
 	struct ucsi_capability cap;
 	struct ucsi_connector *connector;
 
+	struct work_struct resume_work;
 	struct delayed_work work;
 	int work_count;
 #define UCSI_ROLE_SWITCH_RETRY_PER_HZ	10
-- 
2.38.1


