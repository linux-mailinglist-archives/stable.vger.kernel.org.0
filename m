Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC9C05EA1F1
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbiIZLAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237347AbiIZK71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:59:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952775C9EB;
        Mon, 26 Sep 2022 03:31:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 966B9B80952;
        Mon, 26 Sep 2022 10:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D207FC433D6;
        Mon, 26 Sep 2022 10:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188251;
        bh=3tdsAQP+V8e9ZD4BWk3zNjB2XQAPdWt1dSbmitw3cNI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OXKZmQoWOKG0UvpAS3uViv15WrO4CbmijQzg+SP1enzhb2Ej6DMb522eqQnTLlrXl
         2BduczK+nI9Zwc4wdSYk1IuxS952GSp9KBj67Sk3wK+MeNPQsvR4DHEBVbpvpOdwUf
         jtT+JCWrmQDJnaZURBxTvr57OyUByuEBhCxHOkOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Tipton <mdtipton@codeaurora.org>,
        Georgi Djakov <djakov@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Alex Elder <elder@linaro.org>
Subject: [PATCH 5.10 059/141] interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate
Date:   Mon, 26 Sep 2022 12:11:25 +0200
Message-Id: <20220926100756.596263294@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
[dianders: dropped sm8350.c which isn't present in 5.10]
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Acked-by: Alex Elder <elder@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/interconnect/qcom/icc-rpmh.c |   10 +++++-----
 drivers/interconnect/qcom/sm8150.c   |    1 -
 drivers/interconnect/qcom/sm8250.c   |    1 -
 3 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -20,13 +20,18 @@ void qcom_icc_pre_aggregate(struct icc_n
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
 
@@ -44,10 +49,8 @@ int qcom_icc_aggregate(struct icc_node *
 {
 	size_t i;
 	struct qcom_icc_node *qn;
-	struct qcom_icc_provider *qp;
 
 	qn = node->data;
-	qp = to_qcom_provider(node->provider);
 
 	if (!tag)
 		tag = QCOM_ICC_TAG_ALWAYS;
@@ -67,9 +70,6 @@ int qcom_icc_aggregate(struct icc_node *
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
@@ -627,7 +627,6 @@ static struct platform_driver qnoc_drive
 	.driver = {
 		.name = "qnoc-sm8150",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -643,7 +643,6 @@ static struct platform_driver qnoc_drive
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);


