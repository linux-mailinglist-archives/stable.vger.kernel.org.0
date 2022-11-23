Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44A56355AC
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237624AbiKWJX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237601AbiKWJXY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:23:24 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6CE410EA0E;
        Wed, 23 Nov 2022 01:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669195343; x=1700731343;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XNUC41sj9TAoUktgPlv113YVQY4kW0T4VrpDBMKfCPo=;
  b=hW7m6ngchhbDOQEbD2HO1oQSgges5lx997cAe4iSmHoVsqENLug4MmnX
   QiBATfXwYy6AOczizuzMFknzlpGFp0zy6g55CgvWLZteQp9tWTqm8JLrr
   dZDzCAvCH8Xhakq7f421W6CwO7AXiCBdFTpkuAyzLlDPHSFXis1BrU1wo
   DgIiKp3pfZCbHiH9LA51b7Jd0j0NVcDto/6ArKZdJdY2CV82a+1oxMgy2
   r5C83YF1pI1IkfqqKsImE9p6HMDfu04a3sGRMSs4WYwrcA8vWbzhhxQoP
   pdJoU10SkiyDDKnwd0MOeK95ZC3skbYIEEaPw8T8E6CYmKADyNM5Pb0er
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="311652596"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="311652596"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 01:22:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="784171557"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="784171557"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 23 Nov 2022 01:22:20 -0800
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, Todd Brandt <todd.e.brandt@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: typec: ucsi: Resume in separate work
Date:   Wed, 23 Nov 2022 11:22:46 +0200
Message-Id: <20221123092246.22007-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It can take more than one second to check each connector
when the system is resumed. So if you have, say, eight
connectors, it may take eight seconds for ucsi_resume() to
finish. That's a bit too much.

This will modify ucsi_resume() so that it schedules a work
where the interface is actually resumed instead of checking
the connectors directly. The connections will also be
checked in separate tasks which are queued for each connector
separately.

Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Fixes: f9f019f7d849 ("usb: typec: ucsi: Resume in separate work")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216706
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 17 +++++++++++++----
 drivers/usb/typec/ucsi/ucsi.h |  1 +
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index a7987fc764cc6..eabe519013e78 100644
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
index 8eb391e3e592c..c968474ee5473 100644
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
2.35.1

