Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E915913FF50
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389690AbgAPX06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:26:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730261AbgAPX06 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:26:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9453320684;
        Thu, 16 Jan 2020 23:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217217;
        bh=T9fqrrkfooFFhTRKTUscSsrpJdO1WsvH0QD9PwLE1V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOTQaP+T0hMNZy1jXp0VJawZSjSL3Tx6bkz6Fbquy2yBruHj8u7FVlFhJczKMTQ60
         6p3NCAbCkbtEaNpucFY1ztPabD+Ee8Tig1UPueZXo/E4XSITcQ2GoBivsaWBmeT13n
         xfNsLbF2tgxjVkB6PWIne4bIedgRCZMIahBHf7hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 196/203] s390/qeth: lock the card while changing its hsuid
Date:   Fri, 17 Jan 2020 00:18:33 +0100
Message-Id: <20200116231801.292602782@linuxfoundation.org>
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

[ Upstream commit 5b6c7b55cfe26224b0f41b1c226d3534c542787f ]

qeth_l3_dev_hsuid_store() initially checks the card state, but doesn't
take the conf_mutex to ensure that the card stays in this state while
being reconfigured.

Rework the code to take this lock, and drop a redundant state check in a
helper function.

Fixes: b333293058aa ("qeth: add support for af_iucv HiperSockets transport")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c |  5 ----
 drivers/s390/net/qeth_l3_sys.c    | 40 +++++++++++++++++++++----------
 2 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 94e5b6e15ef9..5be4d800e4ba 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3378,11 +3378,6 @@ int qeth_configure_cq(struct qeth_card *card, enum qeth_cq cq)
 			goto out;
 		}
 
-		if (card->state != CARD_STATE_DOWN) {
-			rc = -1;
-			goto out;
-		}
-
 		qeth_free_qdio_queues(card);
 		card->options.cq = cq;
 		rc = 0;
diff --git a/drivers/s390/net/qeth_l3_sys.c b/drivers/s390/net/qeth_l3_sys.c
index 2f73b33c9347..333fd4619dc6 100644
--- a/drivers/s390/net/qeth_l3_sys.c
+++ b/drivers/s390/net/qeth_l3_sys.c
@@ -270,24 +270,36 @@ static ssize_t qeth_l3_dev_hsuid_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct qeth_card *card = dev_get_drvdata(dev);
+	int rc = 0;
 	char *tmp;
-	int rc;
 
 	if (!card)
 		return -EINVAL;
 
 	if (!IS_IQD(card))
 		return -EPERM;
-	if (card->state != CARD_STATE_DOWN)
-		return -EPERM;
-	if (card->options.sniffer)
-		return -EPERM;
-	if (card->options.cq == QETH_CQ_NOTAVAILABLE)
-		return -EPERM;
+
+	mutex_lock(&card->conf_mutex);
+	if (card->state != CARD_STATE_DOWN) {
+		rc = -EPERM;
+		goto out;
+	}
+
+	if (card->options.sniffer) {
+		rc = -EPERM;
+		goto out;
+	}
+
+	if (card->options.cq == QETH_CQ_NOTAVAILABLE) {
+		rc = -EPERM;
+		goto out;
+	}
 
 	tmp = strsep((char **)&buf, "\n");
-	if (strlen(tmp) > 8)
-		return -EINVAL;
+	if (strlen(tmp) > 8) {
+		rc = -EINVAL;
+		goto out;
+	}
 
 	if (card->options.hsuid[0])
 		/* delete old ip address */
@@ -298,11 +310,13 @@ static ssize_t qeth_l3_dev_hsuid_store(struct device *dev,
 		card->options.hsuid[0] = '\0';
 		memcpy(card->dev->perm_addr, card->options.hsuid, 9);
 		qeth_configure_cq(card, QETH_CQ_DISABLED);
-		return count;
+		goto out;
 	}
 
-	if (qeth_configure_cq(card, QETH_CQ_ENABLED))
-		return -EPERM;
+	if (qeth_configure_cq(card, QETH_CQ_ENABLED)) {
+		rc = -EPERM;
+		goto out;
+	}
 
 	snprintf(card->options.hsuid, sizeof(card->options.hsuid),
 		 "%-8s", tmp);
@@ -311,6 +325,8 @@ static ssize_t qeth_l3_dev_hsuid_store(struct device *dev,
 
 	rc = qeth_l3_modify_hsuid(card, true);
 
+out:
+	mutex_unlock(&card->conf_mutex);
 	return rc ? rc : count;
 }
 
-- 
2.20.1



