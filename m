Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAA013FFD6
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390760AbgAPXVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:21:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:47964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390752AbgAPXVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:21:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9C4D2077C;
        Thu, 16 Jan 2020 23:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216860;
        bh=hBl88ClmNQ5MuN49kdNckYKs40bu//qCToIj1UiJmX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O6UNCH0i1eZeCGBVL9xZC83gdiLZl4/979mKJMgfZh8/3ulu52bIm9KKQtaFxL/X/
         xcAiOsN3iPPxp6mh8B2enn4MA/H7eJ3g5leOJxBGyKbSDwVAjDMVN575KkHYUizClj
         F8b9TP5Zici+/ACdOw/E8LsJnPzQFLSqb8d+Uuss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 033/203] s390/qeth: fix qdio teardown after early init error
Date:   Fri, 17 Jan 2020 00:15:50 +0100
Message-Id: <20200116231747.112519253@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

commit 8b5026bc16938920e4780b9094c3bf20e1e0939d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/net/qeth_core_main.c |   20 ++++++++------------
 drivers/s390/net/qeth_l2_main.c   |    2 +-
 drivers/s390/net/qeth_l3_main.c   |    2 +-
 3 files changed, 10 insertions(+), 14 deletions(-)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -2451,50 +2451,46 @@ static int qeth_mpc_initialize(struct qe
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
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -287,12 +287,12 @@ static void qeth_l2_stop_card(struct qet
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
 	card->info.promisc_mode = 0;
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1426,12 +1426,12 @@ static void qeth_l3_stop_card(struct qet
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
 	card->info.promisc_mode = 0;
 }


