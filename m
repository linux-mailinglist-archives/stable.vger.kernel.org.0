Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E19BA2EB39
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfE3DKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:49144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbfE3DKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87192244A6;
        Thu, 30 May 2019 03:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185852;
        bh=u8DTJcCxboMwaCpnCA+BRD1412Fvgn3zc28Z0ceiVQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P/tcl29THtS/FLl8aHnrcdtmqIkgUx26yxmT1UKU/3Mh1moWZcEyK7a0niGbWlXXM
         vjoGcGr1aXnhH3G6cziFYzvRNS01Nx7ywmNsfUfg1bycl9bhwUMnZ0KrneAoYcr/ch
         Xel03zGMtTvS9alw9HHcfPvmdPXIBeTKGmY11NdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 178/405] s390/qeth: handle error from qeth_update_from_chp_desc()
Date:   Wed, 29 May 2019 20:02:56 -0700
Message-Id: <20190530030550.098999881@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
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
index 44bd6f04c145d..8c73a99daff3e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1308,7 +1308,7 @@ static void qeth_set_multiple_write_queues(struct qeth_card *card)
 	card->qdio.no_out_queues = 4;
 }
 
-static void qeth_update_from_chp_desc(struct qeth_card *card)
+static int qeth_update_from_chp_desc(struct qeth_card *card)
 {
 	struct ccw_device *ccwdev;
 	struct channel_path_desc_fmt0 *chp_dsc;
@@ -1318,7 +1318,7 @@ static void qeth_update_from_chp_desc(struct qeth_card *card)
 	ccwdev = card->data.ccwdev;
 	chp_dsc = ccw_device_get_chp_desc(ccwdev, 0);
 	if (!chp_dsc)
-		goto out;
+		return -ENOMEM;
 
 	card->info.func_level = 0x4100 + chp_dsc->desc;
 	if (card->info.type == QETH_CARD_TYPE_IQD)
@@ -1333,6 +1333,7 @@ static void qeth_update_from_chp_desc(struct qeth_card *card)
 	kfree(chp_dsc);
 	QETH_DBF_TEXT_(SETUP, 2, "nr:%x", card->qdio.no_out_queues);
 	QETH_DBF_TEXT_(SETUP, 2, "lvl:%02x", card->info.func_level);
+	return 0;
 }
 
 static void qeth_init_qdio_info(struct qeth_card *card)
@@ -4986,7 +4987,9 @@ int qeth_core_hardsetup_card(struct qeth_card *card, bool *carrier_ok)
 
 	QETH_DBF_TEXT(SETUP, 2, "hrdsetup");
 	atomic_set(&card->force_alloc_skb, 0);
-	qeth_update_from_chp_desc(card);
+	rc = qeth_update_from_chp_desc(card);
+	if (rc)
+		return rc;
 retry:
 	if (retries < 3)
 		QETH_DBF_MESSAGE(2, "Retrying to do IDX activates on device %x.\n",
@@ -5641,7 +5644,9 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	}
 
 	qeth_setup_card(card);
-	qeth_update_from_chp_desc(card);
+	rc = qeth_update_from_chp_desc(card);
+	if (rc)
+		goto err_chp_desc;
 
 	card->dev = qeth_alloc_netdev(card);
 	if (!card->dev) {
@@ -5676,6 +5681,7 @@ static int qeth_core_probe_device(struct ccwgroup_device *gdev)
 	qeth_core_free_discipline(card);
 err_load:
 	free_netdev(card->dev);
+err_chp_desc:
 err_card:
 	qeth_core_free_card(card);
 err_dev:
-- 
2.20.1



