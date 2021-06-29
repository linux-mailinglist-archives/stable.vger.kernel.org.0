Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1974B3B758D
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 17:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhF2Pf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 11:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234718AbhF2Pf1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 11:35:27 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA915C061760
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 08:32:59 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id 21so17496382pfp.3
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 08:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8u9/LGHCVwZ4midNSAwp0N6rAWr4KVJQJiuvperVNgM=;
        b=cEDzvMJSf0V/qxS792iiW7NtANHon/YY/N4MPAq+K+5xEQgpqY43aNa4uy2J0526WD
         hKc9tjpd+YRD003F0FPzxwcuHPW78q0epDHUcvNjH2zTxlS2g0FeyBw4KOAH9r7OdGq4
         qqrH+2IryC/LKBTWoqL1wZuInSfMVch5La0d9zI42Cd50cbjEl8RKXXJi3UT/0E6ycXW
         +UTJfkkEeIupxO1T7jbux79yHmLNf1TE9TnsF/m60f5uNw9j5sue8Mf3BldZvWqqwQOj
         NrLjzX99DqL3KhV7gLshphXaaUJIBWv95KGy8fAJtSFChaxKXdKYXfOb7amtp78XBP5Y
         OUcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8u9/LGHCVwZ4midNSAwp0N6rAWr4KVJQJiuvperVNgM=;
        b=e56PhEkE7foOc6noDhpLgdDp2VtRZEMHyS9rlT3PWx00VIINdeSBgwgVNpGpXYCfWF
         9/zGuAWegPgj7IUEL1S0zDdFSfKeM45ZMc+yYIK679/6IV8VnzXVFE27AALMFS5PeIYQ
         IjAkTt1M7YgkgUNblbepqR6NO3BXY+Gij0XjdGaiOtSoKTqqm8WM+zMyojWV/ZMJP2Qb
         V7jOlNhq4fYHjXxse1eHjf9zMyT//YMtGuFouHuASSmi6d1XQfuy9rndGfJETRRnU4mC
         6+Z1qXF9GaNn8nUF6pFDRBVoml211fU9WsDr94dKitUrSgO70R3fefdxzis9P52Vm4sp
         FTWA==
X-Gm-Message-State: AOAM533tF1Nds6YR82vSNgBO7joYxkYXLRod5rWApYaVcXQWK6V+VnKj
        +NXJ1+ygz4HOc3e68WTQJznv
X-Google-Smtp-Source: ABdhPJysVqI66UwzRIgh1c12A4alGfEK+kITLiKGfsqSVoSssWy+HtYu9/kKugkTBFW7BHGO2SSX7Q==
X-Received: by 2002:a63:4a53:: with SMTP id j19mr28440176pgl.144.1624980779312;
        Tue, 29 Jun 2021 08:32:59 -0700 (PDT)
Received: from localhost.localdomain ([120.138.12.32])
        by smtp.gmail.com with ESMTPSA id s79sm11444492pfc.87.2021.06.29.08.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 08:32:58 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     bjorn.andersson@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        thara.gopinath@linaro.org, mka@chromium.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] soc: qcom: aoss: Fix the out of bound usage of cooling_devs
Date:   Tue, 29 Jun 2021 21:02:49 +0530
Message-Id: <20210629153249.73428-1-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Changes in v2:

* Used QMP_NUM_COOLING_RESOURCES directly and initialized count to 0

 drivers/soc/qcom/qcom_aoss.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/qcom/qcom_aoss.c b/drivers/soc/qcom/qcom_aoss.c
index 934fcc4d2b05..7b6b94332510 100644
--- a/drivers/soc/qcom/qcom_aoss.c
+++ b/drivers/soc/qcom/qcom_aoss.c
@@ -476,12 +476,12 @@ static int qmp_cooling_device_add(struct qmp *qmp,
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
 
@@ -497,12 +497,16 @@ static int qmp_cooling_devices_register(struct qmp *qmp)
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
-- 
2.25.1

