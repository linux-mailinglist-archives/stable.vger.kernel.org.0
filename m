Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0128B33B724
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbhCON7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232330AbhCON6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:58:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8027164F16;
        Mon, 15 Mar 2021 13:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816704;
        bh=lYI+fxC0x0wtugthTFEwxqBaDX2lnENLz29pCkVtjPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tilEB6kimJEU3SyDUv+MaQe5tpcZMyq6aKtieC53iEFVNzJdtdw0dlb43bHXxUg5f
         zhMXDNiCgvXrwqiryq+h2KXSrGbSMuUgru8bTPnbD/b0VnaleG0tMdbdIGDa705n9W
         X487l5v26OF6WWgClaKqF2qQHv59F6SKUFvz73cc=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 075/306] s390/qeth: fix notification for pending buffers during teardown
Date:   Mon, 15 Mar 2021 14:52:18 +0100
Message-Id: <20210315135510.180474061@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Julian Wiedmann <jwi@linux.ibm.com>

commit 7eefda7f353ef86ad82a2dc8329e8a3538c08ab6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/net/qeth_core_main.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1386,9 +1386,6 @@ static void qeth_tx_complete_buf(struct
 	struct qeth_qdio_out_q *queue = buf->q;
 	struct sk_buff *skb;
 
-	if (atomic_read(&buf->state) == QETH_QDIO_BUF_PENDING)
-		qeth_notify_skbs(queue, buf, TX_NOTIFY_GENERALERROR);
-
 	/* Empty buffer? */
 	if (buf->next_element_to_fill == 0)
 		return;
@@ -1461,6 +1458,9 @@ static void qeth_tx_complete_pending_buf
 			QETH_CARD_TEXT(card, 5, "fp");
 			QETH_CARD_TEXT_(card, 5, "%lx", (long) buf);
 
+			if (drain)
+				qeth_notify_skbs(queue, buf,
+						 TX_NOTIFY_GENERALERROR);
 			qeth_tx_complete_buf(buf, drain, 0);
 
 			list_del(&buf->list_entry);


