Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B35F2EBFB
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbfE3DRR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:17:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbfE3DRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:17:16 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 483CE24697;
        Thu, 30 May 2019 03:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186235;
        bh=usSd065J3MbuKsQuMpQnSgM3+CXM1dMSOdCHQzXuOYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F5eIoi+AOHEyHpXiwFf8QXzMBYODtxhcDQzHIGqDk+hrAeAVP8DDD03or1/sKXa5B
         5uizzpXLZYlg22PI0xZEx7z5tJWJdOJ2QpMfDYCErMENZOxltupbdQOe5xXQyf5PvG
         Qz1wcj/FUCjGJ4pFFzvDbaQBbCX2XuN5F8j70MG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/276] s390/qeth: handle error from qeth_update_from_chp_desc()
Date:   Wed, 29 May 2019 20:05:01 -0700
Message-Id: <20190530030534.607420342@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a4cdc9baee0740748f16e50cd70c2607510df492 ]

Subsequent code relies on the values that qeth_update_from_chp_desc()
reads from the CHP descriptor. Rather than dealing with weird errors
later on, just handle it properly here.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 56aacf32f71b0..461afc276db72 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1370,7 +1370,7 @@ static void qeth_set_multiple_write_queues(struct qeth_card *card)
 	card->qdio.no_out_queues = 4;
 }
 
-static void qeth_update_from_chp_desc(struct qeth_card *card)
+static int qeth_update_from_chp_desc(struct qeth_card *card)
 {
 	struct ccw_device *ccwdev;
 	struct channel_path_desc_fmt0 *chp_dsc;
@@ -1380,7 +1380,7 @@ static void qeth_update_from_chp_desc(struct qeth_card *card)
 	ccwdev = card->data.ccwdev;
 	chp_dsc = ccw_device_get_chp_desc(ccwdev, 0);
 	if (!chp_dsc)
-		goto out;
+		return -ENOMEM;
 
 	card->info.func_level = 0x4100 + chp_dsc->desc;
 	if (card->info.type == QETH_CARD_TYPE_IQD)
@@ -1395,6 +1395,7 @@ static void qeth_update_from_chp_desc(struct qeth_card *card)
 	kfree(chp_dsc);
 	QETH_DBF_TEXT_(SETUP, 2, "nr:%x", card->qdio.no_out_queues);
 	QETH_DBF_TEXT_(SETUP, 2, "lvl:%02x", card->info.func_level);
+	return 0;
 }
 
 static void qeth_init_qdio_info(struct qeth_card *card)
@@ -5090,7 +5091,9 @@ int qeth_core_hardsetup_card(struct qeth_card *card)
 
 	QETH_DBF_TEXT(SETUP, 2, "hrdsetup");
 	atomic_set(&card->force_alloc_skb, 0);
-	qeth_update_from_chp_desc(card);
+	rc = qeth_update_from_chp_desc(card);
+	if (rc)
+		return rc;
 retry:
 	if (retries < 3)
 		QETH_DBF_MESSAGE(2, "%s Retrying to do IDX activates.\n",
@@ -5768,7 +5771,9 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	gdev->cdev[2]->handler = qeth_irq;
 
 	qeth_setup_card(card);
-	qeth_update_from_chp_desc(card);
+	rc = qeth_update_from_chp_desc(card);
+	if (rc)
+		goto err_chp_desc;
 
 	card->dev = qeth_alloc_netdev(card);
 	if (!card->dev) {
@@ -5806,6 +5811,7 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	qeth_core_free_discipline(card);
 err_load:
 	free_netdev(card->dev);
+err_chp_desc:
 err_card:
 	qeth_core_free_card(card);
 err_dev:
-- 
2.20.1



