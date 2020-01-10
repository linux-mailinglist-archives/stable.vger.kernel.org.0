Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0322813797C
	for <lists+stable@lfdr.de>; Fri, 10 Jan 2020 23:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbgAJWF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jan 2020 17:05:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:51062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbgAJWF2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jan 2020 17:05:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29FC120838;
        Fri, 10 Jan 2020 22:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578693926;
        bh=nbv7wtm0VtoeeJdCMLEaKBD0blQxesMVDWvU107naZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4tlhSv+/TbeQqegWzBJgG7BIoWp13o/hTflBdROhawMTca+5QzOhqexV73ZPlfdm
         D5i61U2de6iWDrXzhdoj3sIt2mvQehLRsA2PVjqbqpxoDWK6RuWqdm5oftiGfF0L7Q
         0lNGwiLoSxUOkXGVqxPhW1+oV48v3kB9I5AfPLQM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 10/26] s390/qeth: fix qdio teardown after early init error
Date:   Fri, 10 Jan 2020 17:05:03 -0500
Message-Id: <20200110220519.28250-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200110220519.28250-1-sashal@kernel.org>
References: <20200110220519.28250-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 8b5026bc16938920e4780b9094c3bf20e1e0939d ]

qeth_l?_set_online() goes through a number of initialization steps, and
on any error uses qeth_l?_stop_card() to tear down the residual state.

The first initialization step is qeth_core_hardsetup_card(). When this
fails after having established a QDIO context on the device
(ie. somewhere after qeth_mpc_initialize()), qeth_l?_stop_card() doesn't
shut down this QDIO context again (since the card state hasn't
progressed from DOWN at this stage).

Even worse, we then call qdio_free() as final teardown step to free the
QDIO data structures - while some of them are still hooked into wider
QDIO infrastructure such as the IRQ list. This is inevitably followed by
use-after-frees and other nastyness.

Fix this by unconditionally calling qeth_qdio_clear_card() to shut down
the QDIO context, and also to halt/clear any pending activity on the
various IO channels.
Remove the naive attempt at handling the teardown in
qeth_mpc_initialize(), it clearly doesn't suffice and we're handling it
properly now in the wider teardown code.

Fixes: 4a71df50047f ("qeth: new qeth device driver")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 20 ++++++++------------
 drivers/s390/net/qeth_l2_main.c   |  2 +-
 drivers/s390/net/qeth_l3_main.c   |  2 +-
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 83794d7494d4..c444210d563b 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2451,50 +2451,46 @@ static int qeth_mpc_initialize(struct qeth_card *card)
 	rc = qeth_cm_enable(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "2err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_cm_setup(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "3err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_ulp_enable(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "4err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_ulp_setup(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_alloc_qdio_queues(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "5err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_qdio_establish(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "6err%d", rc);
 		qeth_free_qdio_queues(card);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_qdio_activate(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "7err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 	rc = qeth_dm_act(card);
 	if (rc) {
 		QETH_CARD_TEXT_(card, 2, "8err%d", rc);
-		goto out_qdio;
+		return rc;
 	}
 
 	return 0;
-out_qdio:
-	qeth_qdio_clear_card(card, !IS_IQD(card));
-	qdio_free(CARD_DDEV(card));
-	return rc;
 }
 
 void qeth_print_status_message(struct qeth_card *card)
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 4bccdce19b5a..4224a3b7cd07 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -287,12 +287,12 @@ static void qeth_l2_stop_card(struct qeth_card *card)
 		card->state = CARD_STATE_HARDSETUP;
 	}
 	if (card->state == CARD_STATE_HARDSETUP) {
-		qeth_qdio_clear_card(card, 0);
 		qeth_drain_output_queues(card);
 		qeth_clear_working_pool_list(card);
 		card->state = CARD_STATE_DOWN;
 	}
 
+	qeth_qdio_clear_card(card, 0);
 	flush_workqueue(card->event_wq);
 	card->info.mac_bits &= ~QETH_LAYER2_MAC_REGISTERED;
 }
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index d7bfc7a0e4c0..ae5300fef4e3 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1426,12 +1426,12 @@ static void qeth_l3_stop_card(struct qeth_card *card)
 		card->state = CARD_STATE_HARDSETUP;
 	}
 	if (card->state == CARD_STATE_HARDSETUP) {
-		qeth_qdio_clear_card(card, 0);
 		qeth_drain_output_queues(card);
 		qeth_clear_working_pool_list(card);
 		card->state = CARD_STATE_DOWN;
 	}
 
+	qeth_qdio_clear_card(card, 0);
 	flush_workqueue(card->event_wq);
 }
 
-- 
2.20.1

