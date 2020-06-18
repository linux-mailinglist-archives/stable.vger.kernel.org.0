Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9A01FE652
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgFRBOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729365AbgFRBOt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:14:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A584E221ED;
        Thu, 18 Jun 2020 01:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442888;
        bh=IgNxQZbR1gZR1QJHVrko2DBUykRdC1v95tFrjcV+KKg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VvLev73I+gep7i5Six6n4RxjUTSzYcpuPTjmQkAGK3P0lyKeQMczEI/3SRAXzCXYl
         m5ryyl66qG/pCLm3CaTBBhwSCQni6tfQZhQtjnJYY+nnOxhxuyDAKsG7B1e52+cc5P
         NCHcedih61Ljk4WH1fo4C7Oq0ix19IQo6zbmr/cw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 311/388] mailbox: zynqmp-ipi: Fix NULL vs IS_ERR() check in zynqmp_ipi_mbox_probe()
Date:   Wed, 17 Jun 2020 21:06:48 -0400
Message-Id: <20200618010805.600873-311-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 445aeeb569f8d7904f8cf80b7c6826bb651ef80e ]

In case of error, the function devm_ioremap() returns NULL pointer not
ERR_PTR(). So we should check whether the return value of devm_ioremap()
is NULL instead of IS_ERR.

Fixes: 4981b82ba2ff ("mailbox: ZynqMP IPI mailbox controller")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/zynqmp-ipi-mailbox.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/mailbox/zynqmp-ipi-mailbox.c b/drivers/mailbox/zynqmp-ipi-mailbox.c
index 86887c9a349a..f9cc674ba9b7 100644
--- a/drivers/mailbox/zynqmp-ipi-mailbox.c
+++ b/drivers/mailbox/zynqmp-ipi-mailbox.c
@@ -504,10 +504,9 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 		mchan->req_buf_size = resource_size(&res);
 		mchan->req_buf = devm_ioremap(mdev, res.start,
 					      mchan->req_buf_size);
-		if (IS_ERR(mchan->req_buf)) {
+		if (!mchan->req_buf) {
 			dev_err(mdev, "Unable to map IPI buffer I/O memory\n");
-			ret = PTR_ERR(mchan->req_buf);
-			return ret;
+			return -ENOMEM;
 		}
 	} else if (ret != -ENODEV) {
 		dev_err(mdev, "Unmatched resource %s, %d.\n", name, ret);
@@ -520,10 +519,9 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 		mchan->resp_buf_size = resource_size(&res);
 		mchan->resp_buf = devm_ioremap(mdev, res.start,
 					       mchan->resp_buf_size);
-		if (IS_ERR(mchan->resp_buf)) {
+		if (!mchan->resp_buf) {
 			dev_err(mdev, "Unable to map IPI buffer I/O memory\n");
-			ret = PTR_ERR(mchan->resp_buf);
-			return ret;
+			return -ENOMEM;
 		}
 	} else if (ret != -ENODEV) {
 		dev_err(mdev, "Unmatched resource %s.\n", name);
@@ -543,10 +541,9 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 		mchan->req_buf_size = resource_size(&res);
 		mchan->req_buf = devm_ioremap(mdev, res.start,
 					      mchan->req_buf_size);
-		if (IS_ERR(mchan->req_buf)) {
+		if (!mchan->req_buf) {
 			dev_err(mdev, "Unable to map IPI buffer I/O memory\n");
-			ret = PTR_ERR(mchan->req_buf);
-			return ret;
+			return -ENOMEM;
 		}
 	} else if (ret != -ENODEV) {
 		dev_err(mdev, "Unmatched resource %s.\n", name);
@@ -559,10 +556,9 @@ static int zynqmp_ipi_mbox_probe(struct zynqmp_ipi_mbox *ipi_mbox,
 		mchan->resp_buf_size = resource_size(&res);
 		mchan->resp_buf = devm_ioremap(mdev, res.start,
 					       mchan->resp_buf_size);
-		if (IS_ERR(mchan->resp_buf)) {
+		if (!mchan->resp_buf) {
 			dev_err(mdev, "Unable to map IPI buffer I/O memory\n");
-			ret = PTR_ERR(mchan->resp_buf);
-			return ret;
+			return -ENOMEM;
 		}
 	} else if (ret != -ENODEV) {
 		dev_err(mdev, "Unmatched resource %s.\n", name);
-- 
2.25.1

