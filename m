Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C793B27C60F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730641AbgI2LlT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729924AbgI2LlS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:41:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEDE2206DB;
        Tue, 29 Sep 2020 11:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379677;
        bh=ixzpbqLb4xocEfRBNC7ZiSrrGa/FbibEd/KqN8FpI8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5q01zyHKYafkuoL6kFR5FC3Mhbyo1itDULQZk8NgTt99WFgRnN8MsQFiwwBLgH+I
         912g3l5EOacnDlvYiKJLaiwdMknWppvMt2084vc2797dkRiUWeT91E6QfaTmElDdqL
         HtirWbepdy9xo86fRwWP92w/VNNgvUQfpUpfob8I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 269/388] scsi: cxlflash: Fix error return code in cxlflash_probe()
Date:   Tue, 29 Sep 2020 13:00:00 +0200
Message-Id: <20200929110023.483080948@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



