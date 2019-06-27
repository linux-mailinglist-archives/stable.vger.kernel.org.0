Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0FC577EC
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 02:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfF0Aex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 20:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbfF0Aeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 20:34:50 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A05E22184C;
        Thu, 27 Jun 2019 00:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595689;
        bh=qPJL1u9X3VFCl7gl6O4kHX4nwYkGxzNsrJ6SIct+sic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7cO6+yX7i/IuBq5Xj6eEjfFebfBbPK0yFPb01uGqY8X2taczGuppli3/GsfxlyTt
         4xqMxyRccvHchQw8an/hnLCrMB5DOBqIw6BV+GS/OUo77tKaDrsx4Qg+rV9Z4wrqiK
         G1PThSw/Q8Ds772vlZsZE4CUUqyyxwTdHM8Uhlz8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 80/95] IB/hfi1: Wakeup QPs orphaned on wait list after flush
Date:   Wed, 26 Jun 2019 20:30:05 -0400
Message-Id: <20190627003021.19867-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

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
index b0110728f541..1cde1b8f0c8b 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -405,6 +405,7 @@ static void sdma_flush(struct sdma_engine *sde)
 	struct sdma_txreq *txp, *txp_next;
 	LIST_HEAD(flushlist);
 	unsigned long flags;
+	uint seq;
 
 	/* flush from head to tail */
 	sdma_flush_descq(sde);
@@ -418,6 +419,22 @@ static void sdma_flush(struct sdma_engine *sde)
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

