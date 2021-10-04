Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DAC420EFB
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbhJDN34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237305AbhJDN2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE41630EB;
        Mon,  4 Oct 2021 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353151;
        bh=R7QmoX3UQsBmiAj5F9JmxpW4UeUK+tcNYPc35PrQL+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cg4Jv28CcMpMbou/1LGUGrgPfGpkNIW3QqU97GJIpg4ZShFKaJe0I8BoDkKHjUmjB
         yPFhz/j/1xbVnpBbQBzu9mXxdxiV4j1wBH4ZfoQdoXk4oWF6A8v33BHK2CZDLRs95N
         06ve2WFAQFpZxWkqWHPybzZicbkM4+kaVVLDzDHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 016/172] s390/qeth: Fix deadlock in remove_discipline
Date:   Mon,  4 Oct 2021 14:51:06 +0200
Message-Id: <20211004125045.492226759@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit ee909d0b1dac8632eeb78cbf17661d6c7674bbd0 ]

Problem: qeth_close_dev_handler is a worker that tries to acquire
card->discipline_mutex via drv->set_offline() in ccwgroup_set_offline().
Since commit b41b554c1ee7
("s390/qeth: fix locking for discipline setup / removal")
qeth_remove_discipline() is called under card->discipline_mutex and
cancels the work and waits for it to finish.

STOPLAN reception with reason code IPA_RC_VEPA_TO_VEB_TRANSITION is the
only situation that schedules close_dev_work. In that situation scheduling
qeth recovery will also result in an offline interface, when resetting the
isolation mode fails, if the external switch is still set to VEB.
And since commit 0b9902c1fcc5 ("s390/qeth: fix deadlock during recovery")
qeth recovery does not aquire card->discipline_mutex anymore.

So we accept the longer pathlength of qeth_schedule_recovery in this
error situation and re-use the existing function.

As a side-benefit this changes the hwtrap to behave like during recovery
instead of like during a user-triggered set_offline.

Fixes: b41b554c1ee7 ("s390/qeth: fix locking for discipline setup / removal")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core.h      |  1 -
 drivers/s390/net/qeth_core_main.c | 16 ++++------------
 drivers/s390/net/qeth_l2_main.c   |  1 -
 drivers/s390/net/qeth_l3_main.c   |  1 -
 4 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index f4d554ea0c93..52bdb2c8c085 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -877,7 +877,6 @@ struct qeth_card {
 	struct napi_struct napi;
 	struct qeth_rx rx;
 	struct delayed_work buffer_reclaim_work;
-	struct work_struct close_dev_work;
 };
 
 static inline bool qeth_card_hw_is_reachable(struct qeth_card *card)
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 51f7f4e680c3..dba3b345218f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -71,15 +71,6 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 static int qeth_qdio_establish(struct qeth_card *);
 static void qeth_free_qdio_queues(struct qeth_card *card);
 
-static void qeth_close_dev_handler(struct work_struct *work)
-{
-	struct qeth_card *card;
-
-	card = container_of(work, struct qeth_card, close_dev_work);
-	QETH_CARD_TEXT(card, 2, "cldevhdl");
-	ccwgroup_set_offline(card->gdev);
-}
-
 static const char *qeth_get_cardname(struct qeth_card *card)
 {
 	if (IS_VM_NIC(card)) {
@@ -797,10 +788,12 @@ static struct qeth_ipa_cmd *qeth_check_ipa_data(struct qeth_card *card,
 	case IPA_CMD_STOPLAN:
 		if (cmd->hdr.return_code == IPA_RC_VEPA_TO_VEB_TRANSITION) {
 			dev_err(&card->gdev->dev,
-				"Interface %s is down because the adjacent port is no longer in reflective relay mode\n",
+				"Adjacent port of interface %s is no longer in reflective relay mode, trigger recovery\n",
 				netdev_name(card->dev));
-			schedule_work(&card->close_dev_work);
+			/* Set offline, then probably fail to set online: */
+			qeth_schedule_recovery(card);
 		} else {
+			/* stay online for subsequent STARTLAN */
 			dev_warn(&card->gdev->dev,
 				 "The link for interface %s on CHPID 0x%X failed\n",
 				 netdev_name(card->dev), card->info.chpid);
@@ -1559,7 +1552,6 @@ static void qeth_setup_card(struct qeth_card *card)
 	INIT_LIST_HEAD(&card->ipato.entries);
 	qeth_init_qdio_info(card);
 	INIT_DELAYED_WORK(&card->buffer_reclaim_work, qeth_buffer_reclaim_work);
-	INIT_WORK(&card->close_dev_work, qeth_close_dev_handler);
 	hash_init(card->rx_mode_addrs);
 	hash_init(card->local_addrs4);
 	hash_init(card->local_addrs6);
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index d7cdd9cfe485..3dbe592ca97a 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2218,7 +2218,6 @@ static void qeth_l2_remove_device(struct ccwgroup_device *gdev)
 	if (gdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
 
-	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(card->dev);
 }
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index f0d6f205c53c..5ba38499e3e2 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1965,7 +1965,6 @@ static void qeth_l3_remove_device(struct ccwgroup_device *cgdev)
 	if (cgdev->state == CCWGROUP_ONLINE)
 		qeth_set_offline(card, card->discipline, false);
 
-	cancel_work_sync(&card->close_dev_work);
 	if (card->dev->reg_state == NETREG_REGISTERED)
 		unregister_netdev(card->dev);
 
-- 
2.33.0



