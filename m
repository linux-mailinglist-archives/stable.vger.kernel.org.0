Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182372F7A1A
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387407AbhAOMht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732742AbhAOMhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D34B2333E;
        Fri, 15 Jan 2021 12:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714226;
        bh=Z5gmgD1+kH2CxThF3Zvj/1SwPnxkUKRFMkSMu/H1pok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RMWxzuDyRoxbLvuGLUDHKXgt9OOHQQL29saW4i5cZFPfUj9luHfO3ZzaXQRgB4rtL
         G0Cs48YzGjqoDLROmohWETAK1/oNz3elkdR21WQn1x/k6yZh/Z6ijob/syvS6CI/Q+
         bWfA40JJdoklHb6a4VUYUYEi3xykl6u98ohMZMEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 041/103] s390/qeth: fix locking for discipline setup / removal
Date:   Fri, 15 Jan 2021 13:27:34 +0100
Message-Id: <20210115122008.044338888@linuxfoundation.org>
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

[ Upstream commit b41b554c1ee75070a14c02a88496b1f231c7eacc ]

Due to insufficient locking, qeth_core_set_online() and
qeth_dev_layer2_store() can run in parallel, both attempting to load &
setup the discipline (and stepping on each other toes along the way).
A similar race can also occur between qeth_core_remove_device() and
qeth_dev_layer2_store().

Access to .discipline is meant to be protected by the discipline_mutex,
so add/expand the locking in qeth_core_remove_device() and
qeth_core_set_online().
Adjust the locking in qeth_l*_remove_device() accordingly, as it's now
handled by the callers in a consistent manner.

Based on an initial patch by Ursula Braun.

Fixes: 9dc48ccc68b9 ("qeth: serialize sysfs-triggered device configurations")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core_main.c |    7 +++++--
 drivers/s390/net/qeth_l2_main.c   |    5 +----
 drivers/s390/net/qeth_l3_main.c   |    5 +----
 3 files changed, 7 insertions(+), 10 deletions(-)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6361,6 +6361,7 @@ static int qeth_core_probe_device(struct
 		break;
 	default:
 		card->info.layer_enforced = true;
+		/* It's so early that we don't need the discipline_mutex yet. */
 		rc = qeth_core_load_discipline(card, enforced_disc);
 		if (rc)
 			goto err_load;
@@ -6393,10 +6394,12 @@ static void qeth_core_remove_device(stru
 
 	QETH_CARD_TEXT(card, 2, "removedv");
 
+	mutex_lock(&card->discipline_mutex);
 	if (card->discipline) {
 		card->discipline->remove(gdev);
 		qeth_core_free_discipline(card);
 	}
+	mutex_unlock(&card->discipline_mutex);
 
 	qeth_free_qdio_queues(card);
 
@@ -6411,6 +6414,7 @@ static int qeth_core_set_online(struct c
 	int rc = 0;
 	enum qeth_discipline_id def_discipline;
 
+	mutex_lock(&card->discipline_mutex);
 	if (!card->discipline) {
 		def_discipline = IS_IQD(card) ? QETH_DISCIPLINE_LAYER3 :
 						QETH_DISCIPLINE_LAYER2;
@@ -6424,11 +6428,10 @@ static int qeth_core_set_online(struct c
 		}
 	}
 
-	mutex_lock(&card->discipline_mutex);
 	rc = qeth_set_online(card, card->discipline);
-	mutex_unlock(&card->discipline_mutex);
 
 err:
+	mutex_unlock(&card->discipline_mutex);
 	return rc;
 }
 
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2207,11 +2207,8 @@ static void qeth_l2_remove_device(struct
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (gdev->state == CCWGROUP_ONLINE) {
-		mutex_lock(&card->discipline_mutex);
+	if (gdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
-		mutex_unlock(&card->discipline_mutex);
-	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1973,11 +1973,8 @@ static void qeth_l3_remove_device(struct
 	qeth_set_allowed_threads(card, 0, 1);
 	wait_event(card->wait_q, qeth_threads_running(card, 0xffffffff) == 0);
 
-	if (cgdev->state == CCWGROUP_ONLINE) {
-		mutex_lock(&card->discipline_mutex);
+	if (cgdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
-		mutex_unlock(&card->discipline_mutex);
-	}
 
 	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)


