Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767AB3E820D
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhHJSFe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:05:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236779AbhHJSDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:03:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 220FF61251;
        Tue, 10 Aug 2021 17:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617664;
        bh=Wxvvm94BJFdhmcnx0FizZHyBx0eUN7fIOrXYHStTKQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VhDuCt+VRDJrddPcE/9RqxToTLEQqoF/Dd5z6sua6KjAHdglO+bZC7HTZQZGLBSps
         +oX5NBdkRCVk06d7KHcJTqfae5NQZ1DwjebyXj0iDZ3jvZArTbIZ3c1uo3TDHpM61L
         ct7zPJ6mI2CF2hbtSBh3TJe48o7laNgQTMVlsHoE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.13 158/175] interconnect: qcom: icc-rpmh: Ensure floor BW is enforced for all nodes
Date:   Tue, 10 Aug 2021 19:31:06 +0200
Message-Id: <20210810173006.171793648@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Tipton <mdtipton@codeaurora.org>

commit ce5a595744126be4f1327e29e3c5ae9aac6b38d5 upstream.

We currently only enforce BW floors for a subset of nodes in a path.
All BCMs that need updating are queued in the pre_aggregate/aggregate
phase. The first set() commits all queued BCMs and subsequent set()
calls short-circuit without committing anything. Since the floor BW
isn't set in sum_avg/max_peak until set(), then some BCMs are committed
before their associated nodes reflect the floor.

Set the floor as each node is being aggregated. This ensures that all
all relevant floors are set before the BCMs are committed.

Fixes: 266cd33b5913 ("interconnect: qcom: Ensure that the floor bandwidth value is enforced")
Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
Link: https://lore.kernel.org/r/20210721175432.2119-4-mdtipton@codeaurora.org
[georgi: Removed unused variable]
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/icc-rpmh.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -57,6 +57,11 @@ int qcom_icc_aggregate(struct icc_node *
 			qn->sum_avg[i] += avg_bw;
 			qn->max_peak[i] = max_t(u32, qn->max_peak[i], peak_bw);
 		}
+
+		if (node->init_avg || node->init_peak) {
+			qn->sum_avg[i] = max_t(u64, qn->sum_avg[i], node->init_avg);
+			qn->max_peak[i] = max_t(u64, qn->max_peak[i], node->init_peak);
+		}
 	}
 
 	*agg_avg += avg_bw;
@@ -79,7 +84,6 @@ EXPORT_SYMBOL_GPL(qcom_icc_aggregate);
 int qcom_icc_set(struct icc_node *src, struct icc_node *dst)
 {
 	struct qcom_icc_provider *qp;
-	struct qcom_icc_node *qn;
 	struct icc_node *node;
 
 	if (!src)
@@ -88,12 +92,6 @@ int qcom_icc_set(struct icc_node *src, s
 		node = src;
 
 	qp = to_qcom_provider(node->provider);
-	qn = node->data;
-
-	qn->sum_avg[QCOM_ICC_BUCKET_AMC] = max_t(u64, qn->sum_avg[QCOM_ICC_BUCKET_AMC],
-						 node->avg_bw);
-	qn->max_peak[QCOM_ICC_BUCKET_AMC] = max_t(u64, qn->max_peak[QCOM_ICC_BUCKET_AMC],
-						  node->peak_bw);
 
 	qcom_icc_bcm_voter_commit(qp->voter);
 


