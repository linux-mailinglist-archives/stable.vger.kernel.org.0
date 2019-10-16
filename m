Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE8D9FF4
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392513AbfJPWGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:06:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438188AbfJPV6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:58:34 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6318D21925;
        Wed, 16 Oct 2019 21:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263113;
        bh=DnX9JcJUzaW9xf1hlMgjIBDo4bmZg7W4Nni/YxvAVvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0BCdVj99JMRVrDxfV3wVaP67gEpOEc24DfkC8DkE2ne1CPRTHLrkkteJMyOTrSxMC
         JuGCOwenXwufBQHugHK0+ioiLMDhisz/MbVSL0Z3ug729ry3bIAaccREbcH64alIJo
         RHHOD8ok9yf3dTamt6oSaWNsKYFCtP106g9MSW+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.3 037/112] usb: typec: ucsi: ccg: Remove run_isr flag
Date:   Wed, 16 Oct 2019 14:50:29 -0700
Message-Id: <20191016214853.978001035@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit 8530e4e20ec2355c273f4dba9002969e68275e5f upstream.

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
Link: https://lore.kernel.org/r/20191004100219.71152-2-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/typec/ucsi/ucsi_ccg.c |   42 +++-----------------------------------
 1 file changed, 4 insertions(+), 38 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -195,7 +195,6 @@ struct ucsi_ccg {
 
 	/* fw build with vendor information */
 	u16 fw_build;
-	bool run_isr; /* flag to call ISR routine during resume */
 	struct work_struct pm_work;
 };
 
@@ -224,18 +223,6 @@ static int ccg_read(struct ucsi_ccg *uc,
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
@@ -278,18 +265,6 @@ static int ccg_write(struct ucsi_ccg *uc
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
@@ -1133,7 +1108,6 @@ static int ucsi_ccg_probe(struct i2c_cli
 	uc->ppm.sync = ucsi_ccg_sync;
 	uc->dev = dev;
 	uc->client = client;
-	uc->run_isr = true;
 	mutex_init(&uc->lock);
 	INIT_WORK(&uc->work, ccg_update_firmware);
 	INIT_WORK(&uc->pm_work, ccg_pm_workaround_work);
@@ -1195,6 +1169,8 @@ static int ucsi_ccg_probe(struct i2c_cli
 
 	pm_runtime_set_active(uc->dev);
 	pm_runtime_enable(uc->dev);
+	pm_runtime_use_autosuspend(uc->dev);
+	pm_runtime_set_autosuspend_delay(uc->dev, 5000);
 	pm_runtime_idle(uc->dev);
 
 	return 0;
@@ -1237,7 +1213,6 @@ static int ucsi_ccg_runtime_resume(struc
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct ucsi_ccg *uc = i2c_get_clientdata(client);
-	bool schedule = true;
 
 	/*
 	 * Firmware version 3.1.10 or earlier, built for NVIDIA has known issue
@@ -1245,17 +1220,8 @@ static int ucsi_ccg_runtime_resume(struc
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


