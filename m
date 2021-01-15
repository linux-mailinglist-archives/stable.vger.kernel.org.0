Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6872F7A43
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732960AbhAOMhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732879AbhAOMhU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E1CC238A1;
        Fri, 15 Jan 2021 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714224;
        bh=72jUBnKdL+MYlKj0cUL7zm+He19hTUwzr+bVFleU6oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6xQ2p5+pR3NfWnDDH+UnO39hyXTlGJe7yPLG8sn8sAiPlF4NMzNoCQmL0dCa4rF0
         3G8HHsrX48kEMnmG0PxVxwxS+km6JLXCJrswINGYsz4FX68Fa/XFwmAG+FwQFAmWAW
         KSivOaGT29vF0U1tWGrtKBxxhgLl5u4g2GWhez6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 040/103] s390/qeth: fix deadlock during recovery
Date:   Fri, 15 Jan 2021 13:27:33 +0100
Message-Id: <20210115122007.997109009@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 0b9902c1fcc59ba75268386c0420a554f8844168 ]

When qeth_dev_layer2_store() - holding the discipline_mutex - waits
inside qeth_l*_remove_device() for a qeth_do_reset() thread to complete,
we can hit a deadlock if qeth_do_reset() concurrently calls
qeth_set_online() and thus tries to aquire the discipline_mutex.

Move the discipline_mutex locking outside of qeth_set_online() and
qeth_set_offline(), and turn the discipline into a parameter so that
callers understand the dependency.

To fix the deadlock, we can now relax the locking:
As already established, qeth_l*_remove_device() waits for
qeth_do_reset() to complete. So qeth_do_reset() itself is under no risk
of having card->discipline ripped out while it's running, and thus
doesn't need to take the discipline_mutex.

Fixes: 9dc48ccc68b9 ("qeth: serialize sysfs-triggered device configurations")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core.h      |    3 ++-
 drivers/s390/net/qeth_core_main.c |   35 ++++++++++++++++++++++-------------
 drivers/s390/net/qeth_l2_main.c   |    7 +++++--
 drivers/s390/net/qeth_l3_main.c   |    7 +++++--
 4 files changed, 34 insertions(+), 18 deletions(-)

--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1075,7 +1075,8 @@ struct qeth_card *qeth_get_card_by_busid
 void qeth_set_allowed_threads(struct qeth_card *card, unsigned long threads,
 			      int clear_start_mask);
 int qeth_threads_running(struct qeth_card *, unsigned long);
-int qeth_set_offline(struct qeth_card *card, bool resetting);
+int qeth_set_offline(struct qeth_card *card, const struct qeth_discipline *disc,
+		     bool resetting);
 
 int qeth_send_ipa_cmd(struct qeth_card *, struct qeth_cmd_buffer *,
 		  int (*reply_cb)
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5300,12 +5300,12 @@ out:
 	return rc;
 }
 
-static int qeth_set_online(struct qeth_card *card)
+static int qeth_set_online(struct qeth_card *card,
+			   const struct qeth_discipline *disc)
 {
 	bool carrier_ok;
 	int rc;
 
-	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
 	QETH_CARD_TEXT(card, 2, "setonlin");
 
@@ -5322,7 +5322,7 @@ static int qeth_set_online(struct qeth_c
 		/* no need for locking / error handling at this early stage: */
 		qeth_set_real_num_tx_queues(card, qeth_tx_actual_queues(card));
 
-	rc = card->discipline->set_online(card, carrier_ok);
+	rc = disc->set_online(card, carrier_ok);
 	if (rc)
 		goto err_online;
 
@@ -5330,7 +5330,6 @@ static int qeth_set_online(struct qeth_c
 	kobject_uevent(&card->gdev->dev.kobj, KOBJ_CHANGE);
 
 	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return 0;
 
 err_online:
@@ -5345,15 +5344,14 @@ err_hardsetup:
 	qdio_free(CARD_DDEV(card));
 
 	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return rc;
 }
 
-int qeth_set_offline(struct qeth_card *card, bool resetting)
+int qeth_set_offline(struct qeth_card *card, const struct qeth_discipline *disc,
+		     bool resetting)
 {
 	int rc, rc2, rc3;
 
-	mutex_lock(&card->discipline_mutex);
 	mutex_lock(&card->conf_mutex);
 	QETH_CARD_TEXT(card, 3, "setoffl");
 
@@ -5374,7 +5372,7 @@ int qeth_set_offline(struct qeth_card *c
 
 	cancel_work_sync(&card->rx_mode_work);
 
-	card->discipline->set_offline(card);
+	disc->set_offline(card);
 
 	qeth_qdio_clear_card(card, 0);
 	qeth_drain_output_queues(card);
@@ -5395,16 +5393,19 @@ int qeth_set_offline(struct qeth_card *c
 	kobject_uevent(&card->gdev->dev.kobj, KOBJ_CHANGE);
 
 	mutex_unlock(&card->conf_mutex);
-	mutex_unlock(&card->discipline_mutex);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_set_offline);
 
 static int qeth_do_reset(void *data)
 {
+	const struct qeth_discipline *disc;
 	struct qeth_card *card = data;
 	int rc;
 
+	/* Lock-free, other users will block until we are done. */
+	disc = card->discipline;
+
 	QETH_CARD_TEXT(card, 2, "recover1");
 	if (!qeth_do_run_thread(card, QETH_RECOVER_THREAD))
 		return 0;
@@ -5412,8 +5413,8 @@ static int qeth_do_reset(void *data)
 	dev_warn(&card->gdev->dev,
 		 "A recovery process has been started for the device\n");
 
-	qeth_set_offline(card, true);
-	rc = qeth_set_online(card);
+	qeth_set_offline(card, disc, true);
+	rc = qeth_set_online(card, disc);
 	if (!rc) {
 		dev_info(&card->gdev->dev,
 			 "Device successfully recovered!\n");
@@ -6423,7 +6424,10 @@ static int qeth_core_set_online(struct c
 		}
 	}
 
-	rc = qeth_set_online(card);
+	mutex_lock(&card->discipline_mutex);
+	rc = qeth_set_online(card, card->discipline);
+	mutex_unlock(&card->discipline_mutex);
+
 err:
 	return rc;
 }
@@ -6431,8 +6435,13 @@ err:
 static int qeth_core_set_offline(struct ccwgroup_device *gdev)
 {
 	struct qeth_card *card = dev_get_drvdata(&gdev->dev);
+	int rc;
 
-	return qeth_set_offline(card, false);
+	mutex_lock(&card->discipline_mutex);
+	rc = qeth_set_offline(card, card->discipline, false);
+	mutex_unlock(&card->discipline_mutex);
+
+	return rc;
 }
 
 static void qeth_core_shutdown(struct ccwgroup_device *gdev)
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2207,8 +2207,11 @@ static void qeth_l2_remove_device(struct
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (gdev->state == CCWGROUP_ONLINE)
-		qeth_set_offline(card, false);
+	if (gdev->state == CCWGROUP_ONLINE) {
+		mutex_lock(&card->discipline_mutex);
+		qeth_set_offline(card, card->discipline, false);
+		mutex_unlock(&card->discipline_mutex);
+	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1973,8 +1973,11 @@ static void qeth_l3_remove_device(struct
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (cgdev->state == CCWGROUP_ONLINE)
-		qeth_set_offline(card, false);
+	if (cgdev->state == CCWGROUP_ONLINE) {
+		mutex_lock(&card->discipline_mutex);
+		qeth_set_offline(card, card->discipline, false);
+		mutex_unlock(&card->discipline_mutex);
+	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)


