Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FD85410B8
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354761AbiFGT3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356451AbiFGT1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:27:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5181A0496;
        Tue,  7 Jun 2022 11:09:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8F076191F;
        Tue,  7 Jun 2022 18:09:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EA5C385A2;
        Tue,  7 Jun 2022 18:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625397;
        bh=R7s5qhqlc8oaHXaxqq3TaH0YEHdnKSQuufnYhVfx8DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cR4HxlykD7wNY+5rSvdN9tBSUgb5FnOAoNnA+JiSAB/o5ugs7NcVyMo64Km2+ixxH
         rdt95zpFnHiVPIJrU6IgUEHAqe7mUSRvxPISmIQ3Og0N3IU3W117yVDAp9ZTWVnr/V
         HpCC4herFbfveFKSIB1QDK6LJUlSnm+5cOOsLGpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH 5.15 661/667] interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate
Date:   Tue,  7 Jun 2022 19:05:26 +0200
Message-Id: <20220607164954.469040918@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Tipton <mdtipton@codeaurora.org>

commit b95b668eaaa2574e8ee72f143c52075e9955177e upstream.

We're only adding BCMs to the commit list in aggregate(), but there are
cases where pre_aggregate() is called without subsequently calling
aggregate(). In particular, in icc_sync_state() when a node with initial
BW has zero requests. Since BCMs aren't added to the commit list in
these cases, we don't actually send the zero BW request to HW. So the
resources remain on unnecessarily.

Add BCMs to the commit list in pre_aggregate() instead, which is always
called even when there are no requests.

Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
[georgi: remove icc_sync_state for platforms with incomplete support]
Link: https://lore.kernel.org/r/20211125174751.25317-1-djakov@kernel.org
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/icc-rpmh.c |   10 +++++-----
 drivers/interconnect/qcom/sm8150.c   |    1 -
 drivers/interconnect/qcom/sm8250.c   |    1 -
 drivers/interconnect/qcom/sm8350.c   |    1 -
 4 files changed, 5 insertions(+), 8 deletions(-)

--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -21,13 +21,18 @@ void qcom_icc_pre_aggregate(struct icc_n
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
 
@@ -45,10 +50,8 @@ int qcom_icc_aggregate(struct icc_node *
 {
 	size_t i;
 	struct qcom_icc_node *qn;
-	struct qcom_icc_provider *qp;
 
 	qn = node->data;
-	qp = to_qcom_provider(node->provider);
 
 	if (!tag)
 		tag = QCOM_ICC_TAG_ALWAYS;
@@ -68,9 +71,6 @@ int qcom_icc_aggregate(struct icc_node *
 	*agg_avg += avg_bw;
 	*agg_peak = max_t(u32, *agg_peak, peak_bw);
 
-	for (i = 0; i < qn->num_bcms; i++)
-		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_aggregate);
--- a/drivers/interconnect/qcom/sm8150.c
+++ b/drivers/interconnect/qcom/sm8150.c
@@ -535,7 +535,6 @@ static struct platform_driver qnoc_drive
 	.driver = {
 		.name = "qnoc-sm8150",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -551,7 +551,6 @@ static struct platform_driver qnoc_drive
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
--- a/drivers/interconnect/qcom/sm8350.c
+++ b/drivers/interconnect/qcom/sm8350.c
@@ -531,7 +531,6 @@ static struct platform_driver qnoc_drive
 	.driver = {
 		.name = "qnoc-sm8350",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);


