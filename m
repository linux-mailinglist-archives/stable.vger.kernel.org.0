Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E081F4A94
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732977AbfKHLi5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:38:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732968AbfKHLi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA4E721D7B;
        Fri,  8 Nov 2019 11:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213136;
        bh=9+wXAdScMRLLd2ki2eKbU2z5dqGISXkxKwkNjAfpYFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mb5HqADSRdIBKuobVMDovx8oaseO7lu1woWs52Hg8x1oSrU3z/rXUkiSFey9TLtxp
         Z2GkRnJF48ofUW+mufqcLBk9RvV0JnGbDKW1rVWLuGBI5C3IR0B+5bA6wgIqzIQHIL
         8AWl381tey6DW7qKOXgfkZaYSrHrE+W42hnJOyWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vijay Immanuel <vijayi@attalasystems.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 054/205] IB/rxe: avoid back-to-back retries
Date:   Fri,  8 Nov 2019 06:35:21 -0500
Message-Id: <20191108113752.12502-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vijay Immanuel <vijayi@attalasystems.com>

[ Upstream commit 4e4c53df567714b3d08b2b5d8ccb1d175fc9be01 ]

Error retries can occur due to timeouts, NAKs or receiving
packets beyond the current read request. Avoid back-to-back
retries due to packet processing, by only retrying the initial
attempt immediately. Subsequent retries must be due to timeouts.

Continue to process completion packets after scheduling a retry.

Signed-off-by: Vijay Immanuel <vijayi@attalasystems.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c  | 18 +++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_verbs.h |  1 +
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index 83311dd07019b..ed96441595d81 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -191,6 +191,7 @@ static inline void reset_retry_counters(struct rxe_qp *qp)
 {
 	qp->comp.retry_cnt = qp->attr.retry_cnt;
 	qp->comp.rnr_retry = qp->attr.rnr_retry;
+	qp->comp.started_retry = 0;
 }
 
 static inline enum comp_state check_psn(struct rxe_qp *qp,
@@ -676,6 +677,20 @@ int rxe_completer(void *arg)
 				goto exit;
 			}
 
+			/* if we've started a retry, don't start another
+			 * retry sequence, unless this is a timeout.
+			 */
+			if (qp->comp.started_retry &&
+			    !qp->comp.timeout_retry) {
+				if (pkt) {
+					rxe_drop_ref(pkt->qp);
+					kfree_skb(skb);
+					skb = NULL;
+				}
+
+				goto done;
+			}
+
 			if (qp->comp.retry_cnt > 0) {
 				if (qp->comp.retry_cnt != 7)
 					qp->comp.retry_cnt--;
@@ -692,6 +707,7 @@ int rxe_completer(void *arg)
 					rxe_counter_inc(rxe,
 							RXE_CNT_COMP_RETRY);
 					qp->req.need_retry = 1;
+					qp->comp.started_retry = 1;
 					rxe_run_task(&qp->req.task, 1);
 				}
 
@@ -701,7 +717,7 @@ int rxe_completer(void *arg)
 					skb = NULL;
 				}
 
-				goto exit;
+				goto done;
 
 			} else {
 				rxe_counter_inc(rxe, RXE_CNT_RETRY_EXCEEDED);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 3b731c7682e5b..a0ec28d2b71a4 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -158,6 +158,7 @@ struct rxe_comp_info {
 	int			opcode;
 	int			timeout;
 	int			timeout_retry;
+	int			started_retry;
 	u32			retry_cnt;
 	u32			rnr_retry;
 	struct rxe_task		task;
-- 
2.20.1

