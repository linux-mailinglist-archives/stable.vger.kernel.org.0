Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32B7441748
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbhKAJfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:35:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233142AbhKAJcM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90B9D6124D;
        Mon,  1 Nov 2021 09:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758663;
        bh=YQrqZ+hp/Vwdu7IJKKeZURnxa8c0+4XmeibeupmRxcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fK+dOQNM5C26hSP2mUTYNq6vl5XIrjbOwsA3VCKapRfk9UqIy1YpOMPraisP0eo5q
         sSojfZWZ56UrZ+LPpN7belqKbVi5vKz20W2VszwFJhP2swJf7mDOteVU0IjXd+hpF3
         QZvHvtIsrStRE3ExgNhc5jJnoj0WKwsxzXA/yu8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.4 25/51] IB/hfi1: Fix abba locking issue with sc_disable()
Date:   Mon,  1 Nov 2021 10:17:29 +0100
Message-Id: <20211101082506.327581784@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

commit 13bac861952a78664907a0f927d3e874e9a59034 upstream.

sc_disable() after having disabled the send context wakes up any waiters
by calling hfi1_qp_wakeup() while holding the waitlock for the sc.

This is contrary to the model for all other calls to hfi1_qp_wakeup()
where the waitlock is dropped and a local is used to drive calls to
hfi1_qp_wakeup().

Fix by moving the sc->piowait into a local list and driving the wakeup
calls from the list.

Fixes: 099a884ba4c0 ("IB/hfi1: Handle wakeup of orphaned QPs for pio")
Link: https://lore.kernel.org/r/20211013141852.128104.2682.stgit@awfm-01.cornelisnetworks.com
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/hfi1/pio.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -920,6 +920,7 @@ void sc_disable(struct send_context *sc)
 {
 	u64 reg;
 	struct pio_buf *pbuf;
+	LIST_HEAD(wake_list);
 
 	if (!sc)
 		return;
@@ -954,19 +955,21 @@ void sc_disable(struct send_context *sc)
 	spin_unlock(&sc->release_lock);
 
 	write_seqlock(&sc->waitlock);
-	while (!list_empty(&sc->piowait)) {
+	if (!list_empty(&sc->piowait))
+		list_move(&sc->piowait, &wake_list);
+	write_sequnlock(&sc->waitlock);
+	while (!list_empty(&wake_list)) {
 		struct iowait *wait;
 		struct rvt_qp *qp;
 		struct hfi1_qp_priv *priv;
 
-		wait = list_first_entry(&sc->piowait, struct iowait, list);
+		wait = list_first_entry(&wake_list, struct iowait, list);
 		qp = iowait_to_qp(wait);
 		priv = qp->priv;
 		list_del_init(&priv->s_iowait.list);
 		priv->s_iowait.lock = NULL;
 		hfi1_qp_wakeup(qp, RVT_S_WAIT_PIO | HFI1_S_WAIT_PIO_DRAIN);
 	}
-	write_sequnlock(&sc->waitlock);
 
 	spin_unlock_irq(&sc->alloc_lock);
 }


