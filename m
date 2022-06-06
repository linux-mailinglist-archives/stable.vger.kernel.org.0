Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9336253F2CB
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 01:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbiFFXwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 19:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiFFXwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 19:52:00 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7DB62121
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 16:51:59 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso13957882pjg.0
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 16:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WsTTTOjG+Vbcb+vcunb5X0Lj8H/wI0MStJUyQ/ecJGE=;
        b=RQ8ZqAex32kUrmAqMvdCPQP6zmgUb1P8kdqQVJ5fC0zelM4CJ9z+qgHHEtqSvMQRMJ
         eeWuoWz17fpsF+Hw7PNSUhNj5CCk4rAVns4CYc8iAGmfhQXN/GANMJJaRwP8xc6cAwcK
         mNXof47/1j0XsYFtE5USOITzOeyn+C3ErOvM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WsTTTOjG+Vbcb+vcunb5X0Lj8H/wI0MStJUyQ/ecJGE=;
        b=0gq+05ZIF5Y+IkwMhjoL9WPLOR02/galNHkLeIGIQd83tIYc7JW+Nmh3vYuM1Ps5Pl
         XJtAOinbD6L2IrGy9L0pklwKgjv/c1iY5dJIl2fqPiSp9+3HuNpQjI/aT/Q1QoRmpSqt
         ILFzQjh9HUGyvnWA6AaBDP4V0HKFc1wkbQRZvUy9URP3mcauON3VcUI5jzJHlDvlsDdL
         /MUKqjw1b3D/tuj+jkttS2C/jsMHtc0GmIWE0ap4bgajpySkB7+h0JK5lCMQQ3ovqgXc
         V/IMer4kAiGcbGKPlKVGF37sldEjyVaUYk7zUWqETjgHeUxD8eHqFmDOIicSieeaat/I
         Nn2w==
X-Gm-Message-State: AOAM532ED4gEcG+pyiWPkWNTPcw/s1oFxIymPDV2dbX68tF9U/c2BMON
        cYG31PkFIPO2GTkEQ7NUwB26FtQVHe6gyw==
X-Google-Smtp-Source: ABdhPJxmppgUROz/+tFTZEHF7PcbixoItJvzI3E1Je/eMq2dwftQLgbUb8gJEHAJXd6aOHrEA4NNuA==
X-Received: by 2002:a17:903:1c3:b0:166:303e:124a with SMTP id e3-20020a17090301c300b00166303e124amr26005019plh.7.1654559519129;
        Mon, 06 Jun 2022 16:51:59 -0700 (PDT)
Received: from smtp.gmail.com ([2620:15c:202:201:7100:486c:d20:242a])
        by smtp.gmail.com with ESMTPSA id 66-20020a621445000000b0050dc762816dsm11005789pfu.71.2022.06.06.16.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 16:51:58 -0700 (PDT)
From:   Stephen Boyd <swboyd@chromium.org>
To:     stable@vger.kernel.org
Cc:     Mike Tipton <mdtipton@codeaurora.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Alex Elder <elder@linaro.org>,
        Georgi Djakov <djakov@kernel.org>
Subject: [PATCH 5.15 2/2] interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate
Date:   Mon,  6 Jun 2022 16:51:55 -0700
Message-Id: <20220606235155.2437168-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220606235155.2437168-1-swboyd@chromium.org>
References: <20220606235155.2437168-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
---
 drivers/interconnect/qcom/icc-rpmh.c | 10 +++++-----
 drivers/interconnect/qcom/sm8150.c   |  1 -
 drivers/interconnect/qcom/sm8250.c   |  1 -
 drivers/interconnect/qcom/sm8350.c   |  1 -
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/interconnect/qcom/icc-rpmh.c b/drivers/interconnect/qcom/icc-rpmh.c
index 3eb7936d2cf6..2c8e12549804 100644
--- a/drivers/interconnect/qcom/icc-rpmh.c
+++ b/drivers/interconnect/qcom/icc-rpmh.c
@@ -21,13 +21,18 @@ void qcom_icc_pre_aggregate(struct icc_node *node)
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
 
@@ -45,10 +50,8 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 {
 	size_t i;
 	struct qcom_icc_node *qn;
-	struct qcom_icc_provider *qp;
 
 	qn = node->data;
-	qp = to_qcom_provider(node->provider);
 
 	if (!tag)
 		tag = QCOM_ICC_TAG_ALWAYS;
@@ -68,9 +71,6 @@ int qcom_icc_aggregate(struct icc_node *node, u32 tag, u32 avg_bw,
 	*agg_avg += avg_bw;
 	*agg_peak = max_t(u32, *agg_peak, peak_bw);
 
-	for (i = 0; i < qn->num_bcms; i++)
-		qcom_icc_bcm_voter_add(qp->voter, qn->bcms[i]);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qcom_icc_aggregate);
diff --git a/drivers/interconnect/qcom/sm8150.c b/drivers/interconnect/qcom/sm8150.c
index 2a85f53802b5..745e3c36a61a 100644
--- a/drivers/interconnect/qcom/sm8150.c
+++ b/drivers/interconnect/qcom/sm8150.c
@@ -535,7 +535,6 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8150",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
diff --git a/drivers/interconnect/qcom/sm8250.c b/drivers/interconnect/qcom/sm8250.c
index 8dfb5dea562a..aa707582ea01 100644
--- a/drivers/interconnect/qcom/sm8250.c
+++ b/drivers/interconnect/qcom/sm8250.c
@@ -551,7 +551,6 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8250",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
diff --git a/drivers/interconnect/qcom/sm8350.c b/drivers/interconnect/qcom/sm8350.c
index 3e26a2175b28..c79f93a1ac73 100644
--- a/drivers/interconnect/qcom/sm8350.c
+++ b/drivers/interconnect/qcom/sm8350.c
@@ -531,7 +531,6 @@ static struct platform_driver qnoc_driver = {
 	.driver = {
 		.name = "qnoc-sm8350",
 		.of_match_table = qnoc_of_match,
-		.sync_state = icc_sync_state,
 	},
 };
 module_platform_driver(qnoc_driver);
-- 
https://chromeos.dev

