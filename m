Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D05E37C158
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 16:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbhELO6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 10:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231633AbhELO5L (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 10:57:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5131561413;
        Wed, 12 May 2021 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831338;
        bh=/pXEdHyVponq2LhPnWDLZ2uzzOfZ8EHWJA+SVhcPEMA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fIyxkVqEQySu50N4b3VhWsBbG6QRcRwaswAjRUyCyaG0IvJjlX4/TImOOBKKVmDTW
         eCcFOWMYkgo5jjn7qlcU+8MISMJhVlp5JXoryHyhU/Or96KMD3V887xysDM1KFklyZ
         7aU/LA9T5r5lre7AHQI+HdhsPJApE2EfnkVRs+sI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/244] mtd: rawnand: qcom: Return actual error code instead of -ENODEV
Date:   Wed, 12 May 2021 16:47:30 +0200
Message-Id: <20210512144745.560142809@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 55fbb9ba4f06cb6aff32daca1e1910173c13ec51 ]

In qcom_probe_nand_devices() function, the error code returned by
qcom_nand_host_init_and_register() is converted to -ENODEV in the case
of failure. This poses issue if -EPROBE_DEFER is returned when the
dependency is not available for a component like parser.

So let's restructure the error handling logic a bit and return the
actual error code in case of qcom_nand_host_init_and_register() failure.

Fixes: c76b78d8ec05 ("mtd: nand: Qualcomm NAND controller driver")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 963ebcdfcbce..c10995ca624a 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2850,7 +2850,7 @@ static int qcom_probe_nand_devices(struct qcom_nand_controller *nandc)
 	struct device *dev = nandc->dev;
 	struct device_node *dn = dev->of_node, *child;
 	struct qcom_nand_host *host;
-	int ret;
+	int ret = -ENODEV;
 
 	for_each_available_child_of_node(dn, child) {
 		host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
@@ -2868,10 +2868,7 @@ static int qcom_probe_nand_devices(struct qcom_nand_controller *nandc)
 		list_add_tail(&host->node, &nandc->host_list);
 	}
 
-	if (list_empty(&nandc->host_list))
-		return -ENODEV;
-
-	return 0;
+	return ret;
 }
 
 /* parse custom DT properties here */
-- 
2.30.2



