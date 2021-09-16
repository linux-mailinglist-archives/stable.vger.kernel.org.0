Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C4640E51B
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349947AbhIPRH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244810AbhIPRF5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:05:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 702C161929;
        Thu, 16 Sep 2021 16:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810145;
        bh=9Il0Hw1D98NLQ7HT7OgkMPuWKBxbTH4IlNe5LuYf0rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVx2ttMUL0t8at7Ojx2TjffzW25eifDjpdort0nTAIw85QtGsQt4dMv4n8EUI7nvm
         5H8gu0iTxzyqUbi6Rx5YBROCOmMqSxtLM8iSUi42yiuoxciqBsuZNYxO0HpRlAkwpp
         2GvBlRTEgFe7c2IbTaOXgjHqfn/WtAQ5LwSAqgxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.14 034/432] soc: qcom: aoss: Fix the out of bound usage of cooling_devs
Date:   Thu, 16 Sep 2021 17:56:23 +0200
Message-Id: <20210916155811.973938127@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit a89f355e469dcda129c2522be4fdba00c1c74c83 upstream.

In "qmp_cooling_devices_register", the count value is initially
QMP_NUM_COOLING_RESOURCES, which is 2. Based on the initial count value,
the memory for cooling_devs is allocated. Then while calling the
"qmp_cooling_device_add" function, count value is post-incremented for
each child node.

This makes the out of bound access to the cooling_dev array. Fix it by
passing the QMP_NUM_COOLING_RESOURCES definition to devm_kzalloc() and
initializing the count to 0.

While at it, let's also free the memory allocated to cooling_dev if no
cooling device is found in DT and during unroll phase.

Cc: stable@vger.kernel.org # 5.4
Fixes: 05589b30b21a ("soc: qcom: Extend AOSS QMP driver to support resources that are used to wake up the SoC.")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210629153249.73428-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/qcom_aoss.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -476,12 +476,12 @@ static int qmp_cooling_device_add(struct
 static int qmp_cooling_devices_register(struct qmp *qmp)
 {
 	struct device_node *np, *child;
-	int count = QMP_NUM_COOLING_RESOURCES;
+	int count = 0;
 	int ret;
 
 	np = qmp->dev->of_node;
 
-	qmp->cooling_devs = devm_kcalloc(qmp->dev, count,
+	qmp->cooling_devs = devm_kcalloc(qmp->dev, QMP_NUM_COOLING_RESOURCES,
 					 sizeof(*qmp->cooling_devs),
 					 GFP_KERNEL);
 
@@ -497,12 +497,16 @@ static int qmp_cooling_devices_register(
 			goto unroll;
 	}
 
+	if (!count)
+		devm_kfree(qmp->dev, qmp->cooling_devs);
+
 	return 0;
 
 unroll:
 	while (--count >= 0)
 		thermal_cooling_device_unregister
 			(qmp->cooling_devs[count].cdev);
+	devm_kfree(qmp->dev, qmp->cooling_devs);
 
 	return ret;
 }


