Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58135A25E7
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 20:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfH2SdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 14:33:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728585AbfH2SNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67529233FF;
        Thu, 29 Aug 2019 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102432;
        bh=wpmruaQbL2KAE/UKd4qy1TFFndrVLSjSXyqVxwP3wFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZN2qb1PtZ7C9yXDqiRA/eKTYnWk8wb4NWLzSxjBLdDb4ANC6uP7xco/pVfO/fF0xm
         6XcUoIjI4H0br9Iknqx+qeEnb0pTM9kRD3P2/adNaoWbDk0txCSpa9rIHH3sPUo/te
         TwIcoe8vOxnzUNx3NYHA1QtSgRtpIu9KLKRJxwuQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 21/76] s390/qeth: serialize cmd reply with concurrent timeout
Date:   Thu, 29 Aug 2019 14:12:16 -0400
Message-Id: <20190829181311.7562-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 072f79400032f74917726cf76f4248367ea2b5b8 ]

Callbacks for a cmd reply run outside the protection of card->lock, to
allow for additional cmds to be issued & enqueued in parallel.

When qeth_send_control_data() bails out for a cmd without having
received a reply (eg. due to timeout), its callback may concurrently be
processing a reply that just arrived. In this case, the callback
potentially accesses a stale reply->reply_param area that eg. was
on-stack and has already been released.

To avoid this race, add some locking so that qeth_send_control_data()
can (1) wait for a concurrently running callback, and (2) zap any
pending callback that still wants to run.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core.h      |  1 +
 drivers/s390/net/qeth_core_main.c | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 784a2e76a1b04..c5f60f95e8db9 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -640,6 +640,7 @@ struct qeth_seqno {
 struct qeth_reply {
 	struct list_head list;
 	struct completion received;
+	spinlock_t lock;
 	int (*callback)(struct qeth_card *, struct qeth_reply *,
 		unsigned long);
 	u32 seqno;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index b1823d75dd35c..6b8f99e7d8a81 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -548,6 +548,7 @@ static struct qeth_reply *qeth_alloc_reply(struct qeth_card *card)
 	if (reply) {
 		refcount_set(&reply->refcnt, 1);
 		init_completion(&reply->received);
+		spin_lock_init(&reply->lock);
 	}
 	return reply;
 }
@@ -832,6 +833,13 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 
 	if (!reply->callback) {
 		rc = 0;
+		goto no_callback;
+	}
+
+	spin_lock_irqsave(&reply->lock, flags);
+	if (reply->rc) {
+		/* Bail out when the requestor has already left: */
+		rc = reply->rc;
 	} else {
 		if (cmd) {
 			reply->offset = (u16)((char *)cmd - (char *)iob->data);
@@ -840,7 +848,9 @@ static void qeth_issue_next_read_cb(struct qeth_card *card,
 			rc = reply->callback(card, reply, (unsigned long)iob);
 		}
 	}
+	spin_unlock_irqrestore(&reply->lock, flags);
 
+no_callback:
 	if (rc <= 0)
 		qeth_notify_reply(reply, rc);
 	qeth_put_reply(reply);
@@ -1880,6 +1890,16 @@ static int qeth_send_control_data(struct qeth_card *card, int len,
 		rc = (timeout == -ERESTARTSYS) ? -EINTR : -ETIME;
 
 	qeth_dequeue_reply(card, reply);
+
+	if (reply_cb) {
+		/* Wait until the callback for a late reply has completed: */
+		spin_lock_irq(&reply->lock);
+		if (rc)
+			/* Zap any callback that's still pending: */
+			reply->rc = rc;
+		spin_unlock_irq(&reply->lock);
+	}
+
 	if (!rc)
 		rc = reply->rc;
 	qeth_put_reply(reply);
-- 
2.20.1

