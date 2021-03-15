Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CFB33B872
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhCOODc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:03:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232835AbhCOOAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C472664E89;
        Mon, 15 Mar 2021 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816783;
        bh=8unQdc5hnTANnRYGxog1e+/Pq9XJgyVVhYZCPVHgm/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DC1sh0+LNLWvhhljiXSIL2wsDfJqMua8AkTbovLEIU5DBfq2uYFPEXe5iOmyJODgh
         ydS0FDjpRwIxwDGMlmQu1Njv0PzrwUo6td5MxyuCsX3TY0QhqDOOs8hV+FFIfj8VVH
         9DfwFsk/WkpKd8oKj4vSXKHzttnWU2p+cNm3M+J8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/290] s390/qeth: fix notification for pending buffers during teardown
Date:   Mon, 15 Mar 2021 14:53:25 +0100
Message-Id: <20210315135545.698316170@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 7eefda7f353ef86ad82a2dc8329e8a3538c08ab6 ]

The cited commit reworked the state machine for pending TX buffers.
In qeth_iqd_tx_complete() it turned PENDING into a transient state, and
uses NEED_QAOB for buffers that get parked while waiting for their QAOB
completion.

But it missed to adjust the check in qeth_tx_complete_buf(). So if
qeth_tx_complete_pending_bufs() is called during teardown to drain
the parked TX buffers, we no longer raise a notification for af_iucv.

Instead of updating the checked state, just move this code into
qeth_tx_complete_pending_bufs() itself. This also gets rid of the
special-case in the common TX completion path.

Fixes: 8908f36d20d8 ("s390/qeth: fix af_iucv notification race")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index db785030293b..03f96177e58e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1383,9 +1383,6 @@ static void qeth_tx_complete_buf(struct qeth_qdio_out_buffer *buf, bool error,
 	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
 
-	if (atomic_read(&buf->state) == QETH_QDIO_BUF_PENDING)
-		qeth_notify_skbs(queue, buf, TX_NOTIFY_GENERALERROR);
-
 	/* Empty buffer? */
 	if (buf->next_element_to_fill == 0)
 		return;
@@ -1458,6 +1455,9 @@ static void qeth_tx_complete_pending_bufs(struct qeth_card *card,
 			QETH_CARD_TEXT(card, 5, "fp");
 			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
 
+			if (drain)
+				qeth_notify_skbs(queue, buf,
+						 TX_NOTIFY_GENERALERROR);
 			qeth_tx_complete_buf(buf, drain, 0);
 
 			list_del(&buf->list_entry);
-- 
2.30.1



