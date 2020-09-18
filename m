Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7000226EC68
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbgIRCLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:11:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728642AbgIRCL0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A949208DB;
        Fri, 18 Sep 2020 02:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395086;
        bh=YdXmMUMcrIidM4jJ5bBCr8dU2Vox3/LTnIzsgfEFBrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aa65o8pSdeqww05bSybePijfbgPRsyaboY3sl7nhfLRzqtujQj/Z4gQzcsatm3TEO
         skMvHaJ7lZAMl5Ay9+GtdIn7fOBxTgnYzXesPR1/goKKpt+ovFgJfP2dTgdJXFQxLC
         2Uvv85L8DKU45WK4Zt5SElQvgXq32wJupugi9isM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "Matthew R . Ochs" <mrochs@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 168/206] scsi: cxlflash: Fix error return code in cxlflash_probe()
Date:   Thu, 17 Sep 2020 22:07:24 -0400
Message-Id: <20200918020802.2065198-168-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
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
index f987c40c47a13..443813feaef47 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3749,6 +3749,7 @@ static int cxlflash_probe(struct pci_dev *pdev,
 	cfg->afu_cookie = cfg->ops->create_afu(pdev);
 	if (unlikely(!cfg->afu_cookie)) {
 		dev_err(dev, "%s: create_afu failed\n", __func__);
+		rc = -ENOMEM;
 		goto out_remove;
 	}
 
-- 
2.25.1

