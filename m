Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B94D66E6C
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbfGLM2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:28:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:42776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfGLM2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:28:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A68D621019;
        Fri, 12 Jul 2019 12:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934517;
        bh=azWYwh6IPpI2P6Z5Z2wpZrKKRWFZxrzSyb78rRez08E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2vmxegbJbnV1KT3vP4hupV4liBvSDXOhfN1HGAz/61grzyN8w5UL4LtLYQpGegAA
         GH24MCjD8etqUwjGMnJ0Ok0U8WYgL84TcFmWaeSy4eyqhJc04Pqfbv6suO6NyPEqs6
         ZeLdmfv39+ufw+r6luXIiZEgi5S+J0O34A8XGeU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 074/138] IB/hfi1: Wakeup QPs orphaned on wait list after flush
Date:   Fri, 12 Jul 2019 14:18:58 +0200
Message-Id: <20190712121631.527663570@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit f972775b1cc0441ae22c9f8d06dd16b118463632 ]

Once an SDMA engine is taken down due to a link failure, any waiting QPs
that do not have outstanding descriptors in the ring will stay
on the dmawait list as long as the port is down.

Since there is no timer running, they will stay there for a long time.

The fix is to wake up all iowaits linked to dmawait. The send engine
will build and post packets that get flushed back.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 70828de7436b..28b66bd70b74 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -405,6 +405,7 @@ static void sdma_flush(struct sdma_engine *sde)
 	struct sdma_txreq *txp, *txp_next;
 	LIST_HEAD(flushlist);
 	unsigned long flags;
+	uint seq;
 
 	/* flush from head to tail */
 	sdma_flush_descq(sde);
@@ -415,6 +416,22 @@ static void sdma_flush(struct sdma_engine *sde)
 	/* flush from flush list */
 	list_for_each_entry_safe(txp, txp_next, &flushlist, list)
 		complete_tx(sde, txp, SDMA_TXREQ_S_ABORTED);
+	/* wakeup QPs orphaned on the dmawait list */
+	do {
+		struct iowait *w, *nw;
+
+		seq = read_seqbegin(&sde->waitlock);
+		if (!list_empty(&sde->dmawait)) {
+			write_seqlock(&sde->waitlock);
+			list_for_each_entry_safe(w, nw, &sde->dmawait, list) {
+				if (w->wakeup) {
+					w->wakeup(w, SDMA_AVAIL_REASON);
+					list_del_init(&w->list);
+				}
+			}
+			write_sequnlock(&sde->waitlock);
+		}
+	} while (read_seqretry(&sde->waitlock, seq));
 }
 
 /*
-- 
2.20.1



