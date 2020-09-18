Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5474526F21E
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgIRC43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgIRCHF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF454238E6;
        Fri, 18 Sep 2020 02:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394809;
        bh=ixzpbqLb4xocEfRBNC7ZiSrrGa/FbibEd/KqN8FpI8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ap72OSeIz0WbzUgl+Z60m1skAI2lTH6zu9KjGTAl0zUjtcPchJOt0LyRthlJkmEo5
         fL/in4QHIiWkt3fZkh5uj4v+uobt0LkOJqI5dzfrW8+LgB4nq+tVs/JwFT+2gXWsRA
         82yUkSr5h7qZcTNiqJAzUo3A5tshX8kZWMRtr67o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "Matthew R . Ochs" <mrochs@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 277/330] scsi: cxlflash: Fix error return code in cxlflash_probe()
Date:   Thu, 17 Sep 2020 22:00:17 -0400
Message-Id: <20200918020110.2063155-277-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit d0b1e4a638d670a09f42017a3e567dc846931ba8 ]

Fix to return negative error code -ENOMEM from create_afu error handling
case instead of 0, as done elsewhere in this function.

Link: https://lore.kernel.org/r/20200428141855.88704-1-weiyongjun1@huawei.com
Acked-by: Matthew R. Ochs <mrochs@linux.ibm.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/cxlflash/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 93ef97af22df4..67d681c53c295 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3746,6 +3746,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->afu_cookie = cfg->ops->create_afu(pdev);
 	if (unlikely(!cfg->afu_cookie)) {
 		dev_err(dev, "%s: create_afu failed\n", __func__);
+		rc = -ENOMEM;
 		goto out_remove;
 	}
 
-- 
2.25.1

