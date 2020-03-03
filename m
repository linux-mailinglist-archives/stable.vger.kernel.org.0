Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFDB176BF0
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgCCCtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:49:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbgCCCtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:49:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DAB8246D9;
        Tue,  3 Mar 2020 02:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203770;
        bh=tC+0mgyKlaDMK7CzaUFh/QCiLjvwuX5zo5jMipSCH+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uli42UocBv7U56sPIcjxz7JF/AaaTUZDPOumzyhgMdkDEm2P78V0+vJePC3Xz0w+D
         vwAh+chdZSenolL/RK+EASihmNl3jiaZk89N0L3GsuVHB0oHt9/WU6OyWiDbpy+aQS
         k7sIZsOQo5a55yi4pWkwy36lr4jp7jp6E+7gCsis=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 31/32] s390/qeth: vnicc Fix EOPNOTSUPP precedence
Date:   Mon,  2 Mar 2020 21:48:50 -0500
Message-Id: <20200303024851.10054-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024851.10054-1-sashal@kernel.org>
References: <20200303024851.10054-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandra Winter <wintera@linux.ibm.com>

[ Upstream commit 6f3846f0955308b6d1b219419da42b8de2c08845 ]

When getting or setting VNICC parameters, the error code EOPNOTSUPP
should have precedence over EBUSY.

EBUSY is used because vnicc feature and bridgeport feature are mutually
exclusive, which is a temporary condition.
Whereas EOPNOTSUPP indicates that the HW does not support all or parts of
the vnicc feature.
This issue causes the vnicc sysfs params to show 'blocked by bridgeport'
for HW that does not support VNICC at all.

Fixes: caa1f0b10d18 ("s390/qeth: add VNICC enable/disable support")
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_l2_main.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index aa90004f49e28..eb917e93fa72f 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -2148,15 +2148,14 @@ int qeth_l2_vnicc_set_state(struct qeth_card *card, u32 vnicc, bool state)
 
 	QETH_CARD_TEXT(card, 2, "vniccsch");
 
-	/* do not change anything if BridgePort is enabled */
-	if (qeth_bridgeport_is_in_use(card))
-		return -EBUSY;
-
 	/* check if characteristic and enable/disable are supported */
 	if (!(card->options.vnicc.sup_chars & vnicc) ||
 	    !(card->options.vnicc.set_char_sup & vnicc))
 		return -EOPNOTSUPP;
 
+	if (qeth_bridgeport_is_in_use(card))
+		return -EBUSY;
+
 	/* set enable/disable command and store wanted characteristic */
 	if (state) {
 		cmd = IPA_VNICC_ENABLE;
@@ -2202,14 +2201,13 @@ int qeth_l2_vnicc_get_state(struct qeth_card *card, u32 vnicc, bool *state)
 
 	QETH_CARD_TEXT(card, 2, "vniccgch");
 
-	/* do not get anything if BridgePort is enabled */
-	if (qeth_bridgeport_is_in_use(card))
-		return -EBUSY;
-
 	/* check if characteristic is supported */
 	if (!(card->options.vnicc.sup_chars & vnicc))
 		return -EOPNOTSUPP;
 
+	if (qeth_bridgeport_is_in_use(card))
+		return -EBUSY;
+
 	/* if card is ready, query current VNICC state */
 	if (qeth_card_hw_is_reachable(card))
 		rc = qeth_l2_vnicc_query_chars(card);
@@ -2227,15 +2225,14 @@ int qeth_l2_vnicc_set_timeout(struct qeth_card *card, u32 timeout)
 
 	QETH_CARD_TEXT(card, 2, "vniccsto");
 
-	/* do not change anything if BridgePort is enabled */
-	if (qeth_bridgeport_is_in_use(card))
-		return -EBUSY;
-
 	/* check if characteristic and set_timeout are supported */
 	if (!(card->options.vnicc.sup_chars & QETH_VNICC_LEARNING) ||
 	    !(card->options.vnicc.getset_timeout_sup & QETH_VNICC_LEARNING))
 		return -EOPNOTSUPP;
 
+	if (qeth_bridgeport_is_in_use(card))
+		return -EBUSY;
+
 	/* do we need to do anything? */
 	if (card->options.vnicc.learning_timeout == timeout)
 		return rc;
@@ -2264,14 +2261,14 @@ int qeth_l2_vnicc_get_timeout(struct qeth_card *card, u32 *timeout)
 
 	QETH_CARD_TEXT(card, 2, "vniccgto");
 
-	/* do not get anything if BridgePort is enabled */
-	if (qeth_bridgeport_is_in_use(card))
-		return -EBUSY;
-
 	/* check if characteristic and get_timeout are supported */
 	if (!(card->options.vnicc.sup_chars & QETH_VNICC_LEARNING) ||
 	    !(card->options.vnicc.getset_timeout_sup & QETH_VNICC_LEARNING))
 		return -EOPNOTSUPP;
+
+	if (qeth_bridgeport_is_in_use(card))
+		return -EBUSY;
+
 	/* if card is ready, get timeout. Otherwise, just return stored value */
 	*timeout = card->options.vnicc.learning_timeout;
 	if (qeth_card_hw_is_reachable(card))
-- 
2.20.1

