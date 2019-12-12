Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912C311C6BD
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 08:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfLLHx4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 02:53:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36903 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbfLLHxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 02:53:37 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so1608975wru.4
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 23:53:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y0w6MnW3oZvs4i15UPLA0/120XiFldb3t4/pTdGFLw0=;
        b=E6CVo+lYFHxy1yyahd2inU7r/9j3l2DqXTlgipfrVkba/Jl2TfefTcPbRpdk8V0joZ
         RrByorq//rGjnAx9dl6Ds8d1hVHQMVMJhvfdTct0nw8PWLMrJaKjYptNvapLIHAVomiz
         htwxe3N2JqfqGEKKiwiKorD6j6mdVm2KOQ0LcE2wIhLBC95mCMriqAdgeqfUuFHLYPRG
         W2nGPHGhJftyqpmKGwVDVn2lyCd5W+kjHCKKGS2g/LmLrLlb6lKDCxtXaXGsTF1cPYXR
         Yf9L/yBYDWcK+0GKQScCuQCENTeoDQoNRHAP1miPGeCYcuScpp8xi3XL/JJ+p+ctcJ0W
         z9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y0w6MnW3oZvs4i15UPLA0/120XiFldb3t4/pTdGFLw0=;
        b=jIMZsDqCG2KMQVKwplOjXK7CNRUP346ihTM3cw6YXjh4Xwccg9S50ea+G+wByd/V+W
         L+Hu39rx3eTJ5ZK2heNq1j3kQSSuqg0LsEpOMkFzyj4O6BjpTzPRp69GhmBIMvvV2Nrq
         cW3HI74qhUVE4UfXpVQTfaepTdo1xPTB3ZKoO7VsSf4Vh1pCXHpB3w8ZCxBO+CN5EI4t
         7LhkDNHNtFkElVcIdrNCvixL9L6+7H+ecSr68rVN5nB+4FURVrWvY9WjGq/Ag57t2Trr
         ZGcxpr8Xy1oh/S3Apfs0/Ka9UDpm5hQukbSglmq2LZ4o25x7GOe8t6qKvog1J2ZYYyjE
         2UoQ==
X-Gm-Message-State: APjAAAXUJ9TM4g6qeztv8uFcNBgyoeLDBqfPA48TJkPof9dEnbe5Jygq
        31e/XA3/56Pp+4M3I9CqZeZQEg==
X-Google-Smtp-Source: APXvYqwytfBf126ULinW5oFqdBQeWvCz2VVUAU2XhFKvinoMG4AvjJx0JLgTIa8YEq6lsKANcL889Q==
X-Received: by 2002:a5d:5708:: with SMTP id a8mr4838423wrv.79.1576137215643;
        Wed, 11 Dec 2019 23:53:35 -0800 (PST)
Received: from localhost.localdomain ([212.45.67.2])
        by smtp.googlemail.com with ESMTPSA id x6sm5636742wmi.44.2019.12.11.23.53.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 11 Dec 2019 23:53:35 -0800 (PST)
From:   Georgi Djakov <georgi.djakov@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] interconnect: qcom: sdm845: Walk the list safely on node removal
Date:   Thu, 12 Dec 2019 09:53:30 +0200
Message-Id: <20191212075332.16202-3-georgi.djakov@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191212075332.16202-1-georgi.djakov@linaro.org>
References: <20191212075332.16202-1-georgi.djakov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As we will remove items off the list using list_del(), we need to use the
safe version of list_for_each_entry().

Fixes: b5d2f741077a ("interconnect: qcom: Add sdm845 interconnect provider driver")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: <stable@vger.kernel.org> # v5.3+
---
 drivers/interconnect/qcom/sdm845.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/interconnect/qcom/sdm845.c b/drivers/interconnect/qcom/sdm845.c
index 502a6c22b41e..387267ee9648 100644
--- a/drivers/interconnect/qcom/sdm845.c
+++ b/drivers/interconnect/qcom/sdm845.c
@@ -868,9 +868,9 @@ static int qnoc_remove(struct platform_device *pdev)
 {
 	struct qcom_icc_provider *qp = platform_get_drvdata(pdev);
 	struct icc_provider *provider = &qp->provider;
-	struct icc_node *n;
+	struct icc_node *n, *tmp;
 
-	list_for_each_entry(n, &provider->nodes, node_list) {
+	list_for_each_entry_safe(n, tmp, &provider->nodes, node_list) {
 		icc_node_del(n);
 		icc_node_destroy(n->id);
 	}
