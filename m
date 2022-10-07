Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12C85F76A5
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 12:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiJGKJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 06:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbiJGKJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 06:09:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68F210C;
        Fri,  7 Oct 2022 03:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665137379; x=1696673379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=P2FTsfoztbK2OJ6j/FNEIkCo3aLOW1Gmx3qTuQg5T5Q=;
  b=Qj5Co4ejHrS1rv1RnqW/Mlyf+d8zRjaTydFkQI7qD+894u6owEy2B8tK
   aD87GZcldOP9W00MW52J2l8iO4f4mTr1QnGX/nZi9+VBx7g8IO6uzOjMm
   TbuUYkvMiKMSqLZcLiRuJASK+uyvfdRVC0BQ/V5FAQm/HdAw1l4gHls2A
   jWKEoIgZkUwD4GfdjE0Cyt/OijnmGicBSLGCZYlNeoiHi9ZkdLSHj012n
   Q3UZ9HwSvvqzcsyzFM+oSzb4C5+g3DXyzRnlnscArFMj9Bf3dB8N4ICoF
   FOXANreDor3Pi90q3OttAckEoY4KZYVZL956tn51QxV5F5N34nhCt5KNw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="330140300"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="330140300"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2022 03:09:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="767530640"
X-IronPort-AV: E=Sophos;i="5.95,166,1661842800"; 
   d="scan'208";a="767530640"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2022 03:09:35 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bastian Rieck <bastian@rieck.me>, grzegorz.alibozek@gmail.com,
        andrew.co@free.fr, meven29@gmail.com, pchernik@gmail.com,
        jorge.cep.mart@gmail.com, danielmorgan@disroot.org,
        bernie@codewiz.org, saipavanchitta1998@gmail.com,
        rubin@starset.net, maniette@gmail.com, nate@kde.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v1 1/2] usb: typec: ucsi: Check the connection on resume
Date:   Fri,  7 Oct 2022 13:09:50 +0300
Message-Id: <20221007100951.43798-2-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221007100951.43798-1-heikki.krogerus@linux.intel.com>
References: <20221007100951.43798-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Checking the connection status of every port on resume. This
fixes an issue where the partner device is not unregistered
properly after resume if it was unplugged while the system
was suspended.

The function ucsi_check_connection() is also modified so
that it can be used also for registering the connection on
top of unregistering it.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=210425
Fixes: a94ecde41f7e ("usb: typec: ucsi: ccg: enable runtime pm support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi.c | 42 ++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 74fb5a4c6f21b..a7987fc764cc6 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -183,16 +183,6 @@ int ucsi_send_command(struct ucsi *ucsi, u64 command,
 }
 EXPORT_SYMBOL_GPL(ucsi_send_command);
 
-int ucsi_resume(struct ucsi *ucsi)
-{
-	u64 command;
-
-	/* Restore UCSI notification enable mask after system resume */
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
-
-	return ucsi_send_command(ucsi, command, NULL, 0);
-}
-EXPORT_SYMBOL_GPL(ucsi_resume);
 /* -------------------------------------------------------------------------- */
 
 struct ucsi_work {
@@ -744,6 +734,7 @@ static void ucsi_partner_change(struct ucsi_connector *con)
 
 static int ucsi_check_connection(struct ucsi_connector *con)
 {
+	u8 prev_flags = con->status.flags;
 	u64 command;
 	int ret;
 
@@ -754,10 +745,13 @@ static int ucsi_check_connection(struct ucsi_connector *con)
 		return ret;
 	}
 
+	if (con->status.flags == prev_flags)
+		return 0;
+
 	if (con->status.flags & UCSI_CONSTAT_CONNECTED) {
-		if (UCSI_CONSTAT_PWR_OPMODE(con->status.flags) ==
-		    UCSI_CONSTAT_PWR_OPMODE_PD)
-			ucsi_partner_task(con, ucsi_check_altmodes, 30, 0);
+		ucsi_register_partner(con);
+		ucsi_pwr_opmode_change(con);
+		ucsi_partner_change(con);
 	} else {
 		ucsi_partner_change(con);
 		ucsi_port_psy_changed(con);
@@ -1276,6 +1270,28 @@ static int ucsi_init(struct ucsi *ucsi)
 	return ret;
 }
 
+int ucsi_resume(struct ucsi *ucsi)
+{
+	struct ucsi_connector *con;
+	u64 command;
+	int ret;
+
+	/* Restore UCSI notification enable mask after system resume */
+	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ret = ucsi_send_command(ucsi, command, NULL, 0);
+	if (ret < 0)
+		return ret;
+
+	for (con = ucsi->connector; con->port; con++) {
+		mutex_lock(&con->lock);
+		ucsi_check_connection(con);
+		mutex_unlock(&con->lock);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ucsi_resume);
+
 static void ucsi_init_work(struct work_struct *work)
 {
 	struct ucsi *ucsi = container_of(work, struct ucsi, work.work);
-- 
2.35.1

