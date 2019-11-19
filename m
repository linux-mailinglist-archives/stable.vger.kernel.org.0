Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0363E1018A4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbfKSF1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:45252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727264AbfKSF1E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9909B222DC;
        Tue, 19 Nov 2019 05:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141223;
        bh=9+wXAdScMRLLd2ki2eKbU2z5dqGISXkxKwkNjAfpYFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UBL9AN/+9h1sch3bdHFOM3nfS0VH00IUcICyS/g33Ls8W4e6mNXQKx0iLasToKMVP
         aslKndqvVywMKePxPt+oz7mKXTAuuzXKGE6gQUZjwtDQPgmydLR7ii9MmjyLpq/iA0
         FickN3bjU3y4wICl7vPdAtuRZ/UQNIs/IRzXwhPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vijay Immanuel <vijayi@attalasystems.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/422] IB/rxe: avoid back-to-back retries
Date:   Tue, 19 Nov 2019 06:14:43 +0100
Message-Id: <20191119051405.012561317@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



