Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34F327CB24
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbgI2MYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729721AbgI2Lew (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:34:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D145523BE2;
        Tue, 29 Sep 2020 11:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378871;
        bh=YdXmMUMcrIidM4jJ5bBCr8dU2Vox3/LTnIzsgfEFBrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaM35SexFkt6/fa9jw1WwbtG3OTMDP0EtzeQ9WbjlNnV5Jmico3MgBUpqIYg1At8U
         t+3TTXNh9PkR4WAGMx+v8M7ReZLuNUSAekOr/AOC5SzDQMMb44h8UcpLaxbIjY1GLU
         4zezY787FkqoJKLKY/5txFscjAVtquIGGnLwlNqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 168/245] scsi: cxlflash: Fix error return code in cxlflash_probe()
Date:   Tue, 29 Sep 2020 13:00:19 +0200
Message-Id: <20200929105955.155000540@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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



