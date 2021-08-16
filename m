Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CCF3ED526
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238261AbhHPNIn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:08:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:56462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237796AbhHPNHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:07:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81BE1632A9;
        Mon, 16 Aug 2021 13:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119191;
        bh=MhFh18hnn3+43BzuK1lG7l+ByHupZngon+9H0Ze+jY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJeS23tD22aKsmPMku3SCqbZEPM2aRNAvwweu/jVQfTgut9d8Ul7FBv+TGLzq8O11
         HvAO1Aa0lb7Ii18FPXeV1KogpP7RsC5hS/k/JrRf3vQB6ZZV2uR6F93J7QtCKXrVq0
         s23/4Wb2UQo2AHTodquqmmKTNPd/O3hKvjfJq8G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/96] interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate
Date:   Mon, 16 Aug 2021 15:01:37 +0200
Message-Id: <20210816125435.847039960@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Tipton <mdtipton@codeaurora.org>

[ Upstream commit f84f5b6f72e68bbaeb850b58ac167e4a3a47532a ]

We're only adding BCMs to the commit list in aggregate(), but there are
cases where pre_aggregate() is called without subsequently calling
aggregate(). In particular, in icc_sync_state() when a node with initial
BW has zero requests. Since BCMs aren't added to the commit list in
these cases, we don't actually send the zero BW request to HW. So the
resources remain on unnecessarily.

Add BCMs to the commit list in pre_aggregate() instead, which is always
called even when there are no requests.

Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
Link: https://lore.kernel.org/r/20210721175432.2119-5-mdtipton@codeaurora.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/icc-rpmh.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index f6fae64861ce..27cc5f03611c 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -20,13 +20,18 @@ void qcom_icc_pre_aggregate(struct icc_node *node)
 {
 	size_t i;
 	struct qcom_icc_node *qn;
+	struct qcom_icc_provider *qp;
 
 	qn = node->data;
+	qp = to_qcom_provider(node->provider);
 
 	for (i = 0; i < QCOM_ICC_NUM_BUCKETS; i++) {
 		qn->sum_avg[i] = 0;
 		qn->max_peak[i] = 0;
 	}
+
+	for (i = 0; i < qn->num_bcms; i++)
+		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
 }
 EXPORT_SYMBOL_GPL(qcom_icc_pre_aggregate);
 
@@ -44,10 +49,8 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 {
 	size_t i;
 	struct qcom_icc_node *qn;
-	struct qcom_icc_provider *qp;
 
 	qn = node->data;
-	qp = to_qcom_provider(node->provider);
 
 	if (!tag)
 		tag = QCOM_ICC_TAG_ALWAYS;
@@ -67,9 +70,6 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 	*agg_avg += avg_bw;
 	*agg_peak = max_t(u32, *agg_peak, peak_bw);
 
-	for (i = 0; i < qn->num_bcms; i++)
-		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_aggregate);
-- 
2.30.2



