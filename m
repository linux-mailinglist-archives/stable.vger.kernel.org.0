Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E37B11C6B4
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 08:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728214AbfLLHxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 02:53:39 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43632 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbfLLHxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 02:53:39 -0500
Received: by mail-wr1-f68.google.com with SMTP id d16so1570630wre.10
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 23:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ok0nQnxyVp+hWourd2iRYkQMDbNDd797Oi+3MDLgvE=;
        b=kuBwZF3aTUHamxKahISgDPfpkTVxpBWPErTUxDu8tvilS/xaRc3rm9NfU4I6x4KXsZ
         ZstbdCSaaVFHD07vHcFFvZRa6afY74PXr4bIkBz7g3Tlel5xeUfBh1nGCq4vaGK1US5W
         EPmSF9L41f5LHog3fQib1Q3H4aTGpyh1uQn5pLKvx5bday1E3nvG8tXShjGW507ItW4X
         dHMRdOEhHXXNCmKe8jA6j4ZxIec/a2dDFUPoLSeCc/kcwNXRlE3cmUXidsrOcFLm3Wss
         0Vfrm+hMFh/WZF3hckaFO9jIIEklzubZWt7sSLrhO8VjiS9j/gPtkwA2/cWqiJhfs32i
         NoZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ok0nQnxyVp+hWourd2iRYkQMDbNDd797Oi+3MDLgvE=;
        b=riuiwN1rdTZMak/bbkgD2UQKTdYmJvOCpkm36zGXGzjKn3OSsVyDDf17g23SsSauxn
         TicreCDIlUf0B24pKYmdYMMbe3TLAH+oXFEdFrKhf/aXKaoX5Vgi9GA3AGKYocLejBh1
         Li/Le876URWTY/4HuhuUxKd1KCgvADyE920NNhQjp5+kCPRxsDcMXYcc4n7hoUnPTPh7
         676PwBlOihwo/W2CrunQJc/hSbRBWJMVsVhQkkeeuY4cmsLAim5V+uvyrYvgfD1khO49
         XFatrroCmPq6VnSOZk1UFu45+VD2n2sChauPXaqJeOwL3aIUFV5UF/FpnJFgDc+HeAt7
         ZJfw==
X-Gm-Message-State: APjAAAWivrJD9cmH+k0c0MlHXYYI/nsOKvbnKA7GjnFbA1uBKgI3f0hF
        80MtdgvkhgaJD9thHbBtfXhw4Q==
X-Google-Smtp-Source: APXvYqzPziPpJRFVzoBFwbFJvLDT14cwri/geZerVfDTVoysW08yVdQwFE9ukJgLmSRP+uRdNA+GFA==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr4623170wro.202.1576137216719;
        Wed, 11 Dec 2019 23:53:36 -0800 (PST)
Received: from localhost.localdomain ([212.45.67.2])
        by smtp.googlemail.com with ESMTPSA id x6sm5636742wmi.44.2019.12.11.23.53.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 11 Dec 2019 23:53:36 -0800 (PST)
From:   Georgi Djakov <georgi.djakov@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 3/4] interconnect: qcom: qcs404: Walk the list safely on node removal
Date:   Thu, 12 Dec 2019 09:53:31 +0200
Message-Id: <20191212075332.16202-4-georgi.djakov@linaro.org>
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

Fixes: 5e4e6c4d3ae0 ("interconnect: qcom: Add QCS404 interconnect provider driver")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Georgi Djakov <georgi.djakov@linaro.org>
Cc: <stable@vger.kernel.org> # v5.4
---
 drivers/interconnect/qcom/qcs404.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/interconnect/qcom/qcs404.c b/drivers/interconnect/qcom/qcs404.c
index b4966d8f3348..8e0735a87040 100644
--- a/drivers/interconnect/qcom/qcs404.c
+++ b/drivers/interconnect/qcom/qcs404.c
@@ -414,7 +414,7 @@ static int qnoc_probe(struct platform_device *pdev)
 	struct icc_provider *provider;
 	struct qcom_icc_node **qnodes;
 	struct qcom_icc_provider *qp;
-	struct icc_node *node;
+	struct icc_node *node, *tmp;
 	size_t num_nodes, i;
 	int ret;
 
@@ -494,7 +494,7 @@ static int qnoc_probe(struct platform_device *pdev)
 
 	return 0;
 err:
-	list_for_each_entry(node, &provider->nodes, node_list) {
+	list_for_each_entry_safe(node, tmp, &provider->nodes, node_list) {
 		icc_node_del(node);
 		icc_node_destroy(node->id);
 	}
@@ -508,9 +508,9 @@ static int qnoc_remove(struct platform_device *pdev)
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
