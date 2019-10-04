Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97141CB7CD
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 12:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730769AbfJDKCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 06:02:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:15524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbfJDKCY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 06:02:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 03:02:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,256,1566889200"; 
   d="scan'208";a="205821754"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 04 Oct 2019 03:02:21 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ajay Gupta <ajayg@nvidia.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] usb: typec: ucsi: ccg: Remove run_isr flag
Date:   Fri,  4 Oct 2019 13:02:18 +0300
Message-Id: <20191004100219.71152-2-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191004100219.71152-1-heikki.krogerus@linux.intel.com>
References: <20191004100219.71152-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "run_isr" flag is used for preventing the driver from
calling the interrupt service routine in its runtime resume
callback when the driver is expecting completion to a
command, but what that basically does is that it hides the
real problem. The real problem is that the controller is
allowed to suspend in the middle of command execution.

As a more appropriate fix for the problem, using autosuspend
delay time that matches UCSI_TIMEOUT_MS (5s). That prevents
the controller from suspending while still in the middle of
executing a command.

This fixes a potential deadlock. Both ccg_read() and
ccg_write() are called with the mutex already taken at least
from ccg_send_command(). In ccg_read() and ccg_write, the
mutex is only acquired so that run_isr flag can be set.

Fixes: f0e4cd948b91 ("usb: typec: ucsi: ccg: add runtime pm workaround")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 42 +++----------------------------
 1 file changed, 4 insertions(+), 38 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index 907e20e1a71e..d772fce51905 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -195,7 +195,6 @@ struct ucsi_ccg {
 
 	/* fw build with vendor information */
 	u16 fw_build;
-	bool run_isr; /* flag to call ISR routine during resume */
 	struct work_struct pm_work;
 };
 
@@ -224,18 +223,6 @@ static int ccg_read(struct ucsi_ccg *uc, u16 rab, u8 *data, u32 len)
 	if (quirks && quirks->max_read_len)
 		max_read_len = quirks->max_read_len;
 
-	if (uc->fw_build == CCG_FW_BUILD_NVIDIA &&
-	    uc->fw_version <= CCG_OLD_FW_VERSION) {
-		mutex_lock(&uc->lock);
-		/*
-		 * Do not schedule pm_work to run ISR in
-		 * ucsi_ccg_runtime_resume() after pm_runtime_get_sync()
-		 * since we are already in ISR path.
-		 */
-		uc->run_isr = false;
-		mutex_unlock(&uc->lock);
-	}
-
 	pm_runtime_get_sync(uc->dev);
 	while (rem_len > 0) {
 		msgs[1].buf = &data[len - rem_len];
@@ -278,18 +265,6 @@ static int ccg_write(struct ucsi_ccg *uc, u16 rab, u8 *data, u32 len)
 	msgs[0].len = len + sizeof(rab);
 	msgs[0].buf = buf;
 
-	if (uc->fw_build == CCG_FW_BUILD_NVIDIA &&
-	    uc->fw_version <= CCG_OLD_FW_VERSION) {
-		mutex_lock(&uc->lock);
-		/*
-		 * Do not schedule pm_work to run ISR in
-		 * ucsi_ccg_runtime_resume() after pm_runtime_get_sync()
-		 * since we are already in ISR path.
-		 */
-		uc->run_isr = false;
-		mutex_unlock(&uc->lock);
-	}
-
 	pm_runtime_get_sync(uc->dev);
 	status = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
 	if (status < 0) {
@@ -1130,7 +1105,6 @@ static int ucsi_ccg_probe(struct i2c_client *client,
 	uc->ppm.sync = ucsi_ccg_sync;
 	uc->dev = dev;
 	uc->client = client;
-	uc->run_isr = true;
 	mutex_init(&uc->lock);
 	INIT_WORK(&uc->work, ccg_update_firmware);
 	INIT_WORK(&uc->pm_work, ccg_pm_workaround_work);
@@ -1188,6 +1162,8 @@ static int ucsi_ccg_probe(struct i2c_client *client,
 
 	pm_runtime_set_active(uc->dev);
 	pm_runtime_enable(uc->dev);
+	pm_runtime_use_autosuspend(uc->dev);
+	pm_runtime_set_autosuspend_delay(uc->dev, 5000);
 	pm_runtime_idle(uc->dev);
 
 	return 0;
@@ -1229,7 +1205,6 @@ static int ucsi_ccg_runtime_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct ucsi_ccg *uc = i2c_get_clientdata(client);
-	bool schedule = true;
 
 	/*
 	 * Firmware version 3.1.10 or earlier, built for NVIDIA has known issue
@@ -1237,17 +1212,8 @@ static int ucsi_ccg_runtime_resume(struct device *dev)
 	 * Schedule a work to call ISR as a workaround.
 	 */
 	if (uc->fw_build == CCG_FW_BUILD_NVIDIA &&
-	    uc->fw_version <= CCG_OLD_FW_VERSION) {
-		mutex_lock(&uc->lock);
-		if (!uc->run_isr) {
-			uc->run_isr = true;
-			schedule = false;
-		}
-		mutex_unlock(&uc->lock);
-
-		if (schedule)
-			schedule_work(&uc->pm_work);
-	}
+	    uc->fw_version <= CCG_OLD_FW_VERSION)
+		schedule_work(&uc->pm_work);
 
 	return 0;
 }
-- 
2.23.0

